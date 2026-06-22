pageextension 60007 "Price List Line Review" extends "Price List Line Review"   //7005
{
    layout
    {
        modify(Description)
        {
            Visible = true;

            trigger OnDrillDown()
            var
                Item: Record Item;
            begin
                if Rec."Asset Type" = Rec."Asset Type"::Item then
                    if Item.Get(Rec."Asset No.") then
                        Page.Run(Page::"Item Card", Item);
            end;
        }
        modify("Line Discount %")
        {
            Visible = true;
        }
        modify("Variant Code")
        {
            Caption = 'Marca';
        }
        modify("Starting Date")
        {
            Editable = true;
        }
        modify("Ending Date")
        {
            Editable = true;
        }
        addafter("Source No.")
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
                ToolTip = 'Displays the name of the vendor.';
                Editable = false;
            }
            field("Vendor Search Name"; VendorSearchName)
            {
                ApplicationArea = All;
                Caption = 'Alias';
                ToolTip = 'Displays the search name of the vendor.';
                Editable = false;
            }
        }
        addafter("Variant Code")
        {
            field("Best Vendor"; Rec."Best Vendor")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the vendor is the best option for this item.';

                trigger OnValidate()
                begin
                    ValidateBestVendor();
                    //JMC 18/06/2024 - Se añade llamada a procedimiento para actualizar la información del proveedor en el producto
                    //ModifyItemVendorInfo();
                end;
            }
        }
        addlast(Control1)
        {
            field("Amount Discount"; Rec."Amount Discount")
            {
                ApplicationArea = All;
                Caption = 'Amount Discount';
                ToolTip = 'Displays the calculated amount of discount based on the direct unit cost and line discount percentage.';
                Editable = false;
            }
            field("Comments"; Rec."Comments")
            {
                ApplicationArea = All;
                ToolTip = 'Additional comments regarding the price list line.';
                Editable = true;
            }
        }
    }

    actions
    {
        modify(OpenPriceList)
        {
            Visible = false;
        }
        modify(PurchPriceLists)
        {
            Visible = false;
        }
        modify(PurchJobPriceLists)
        {
            Visible = false;
        }
        modify(VerifyLines)
        {
            Visible = false;
        }
        addafter(OpenPriceList)
        {
            action(OpenPriceListFiltered)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Open Price List';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Opens the price list for the current line, filtering by the item.';

                trigger OnAction()
                var
                    PriceListHeader: Record "Price List Header";
                    FilterHelper: Codeunit "CP Price List Filter Helper";
                begin
                    if (Rec."Asset Type" = Rec."Asset Type"::Item) and (Rec."Asset No." <> '') then
                        FilterHelper.SetPendingItemFilter(Rec."Asset No.");

                    if PriceListHeader.Get(Rec."Price List Code") then
                        case PriceListHeader."Price Type" of
                            "Price Type"::Purchase:
                                Page.Run(Page::"Purchase Price List", PriceListHeader);
                            "Price Type"::Sale:
                                Page.Run(Page::"Sales Price List", PriceListHeader);
                        end;
                end;
            }
        }
        addafter(VerifyLines)
        {
            action(CPVerifyLines)
            {
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = CheckDuplicates;
                Caption = 'Verify Lines';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Verifica líneas, activa borradores, sincroniza componentes de LM con Best Vendor y recalcula costes de recetas.';

                trigger OnAction()
                var
                    PriceListLine: Record "Price List Line";
                    PriceListManagement: Codeunit "Price List Management";
                    DraftItemNos: List of [Code[20]];
                begin
                    // 1. Recopilar productos en estado borrador antes de activar
                    CollectDraftItemNos(DraftItemNos);

                    //JMC 22/06/2026 -  Cogemos el precio del mejor proveedor anterior a la activación
                    findPreviousBestVendorLine(Rec."Asset No.", PriceListLine);
                    PreviousPriceGlobal := PriceListLine."Amount Discount";

                    // 2. Ejecutar la verificación estándar (activa líneas borrador)
                    PriceListLine.Copy(Rec);
                    PriceListManagement.ActivateDraftLines(PriceListLine);

                    // 3. Sincronizar componentes de LM y procesar fluctuaciones
                    SyncBOMComponentsAndProcessRecipes(DraftItemNos);

                    // JMC 18/06/2024 - Se añade llamada a procedimiento para actualizar la información del proveedor en el producto
                    ModifyItemVendorInfo();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec."Amount Discount" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
        GetVendorInfo();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        Rec."Amount Discount" := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
        GetVendorInfo();
    end;

    var
        VendorName: Text[100];
        VendorSearchName: Code[100];

    local procedure ValidateBestVendor()
    var
        PriceListLine: Record "Price List Line";
        ConfirmQst: Label 'Do you want to set this vendor as the best for item %1? There is currently another vendor marked as the best.', Comment = '%1 = Item No.';
    begin
        if not Rec."Best Vendor" then
            exit;

        if Rec."Asset Type" <> Rec."Asset Type"::Item then
            exit;

        PriceListLine.SetRange("Asset Type", Rec."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", Rec."Asset No.");
        PriceListLine.SetRange("Best Vendor", true);
        PriceListLine.SetFilter("Line No.", '<>%1', Rec."Line No.");

        if PriceListLine.FindFirst() then begin
            if not Confirm(ConfirmQst, false, Rec."Asset No.") then begin
                Rec."Best Vendor" := false;
                exit;
            end;

            PriceListLine."Best Vendor" := false;
            PriceListLine.Modify(true);
        end;
    end;

    local procedure GetVendorInfo()
    var
        Vendor: Record Vendor;
    begin
        Clear(VendorName);
        Clear(VendorSearchName);

        if Rec."Source No." = '' then
            exit;

        if Vendor.Get(Rec."Source No.") then begin
            VendorName := Vendor.Name;
            VendorSearchName := Vendor."Search Name";
        end;
    end;

    local procedure CollectDraftItemNos(var DraftItemNos: List of [Code[20]])
    var
        DraftLine: Record "Price List Line";
    begin
        DraftLine.Copy(Rec);
        DraftLine.SetRange(Status, "Price Status"::Draft);
        DraftLine.SetRange("Asset Type", DraftLine."Asset Type"::Item);
        DraftLine.SetFilter("Asset No.", '<>%1', '');
        if DraftLine.FindSet() then
            repeat
                if not DraftItemNos.Contains(DraftLine."Asset No.") then
                    DraftItemNos.Add(DraftLine."Asset No.");
            until DraftLine.Next() = 0;
    end;

    local procedure SyncBOMComponentsAndProcessRecipes(DraftItemNos: List of [Code[20]])
    var
        BOMComponent: Record "BOM Component";
        BestVendorLine: Record "Price List Line";
        PreviousBestVendorLine: Record "Price List Line";
        Item: Record Item;
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
        ItemNo: Code[20];
        ParentItemNo: Code[20];
        ProcessedRecipes: List of [Code[20]];
        ProcessedItemsForDetails: List of [Code[20]];
        ItemDetailRows: Text;
        DetailsHtml: Text;
        PreviousPrice: Decimal;
        NewPrice: Decimal;
        DetailCaptured: Boolean;
        UpdatedComponents: Integer;
    begin
        if DraftItemNos.Count() = 0 then begin
            Message(VerifyNoItemsMsg);
            exit;
        end;

        RecipeFluctuationMgt.ClearEmailBuffer();
        RecipeFluctuationMgt.SetEmailTriggerSource(TriggerVerifyLinesLbl);
        RecipeFluctuationMgt.SetSuppressMessages(true);

        foreach ItemNo in DraftItemNos do
            if FindBestVendorLine(ItemNo, BestVendorLine) then begin
                BOMComponent.Reset();
                BOMComponent.SetRange(Type, BOMComponent.Type::Item);
                BOMComponent.SetRange("No.", ItemNo);
                DetailCaptured := false;
                if BOMComponent.FindSet() then
                    repeat
                        if (not DetailCaptured) and (not ProcessedItemsForDetails.Contains(ItemNo)) then begin
                            //JMC 18/06/2024 - Se añade lógica para capturar el nuevo precio desde la línea de mejor proveedor anterior
                            PreviousPrice := previouspriceGlobal;
                            NewPrice := BestVendorLine."Direct Unit Cost";
                            if PreviousPrice <> NewPrice then
                                if Item.Get(ItemNo) then
                                    ItemDetailRows += StrSubstNo(RowTdLbl, ItemNo, Item.Description, GetItemTypeLabel(Item."No. Series"), Format(PreviousPrice), Format(NewPrice));
                            ProcessedItemsForDetails.Add(ItemNo);
                            DetailCaptured := true;
                        end;

                        BOMComponent."Proveedor por Defecto" := BestVendorLine."Source No.";
                        BOMComponent."Variant Code" := BestVendorLine."Variant Code";
                        BOMComponent.CosteUnitario := BestVendorLine."Direct Unit Cost";
                        BOMComponent.Modify(false);
                        UpdatedComponents += 1;

                        if not ProcessedRecipes.Contains(BOMComponent."Parent Item No.") then
                            ProcessedRecipes.Add(BOMComponent."Parent Item No.");
                    until BOMComponent.Next() = 0;
            end;

        DetailsHtml := BuildItemPriceDetailsHtml(ItemDetailRows);
        if DetailsHtml <> '' then
            RecipeFluctuationMgt.SetEmailTriggerDetails(DetailsHtml);

        // Procesar fluctuaciones para recetas padre afectadas
        foreach ParentItemNo in ProcessedRecipes do
            RecipeFluctuationMgt.ProcessAndFixSingleRecipe(ParentItemNo);

        RecipeFluctuationMgt.FlushConsolidatedEmail();
        RecipeFluctuationMgt.SetSuppressMessages(false);

        if UpdatedComponents > 0 then
            //Message(VerifySuccessMsg, UpdatedComponents, ProcessedRecipes.Count())
            Message(VerifySuccessMsg2, UpdatedComponents)
        else
            Message(VerifyNoRecipesMsg);
    end;

    local procedure FindBestVendorLine(ItemNo: Code[20]; var BestLine: Record "Price List Line"): Boolean
    begin
        BestLine.Reset();
        BestLine.SetRange("Price Type", BestLine."Price Type"::Purchase);
        BestLine.SetRange("Source Type", BestLine."Source Type"::Vendor);
        BestLine.SetRange("Asset Type", BestLine."Asset Type"::Item);
        BestLine.SetRange("Asset No.", ItemNo);
        BestLine.SetRange(Status, BestLine.Status::Active);
        BestLine.SetRange("Best Vendor", true);
        exit(BestLine.FindFirst());
    end;

    local procedure FindPreviousBestVendorLine(ItemNo: Code[20]; var BestLine: Record "Price List Line"): Boolean
    begin
        BestLine.Reset();
        BestLine.SetRange("Price Type", BestLine."Price Type"::Purchase);
        BestLine.SetRange("Source Type", BestLine."Source Type"::Vendor);
        BestLine.SetRange("Asset Type", BestLine."Asset Type"::Item);
        BestLine.SetRange("Asset No.", ItemNo);
        BestLine.SetRange(Status, BestLine.Status::Draft);
        BestLine.SetRange("Best Vendor", false);
        exit(BestLine.FindFirst());
    end;

    local procedure BuildItemPriceDetailsHtml(RowsHtml: Text): Text
    var
        DetailsHtml: Text;
    begin
        if RowsHtml = '' then
            exit('');
        DetailsHtml := ItemPriceDetailsHdrLbl;
        DetailsHtml += TableOpenLbl;
        DetailsHtml += TableHdrLbl;
        DetailsHtml += RowsHtml;
        DetailsHtml += TableCloseLbl;
        exit(DetailsHtml);
    end;

    local procedure GetItemTypeLabel(NoSeries: Code[20]): Text
    begin
        case NoSeries of
            'M_MP':
                exit('MP');
            'M_MA':
                exit('MA');
            'M_PI':
                exit('PI');
            'M_PT':
                exit('PT');
        end;
        exit(NoSeries);
    end;

    //JMC 18/06/2024 - Procedimiento para actualizar la información del proveedor en el producto
    procedure ModifyItemVendorInfo()
    var
        Item: Record Item;
    begin
        // Implementación de la lógica para actualizar la información del proveedor en el producto
        // Esta función se llamará después de validar el mejor proveedor
        // y actualizará los campos relevantes en la tabla de productos según sea necesario.
        if Rec."Source Type" = Rec."Source Type"::Vendor then begin
            clear(Item);
            Item.setRange("No.", Rec."Asset No.");
            if Item.findFirst() then begin
                Item.validate("Vendor No.", Rec."Source No.");
                Item.Modify(true);
            end;
        end;
    end;

    var
        PreviousPriceGlobal: Decimal;
        TriggerVerifyLinesLbl: Label 'Verificación de líneas de precios';
        VerifySuccessMsg: Label 'Proceso completado correctamente.\Se han actualizado %1 componentes de LM y recalculado %2 recetas.', Comment = '%1 = Updated components, %2 = Processed recipes';
        VerifySuccessMsg2: Label 'Proceso completado correctamente.\Se han actualizado %1 componentes de LM.', Comment = '%1 = Updated components';
        VerifyNoItemsMsg: Label 'No se encontraron líneas en estado borrador con productos para procesar.';
        VerifyNoRecipesMsg: Label 'Verificación completada. No se encontraron componentes de LM afectados por los productos modificados.';
        ItemPriceDetailsHdrLbl: Label '<h3>Items with price changes</h3>';
        TableOpenLbl: Label '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">', Locked = true;
        TableHdrLbl: Label '<tr style="background-color:#333;color:#fff;"><th>Code</th><th>Description</th><th>Type</th><th>Previous Price</th><th>New Price</th></tr>', Comment = '#333 and #fff are HTML hex color codes, not placeholders.';
        TableCloseLbl: Label '</table>', Locked = true;
        RowTdLbl: Label '<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td>%5</td></tr>', Locked = true;
}