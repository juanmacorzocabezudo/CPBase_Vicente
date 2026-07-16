pageextension 60008 "Purchase Price List" extends "Purchase Price List"   //7018
{
    layout
    {
        addafter(Description)
        {
            field(CPNegotiatedPrices; Rec."CP Negotiated Prices")
            {
                ApplicationArea = All;
                Caption = 'Negotiated Prices';
                ToolTip = 'If enabled, price changes in this list will not trigger recipe cost recalculations.';
            }
        }
        addafter(General)
        {
            group(Filters)
            {
                Caption = 'Quick Filters';

                field(FilterVendorNo; VendorNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No. Filter';
                    ToolTip = 'Specifies a filter for which purchase prices to display.';

                    trigger OnValidate()
                    var
                        Vendor: Record Vendor;
                    begin
                        if VendorNoFilter <> '' then begin
                            Vendor.SetFilter("No.", VendorNoFilter);
                            if not Vendor.FindFirst() then begin
                                Vendor.SetRange("No.");
                                Vendor.SetFilter(Name, '@' + VendorNoFilter + '*');
                                if Vendor.FindFirst() then
                                    VendorNoFilter := Vendor."No.";
                            end;
                        end;
                        VendorNoFilterOnAfterValidate();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Vendor: Record Vendor;
                        VendorList: Page "Vendor List";
                    begin
                        VendorList.LookupMode(true);
                        if VendorList.RunModal() = Action::LookupOK then begin
                            VendorList.GetRecord(Vendor);
                            VendorNoFilter := Vendor."No.";
                            VendorNoFilterOnAfterValidate();
                        end;
                    end;
                }

                field(FilterItemNo; ItemNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which purchase prices to display.';

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if ItemNoFilter <> '' then begin
                            Item.SetFilter("No.", ItemNoFilter);
                            if not Item.FindFirst() then begin
                                Item.SetRange("No.");
                                Item.SetFilter(Description, '@' + ItemNoFilter + '*');
                                if Item.FindFirst() then
                                    ItemNoFilter := Item."No.";
                            end;
                        end;
                        ItemNoFilterOnAfterValidate();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            ItemList.GetRecord(Item);
                            ItemNoFilter := Item."No.";
                            ItemNoFilterOnAfterValidate();
                        end;
                    end;
                }

                field(ClearFilters; ClearFiltersLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Filters';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        ClearAllFilters();
                    end;
                }
            }
        }
    }

    actions
    {
        modify(VerifyLines)
        {
            Visible = false;
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

                    // 2. Ejecutar la verificación estándar (activa líneas borrador)
                    PriceListLine.SetRange("Price List Code", Rec.Code);
                    PriceListManagement.ActivateDraftLines(PriceListLine);

                    // 3. Sincronizar componentes de LM y procesar fluctuaciones
                    SyncBOMComponentsAndProcessRecipes(DraftItemNos);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        FilterHelper: Codeunit "CP Price List Filter Helper";
        PendingFilter: Text;
    begin
        if FilterHelper.GetAndClearPendingItemFilter(PendingFilter) then begin
            ItemNoFilter := PendingFilter;
            SetRecFilters();
        end;
    end;

    var
        VendorNoFilter: Text;
        ItemNoFilter: Text;
        ClearFiltersLbl: Label 'Clear All Filters';

    local procedure VendorNoFilterOnAfterValidate()
    begin
        SetRecFilters();
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        SetRecFilters();
    end;

    local procedure SetRecFilters()
    begin
        if VendorNoFilter <> '' then
            CurrPage.Lines.Page.SetVendorFilter(VendorNoFilter)
        else
            CurrPage.Lines.Page.ClearVendorFilter();

        if ItemNoFilter <> '' then
            CurrPage.Lines.Page.SetItemFilter(ItemNoFilter)
        else
            CurrPage.Lines.Page.ClearItemFilter();

        CurrPage.Lines.Page.UpdatePage();
    end;

    local procedure ClearAllFilters()
    begin
        VendorNoFilter := '';
        ItemNoFilter := '';
        CurrPage.Lines.Page.ClearVendorFilter();
        CurrPage.Lines.Page.ClearItemFilter();
        CurrPage.Lines.Page.UpdatePage();
        CurrPage.Update(false);
    end;

    local procedure CollectDraftItemNos(var DraftItemNos: List of [Code[20]])
    var
        DraftLine: Record "Price List Line";
    begin
        DraftLine.SetRange("Price List Code", Rec.Code);
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

        // Si la lista tiene marcado "Precios negociados", solo actualizar componentes sin procesar recetas
        if Rec."CP Negotiated Prices" then begin
            UpdateComponentsOnly(DraftItemNos, UpdatedComponents);
            if UpdatedComponents > 0 then
                Message(NegotiatedPricesMsg, UpdatedComponents)
            else
                Message(VerifyNoRecipesMsg);
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
                            PreviousPrice := BOMComponent.CosteUnitario;
                            NewPrice := BestVendorLine."Direct Unit Cost";
                            if PreviousPrice <> NewPrice then
                                if Item.Get(ItemNo) then
                                    ItemDetailRows += StrSubstNo(RowTdLbl, ItemNo, Item.Description, Item.MarcaProveedor, GetItemTypeLabel(Item."No. Series"), Format(PreviousPrice), Format(NewPrice));
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
            Message(VerifySuccessMsg, UpdatedComponents, ProcessedRecipes.Count())
        else
            Message(VerifyNoRecipesMsg);
    end;

    local procedure UpdateComponentsOnly(DraftItemNos: List of [Code[20]]; var UpdatedComponents: Integer)
    var
        BOMComponent: Record "BOM Component";
        BestVendorLine: Record "Price List Line";
        ItemNo: Code[20];
    begin
        // Actualizar solo componentes de LM sin procesar fluctuaciones de recetas
        foreach ItemNo in DraftItemNos do
            if FindBestVendorLine(ItemNo, BestVendorLine) then begin
                BOMComponent.Reset();
                BOMComponent.SetRange(Type, BOMComponent.Type::Item);
                BOMComponent.SetRange("No.", ItemNo);
                if BOMComponent.FindSet() then
                    repeat
                        BOMComponent."Proveedor por Defecto" := BestVendorLine."Source No.";
                        BOMComponent."Variant Code" := BestVendorLine."Variant Code";
                        BOMComponent.CosteUnitario := BestVendorLine."Direct Unit Cost";
                        BOMComponent.Modify(false);
                        UpdatedComponents += 1;
                    until BOMComponent.Next() = 0;
            end;
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

    var
        TriggerVerifyLinesLbl: Label 'Verificación de líneas de precios de compra';
        NegotiatedPricesMsg: Label '%1 componentes de LM actualizados. Recálculo de costes de recetas omitido (Precios negociados activado).', Comment = '%1 = Number of components';
        VerifySuccessMsg: Label 'Proceso completado correctamente.\Se han actualizado %1 componentes de LM y recalculado %2 recetas.', Comment = '%1 = Updated components, %2 = Processed recipes';
        VerifyNoItemsMsg: Label 'No se encontraron líneas en estado borrador con productos para procesar.';
        VerifyNoRecipesMsg: Label 'Verificación completada. No se encontraron componentes de LM afectados por los productos modificados.';
        ItemPriceDetailsHdrLbl: Label '<h3>Productos con cambio de precio</h3>';
        TableOpenLbl: Label '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">', Locked = true;
        TableHdrLbl: Label '<tr style="background-color:#333;color:#fff;"><th>Código</th><th>Descripción</th><th>Marca</th><th>Tipo</th><th>Precio Anterior</th><th>Precio Nuevo</th></tr>', Comment = '#333 and #fff are HTML hex color codes, not placeholders.';
        TableCloseLbl: Label '</table>', Locked = true;
        RowTdLbl: Label '<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td>%5</td><td>%6</td></tr>', Locked = true;
}
