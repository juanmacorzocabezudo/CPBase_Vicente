codeunit 60000 "Table Events"
{
    #region "Purchase Line" 39

    // Evento principal: cuando se introduce un artículo en la línea de pedido
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', true, true)]
    local procedure OnAfterValidateNo(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        PriceListLine: Record "Price List Line";
    begin
        // Solo procesar líneas de tipo Item en Purchase Orders
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;

        if Rec.Type <> Rec.Type::Item then
            exit;

        if Rec."No." = '' then
            exit;

        if Rec."Buy-from Vendor No." = '' then
            exit;

        // Buscar precio en Price List Line
        if FindPriceForItem(Rec, PriceListLine) then
            ApplyPriceAndCalculateProposedPrice(Rec, PriceListLine);
    end;

    // Guardar descuento antes de validar Quantity
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateEvent', 'Quantity', true, true)]
    local procedure OnBeforeValidateQuantity(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        if (Rec."Line Discount %" <> 0) and (Rec.Type = Rec.Type::Item) then
            Rec."Saved Line Discount %" := Rec."Line Discount %";
    end;

    // Recalcular Proposed Price después de validar Quantity
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure OnAfterValidateQuantity(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    begin
        // Restaurar descuento si fue borrado
        if (Rec."Saved Line Discount %" <> 0) and (Rec."Line Discount %" = 0) then begin
            Rec."Line Discount %" := Rec."Saved Line Discount %";
            Rec."Saved Line Discount %" := 0;
        end;

        // Recalcular Proposed Price con los valores actuales
        if (Rec.Type = Rec.Type::Item) and (Rec."No." <> '') then
            CalculateAndSetProposedPrice(Rec);
    end;

    // Buscar precio en Price List Line: primero Best Vendor, sino el más barato
    local procedure FindPriceForItem(PurchLine: Record "Purchase Line"; var PriceListLine: Record "Price List Line"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        BestPriceListLine: Record "Price List Line";
        LowestNetPrice: Decimal;
        CurrentNetPrice: Decimal;
        FoundPrice: Boolean;
    begin
        if not PurchaseHeader.Get(PurchLine."Document Type", PurchLine."Document No.") then
            exit(false);

        // Configurar filtros base
        PriceListLine.Reset();
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", PurchLine."No.");
        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Vendor);
        PriceListLine.SetRange("Source No.", PurchLine."Buy-from Vendor No.");

        // Filtrar por fechas de validez
        if PurchaseHeader."Order Date" <> 0D then begin
            PriceListLine.SetFilter("Starting Date", '%1|<=%2', 0D, PurchaseHeader."Order Date");
            PriceListLine.SetFilter("Ending Date", '%1|>=%2', 0D, PurchaseHeader."Order Date");
        end;

        // PASO 1: Buscar primero el que tenga Best Vendor = true
        PriceListLine.SetRange("Best Vendor", true);
        if PriceListLine.FindFirst() then
            exit(true);

        // PASO 2: Si no hay Best Vendor, buscar el precio más barato (menor precio neto)
        PriceListLine.SetRange("Best Vendor"); // Quitar filtro Best Vendor

        if not PriceListLine.FindSet() then
            exit(false);

        LowestNetPrice := 0;
        FoundPrice := false;

        repeat
            // Calcular precio neto = Direct Unit Cost - descuento
            CurrentNetPrice := PriceListLine."Direct Unit Cost";
            if PriceListLine."Line Discount %" <> 0 then
                CurrentNetPrice := CurrentNetPrice - (CurrentNetPrice * PriceListLine."Line Discount %" / 100);

            // Guardar el de menor precio
            if (not FoundPrice) or (CurrentNetPrice < LowestNetPrice) then begin
                LowestNetPrice := CurrentNetPrice;
                BestPriceListLine := PriceListLine;
                FoundPrice := true;
            end;
        until PriceListLine.Next() = 0;

        if FoundPrice then begin
            PriceListLine := BestPriceListLine;
            exit(true);
        end;

        exit(false);
    end;

    // Aplicar el precio encontrado y calcular Proposed Price
    local procedure ApplyPriceAndCalculateProposedPrice(var PurchLine: Record "Purchase Line"; PriceListLine: Record "Price List Line")
    begin
        // Asignar DIRECTAMENTE sin Validate para evitar que BC ejecute su lógica de precios
        // Esto SOBREESCRIBE cualquier precio que BC haya puesto antes
        PurchLine."Direct Unit Cost" := PriceListLine."Direct Unit Cost";
        PurchLine."Line Discount %" := PriceListLine."Line Discount %";

        // Recalcular Amount y Line Amount basándose en el nuevo precio
        if PurchLine.Quantity <> 0 then begin
            PurchLine."Line Amount" := Round(PurchLine.Quantity * PurchLine."Direct Unit Cost", 0.01);
            if PurchLine."Line Discount %" <> 0 then
                PurchLine."Line Discount Amount" := Round(PurchLine."Line Amount" * PurchLine."Line Discount %" / 100, 0.01);
            PurchLine."Line Amount" := PurchLine."Line Amount" - PurchLine."Line Discount Amount";
        end;

        // Calcular y setear Proposed Price
        CalculateAndSetProposedPrice(PurchLine);
    end;

    // Calcular Proposed Price = Direct Unit Cost - (Direct Unit Cost * Line Discount % / 100)
    local procedure CalculateAndSetProposedPrice(var PurchLine: Record "Purchase Line")
    var
        PriceListLine: Record "Price List Line";
        ProposedPrice: Decimal;
    begin

        clear(PriceListLine);
        clear(ProposedPrice);
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", PurchLine."No.");
        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
        PriceListLine.SetRange("Best Vendor", true);
        if PriceListLine.FindFirst() then
            ProposedPrice := PriceListLine."Amount Discount";


        if ProposedPrice = 0 then begin
            //JMC: Así es como estaba antes de mi cambio 10/06/26
            // Fórmula exacta igual que CalculateNetUnitPrice en la página de Price List
            ProposedPrice := PurchLine."Direct Unit Cost";

            if PurchLine."Line Discount %" <> 0 then
                ProposedPrice := PurchLine."Direct Unit Cost" - (PurchLine."Direct Unit Cost" * PurchLine."Line Discount %" / 100);
        end;

        PurchLine."Proposed Price" := Round(ProposedPrice, 0.001);
    end;

    #endregion

    #region "Price List Line" 7001

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterValidateEvent, 'Direct Unit Cost', false, false)]
    local procedure OnAfterValidatePriceListDirectUnitCost(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; CurrFieldNo: Integer)
    begin
        Rec."Amount Discount" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterValidateEvent, 'Line Discount %', false, false)]
    local procedure OnAfterValidatePriceListLineDiscountPct(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; CurrFieldNo: Integer)
    begin
        Rec."Amount Discount" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterModifyEvent, '', false, false)]
    local procedure OnAfterModifyPriceListLine(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if not IsBestVendorCandidate(Rec) then
            exit;

        if Rec."Best Vendor" <> xRec."Best Vendor" then begin
            UpdateItemVendorFromBestVendor(Rec."Asset Type", Rec."Asset No.");
            exit;
        end;

        if Rec."Best Vendor" then
            if (Rec."Source No." <> xRec."Source No.") or (Rec."Variant Code" <> xRec."Variant Code") then
                UpdateItemVendorFromBestVendor(Rec."Asset Type", Rec."Asset No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterInsertEvent, '', false, false)]
    local procedure OnAfterInsertPriceListLine(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if not IsBestVendorCandidate(Rec) then
            exit;

        if Rec."Best Vendor" then
            UpdateItemVendorFromBestVendor(Rec."Asset Type", Rec."Asset No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", OnAfterDeleteEvent, '', false, false)]
    local procedure OnAfterDeletePriceListLine(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    begin
        if not IsBestVendorCandidate(Rec) then
            exit;

        if Rec."Best Vendor" then
            UpdateItemVendorFromBestVendor(Rec."Asset Type", Rec."Asset No.");
    end;

    local procedure IsBestVendorCandidate(var PriceListLine: Record "Price List Line"): Boolean
    begin
        // Avoid unnecessary execution (and JIT companion-table race conditions)
        // on lines that cannot drive Item's best vendor:
        //  - Only Purchase / Vendor / Item lines are relevant
        //  - Only Active lines represent in-force data; Draft/Inactive must not cascade
        //    (this also prevents firing during bulk Status transitions Active <-> Draft
        //    that triggered the JIT crash on the Price List Lines subform)
        exit(
            (PriceListLine."Price Type" = PriceListLine."Price Type"::Purchase) and
            (PriceListLine."Source Type" = PriceListLine."Source Type"::Vendor) and
            (PriceListLine."Asset Type" = PriceListLine."Asset Type"::Item) and
            (PriceListLine."Asset No." <> '') and
            (PriceListLine.Status = PriceListLine.Status::Active));
    end;

    procedure UpdateItemVendorFromBestVendor(AssetType: Enum "Price Asset Type"; AssetNo: Code[20])
    var
        Item: Record Item;
        PriceListLine: Record "Price List Line";
        NewVendorNo: Code[20];
        NewMarcaProveedor: Code[20];
        NeedModify: Boolean;
    begin
        if AssetType <> AssetType::Item then
            exit;

        if AssetNo = '' then
            exit;

        if not Item.Get(AssetNo) then
            exit;

        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Vendor);
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", AssetNo);
        PriceListLine.SetRange("Best Vendor", true);

        if PriceListLine.FindFirst() then begin
            NewVendorNo := PriceListLine."Source No.";
            NewMarcaProveedor := PriceListLine."Variant Code";
        end else begin
            NewVendorNo := '';
            NewMarcaProveedor := '';
        end;

        if Item."Vendor No." <> NewVendorNo then begin
            Item."Vendor No." := NewVendorNo;
            NeedModify := true;
        end;
        if Item."MarcaProveedor" <> NewMarcaProveedor then begin
            Item."MarcaProveedor" := NewMarcaProveedor;
            NeedModify := true;
        end;

        if NeedModify then begin
            // Modify(false) on purpose: we only touch two flat fields that have already
            // been assigned without Validate. Running Item.OnModify here cascades into
            // Item Vendor Catalog / SKU / Item Reference logic that mutates rowversions
            // of related records and breaks the JIT companion-table load on the
            // Price List Lines subform ("Asset No. changed between initial load and JIT").
            Item."Last Date Modified" := Today();
            Item.Modify(false);
        end;
    end;

    #endregion

    #region "Item" 27

    //JMC - 2026-06-22
    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnItemStatusChanged(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        // OPTIMIZACIÓN: Verificar primero si el status cambió (condición más frecuentemente falsa)
        // Esto evita ejecutar el resto del código en el 99.9% de las modificaciones de Item
        if xRec."Status LM" = Rec."Status LM" then
            exit;

        // Solo procesar si cambió específicamente a "Certificated"
        if Rec."Status LM" <> Rec."Status LM"::Certificated then
            exit;

        if Rec.IsTemporary() then
            exit;

        if not RunTrigger then
            exit;

        // Respetar el flag SuppressEvents para evitar cascadas durante ProcessParentRecipes
        if RecipeFluctuationMgt.IsSuppressEvents() then
            exit;

        ArchiveBOMVersion(Rec);
    end;

    //JMC - 2026-06-22
    local procedure ArchiveBOMVersion(Item: record Item)
    VAR
        BOMComponent: Record "BOM Component";
        RecetaComentarios: Record 50009;
        BOMVersionHeader: Record 50024;
        BOMVersionLines: Record 50025;
        BOMCommentVersion: Record 50026;
        BOMAditionalCost: Record 50029;
        BOMAditionalCostVersion: Record 50029;
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
        ItemRefreshed: Record Item;
        VersionNum: Integer;
        PreviousVersionNum: Integer;
        VersionArchivedMsg: Label 'Recipe version %1 has been successfully archived for item %2.', Comment = '%1 = Version Number, %2 = Item No.';
    BEGIN
        CLEAR(VersionNum);
        CLEAR(PreviousVersionNum);

        BOMComponent.RESET();
        BOMComponent.SETRANGE("Parent Item No.", Item."No.");
        IF BOMComponent.FindSet() THEN BEGIN
            // IMPORTANTE: Recalcular costes ANTES de archivar la versión
            // Esto asegura que la versión archivada refleja los costes actuales calculados
            RecipeFluctuationMgt.FixRecipeCost(Item."No.");

            // Recargar el item con los costes actualizados
            if not ItemRefreshed.Get(Item."No.") then
                ItemRefreshed := Item;

            BOMVersionHeader.Reset();
            BOMVersionHeader.SETRANGE("Item No.", ItemRefreshed."No.");
            IF BOMVersionHeader.FindLast() THEN BEGIN
                PreviousVersionNum := BOMVersionHeader."BOM Version";
                VersionNum := PreviousVersionNum + 1;
            END ELSE
                VersionNum := 1;

            BOMVersionHeader.Init();
            BOMVersionHeader.VALIDATE("Item No.", ItemRefreshed."No.");
            BOMVersionHeader.VALIDATE("BOM Version", VersionNum);
            BOMVersionHeader.VALIDATE(Description, ItemRefreshed.Description);
            BOMVersionHeader.VALIDATE("Base Unit of Measure", ItemRefreshed."Base Unit of Measure");
            BOMVersionHeader.VALIDATE("Lote Receta", ItemRefreshed."Lote Receta");
            BOMVersionHeader.VALIDATE("Statistics Lot", ItemRefreshed."Statistics Lot");
            BOMVersionHeader.VALIDATE("Statistics Unit of Measurement", ItemRefreshed."Statistics Unit of Measurement");
            BOMVersionHeader.VALIDATE("Version Date", WORKDATE());
            BOMVersionHeader.StandarCost := ItemRefreshed."Standard Cost";
            BOMVersionHeader.UnitCost := ItemRefreshed."Unit Cost";
            BOMVersionHeader.CosteLMFijado := ItemRefreshed.Receta_CosteLMFijado;
            BOMVersionHeader.CostesGenerales := CalcAditionalFixedTotalCoste(ItemRefreshed."No.", 0);
            BOMVersionHeader.ExWork := CalcAditionalFixedTotalCoste(ItemRefreshed."No.", 0) + ItemRefreshed.Receta_CosteLMFijado;

            // Copiar el campo Elaboration (BLOB)
            CopyElaborationField(ItemRefreshed, BOMVersionHeader);

            BOMVersionHeader.Insert();
            REPEAT
                BOMVersionLines.Init();
                BOMVersionLines.TRANSFERFIELDS(BOMComponent);
                BOMVersionLines."BOM Version" := VersionNum;
                BOMVersionLines.Insert();
            UNTIL BOMComponent.Next() = 0;

            RecetaComentarios.Reset();
            RecetaComentarios.SETRANGE("No.", ItemRefreshed."No.");
            IF RecetaComentarios.FindSet() THEN
                REPEAT
                    BOMCommentVersion.Init();
                    BOMCommentVersion.TRANSFERFIELDS(RecetaComentarios);
                    BOMCommentVersion."BOM Version" := VersionNum;
                    BOMCommentVersion.Insert();
                UNTIL RecetaComentarios.Next() = 0;

            BOMAditionalCost.Reset();
            BOMAditionalCost.SETRANGE("Item No", ItemRefreshed."No.");
            BOMAditionalCost.SETRANGE("BOM Version", 0);
            IF BOMAditionalCost.FindSet() THEN
                REPEAT
                    BOMAditionalCost.VALIDATE(BOMAditionalCost.Value);

                    BOMAditionalCostVersion.Init();
                    BOMAditionalCostVersion.TRANSFERFIELDS(BOMAditionalCost);
                    BOMAditionalCostVersion."BOM Version" := VersionNum;
                    BOMAditionalCostVersion.Insert();
                UNTIL BOMAditionalCost.Next() = 0;

            // Comparar con versión anterior y enviar email si hay cambios
            IF PreviousVersionNum > 0 THEN
                RecipeFluctuationMgt.CompareAndSendBOMVersionEmail(ItemRefreshed."No.", PreviousVersionNum, VersionNum);

            // Mensaje de confirmación
            MESSAGE(VersionArchivedMsg, VersionNum, ItemRefreshed."No.");
        END;
    END;

    //JMC - 2026-06-22
    local procedure CopyElaborationField(var SourceItem: Record Item; var TargetBOMVersionHeader: Record 50024)
    var
        SourceInStream: InStream;
        TargetOutStream: OutStream;
    begin
        // Copiar el campo Elaboration (BLOB) del Item a BOMVersionHeader
        SourceItem.CalcFields(Elaboration);
        if SourceItem.Elaboration.HasValue() then begin
            SourceItem.Elaboration.CreateInStream(SourceInStream);
            TargetBOMVersionHeader.Elaboration.CreateOutStream(TargetOutStream);
            CopyStream(TargetOutStream, SourceInStream);
        end;
    end;

    //JMC - 2026-06-22
    PROCEDURE CalcAditionalFixedTotalCoste(ItemNo: Code[20]; BOMVersion: Integer) ReturnCost: Decimal;
    VAR
        BOMAditionalCostCheck: Record 50029;
    BEGIN
        CLEAR(ReturnCost);

        BOMAditionalCostCheck.Reset();
        BOMAditionalCostCheck.SETRANGE("Item No", ItemNo);
        BOMAditionalCostCheck.SETRANGE("BOM Version", BOMVersion);
        IF BOMAditionalCostCheck.FindSet() THEN
            REPEAT
                ReturnCost := ReturnCost + BOMAditionalCostCheck."Aditional fixed cost";
            UNTIL BOMAditionalCostCheck.Next() = 0;

        EXIT(ReturnCost);
    END;

    #endregion
}
