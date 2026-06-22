pageextension 60000 "Receta" extends Receta //50000
{
    layout
    {
        // Ocultar controles originales que reemplazamos
        modify("Elaboración") { Visible = false; }
        modify("ElaboraciónNueva") { Visible = false; }
        modify(recetaItem) { Visible = false; }
        modify("Statistics Lot") { Visible = false; }

        // Actualizar información de versión cuando cambia el estado
        modify("Status LM")
        {
            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }

        addafter("Statistics Lot")
        {
            field(StatisticsLotDisplay; Rec."Statistics Lot")
            {
                ApplicationArea = All;
                Caption = 'Statistics Lot';
                ToolTip = 'Specifies the statistics lot for this recipe.';
                DecimalPlaces = 0 : 0;
            }
        }

        addafter("Status LM")
        {
            group(BOMVersionInfo)
            {
                Caption = 'Version Information';

                field(LatestBOMVersionNo; LatestBOMVersion)
                {
                    ApplicationArea = All;
                    Caption = 'Version No.';
                    ToolTip = 'Specifies the latest version number of the Bill of Materials (BOM) for this recipe.';
                    Editable = false;
                }
                field(VersionComment; BOMVersionComment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                    ToolTip = 'Specifies the comment of the latest BOM version.';
                    Editable = false;
                    MultiLine = true;
                }
                field(TotalNetWeightField; TotalNetWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Total Net Weight (KG)';
                    ToolTip = 'Specifies the total net weight in kilograms from BOM components.';
                    Editable = false;
                    DecimalPlaces = 2 : 5;
                }
                field(TotalGrossWeightField; TotalGrossWeight)
                {
                    ApplicationArea = All;
                    Caption = 'Total Gross Weight (KG)';
                    ToolTip = 'Specifies the total gross weight in kilograms from BOM components.';
                    Editable = false;
                    DecimalPlaces = 2 : 5;
                }
            }
        }

        addafter(General)
        {
            part(BOMAdditionalCostPart; "CP BOM Aditional Cost")
            {
                ApplicationArea = All;
                Caption = 'BOM Additional Cost';
                SubPageLink = "Item No" = field("No."), "BOM Version" = const(0);
            }

            group(ElaborationGroup)
            {
                Caption = 'Elaboration';

                field(ElaborationField; ElaborationText)
                {
                    ApplicationArea = All;
                    Caption = 'Elaboration';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    Editable = IsElaborationEditable;

                    trigger OnValidate()
                    begin
                        Rec.SaveElaboration(ElaborationText);
                    end;
                }
            }
        }
    }

    actions
    {
        // Ocultar botones originales de Alxia que reemplazamos
        modify(ProductionReport) { Visible = false; }
        modify(AGRALARecalculoRecete) { Visible = false; }
        modify(Item) { Visible = false; }
        modify(Resource) { Visible = false; }
        modify(Supply) { Visible = false; }
        modify(WorkCenter) { Visible = false; }
        modify(BOMCost) { Visible = false; }
        modify("Where-Used") { Visible = false; }
        modify("Calc. Stan&dard Cost") { Visible = false; }

        addafter(ArchiveVersion)
        {
            action(ItemListAction)
            {
                ApplicationArea = All;
                Caption = 'Item List';
                ToolTip = 'Specifies the list of items.';
                Image = Item;
                Promoted = true;
                RunObject = Page "Item List";
            }
            action(SupplyListAction)
            {
                ApplicationArea = All;
                Caption = 'Supply List';
                ToolTip = 'Specifies the supply list for this item.';
                Image = Tools;
                Promoted = true;
                RunObject = Page "Supply List";
            }
            action(ResourceListAction)
            {
                ApplicationArea = All;
                Caption = 'Resource List';
                ToolTip = 'Specifies the list of resources.';
                Image = Resource;
                Promoted = true;
                RunObject = Page "Resource List";
            }
            action(WorkCenterAction)
            {
                ApplicationArea = All;
                Caption = 'Work Center';
                ToolTip = 'Specifies the work center card.';
                Image = WorkCenter;
                Promoted = true;
                RunObject = Page "Work Center Document List";
            }
            action(CalculateStandardCostAction)
            {
                ApplicationArea = All;
                Caption = 'Calculate Standard Cost';
                ToolTip = 'Specifies the action to recalculate the standard cost from BOM components and update the fixed additional costs.';
                AccessByPermission = TableData 90 = R;
                Image = CalculateCost;
                Promoted = true;

                trigger OnAction()
                var
                    Success: Boolean;
                begin
                    if not Confirm(ConfirmCalcStdCostQst) then
                        exit;

                    Success := true;
                    if not TryProcessAndFixRecipe(Rec."No.") then
                        Success := false;

                    CurrPage.Update(false);

                    if Success then
                        Message(CalcStdCostSuccessMsg)
                    else
                        Message(CalcStdCostErrorMsg, GetLastErrorText());
                end;
            }
            action(PointsOfUseAction)
            {
                ApplicationArea = All;
                Caption = 'Points of Use';
                ToolTip = 'Specifies where this item is used.';
                Image = Track;
                RunObject = Page "Where-Used List";
                RunPageLink = Type = const(Item), "No." = field("No.");
                RunPageView = sorting(Type, "No.");
            }
            action(RecalculateRecipeBatchAction)
            {
                ApplicationArea = All;
                Caption = 'Recalculate Recipe Batch';
                ToolTip = 'Specifies the action to recalculate the standard batch size for this recipe.';
                Image = Calculate;
                Promoted = true;
                RunObject = Page "Recalculo de lote Wizard";
                RunPageLink = "No." = field("No.");
            }
            action(PriceFluctuationAction)
            {
                ApplicationArea = All;
                Caption = 'Price Fluctuations';
                ToolTip = 'Specifies the price fluctuation history for this recipe.';
                Image = CostAccountingDimensions;
                Promoted = true;
                RunObject = Page "CP Recipe Price Fluctuation L.";
                RunPageLink = "Item No." = field("No.");
            }
        }

        addbefore(ProductionReport)
        {
            action(ReceiptPartAction)
            {
                ApplicationArea = All;
                Caption = 'Receipt Part';
                ToolTip = 'Specifies the receipt part report.';
                Ellipsis = true;
                Image = Document;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.Run(Report::"Receip Part", true, false, Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ElaborationText := Rec.GetElaboration();
        GetLatestBOMVersionInfo();
        CalculateTotalNetWeight();
        CalculateTotalGrossWeight();
        IsElaborationEditable := Rec."Status LM" = Rec."Status LM"::"Under Construction";
    end;

    var
        ElaborationText: Text;
        LatestBOMVersion: Code[20];
        BOMVersionComment: Text[250];
        TotalNetWeight: Decimal;
        TotalGrossWeight: Decimal;
        IsElaborationEditable: Boolean;
        ConfirmCalcStdCostQst: Label 'This will recalculate the standard cost and update all fixed additional costs for the recipe. Do you want to continue?';
        CalcStdCostSuccessMsg: Label 'The standard cost has been recalculated and updated successfully.';
        CalcStdCostErrorMsg: Label 'An error occurred while recalculating the standard cost.\Error: %1', Comment = '%1 = Error message';
        TriggerRecipeLbl: Label 'Receta: %1 - %2', Comment = '%1 = Item No., %2 = Item Description';
        FluctComponentsHdrLbl: Label '<h3>Components with price fluctuation</h3>';
        TableOpenLbl: Label '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">', Locked = true;
        TableHdrLbl: Label '<tr style="background-color:#333;color:#fff;"><th>Code</th><th>Description</th><th>Type</th><th>Previous Price</th><th>New Price</th></tr>', Comment = '#333 and #fff are HTML hex color codes, not placeholders.';
        TableCloseLbl: Label '</table>', Locked = true;
        RowTdLbl: Label '<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td>%5</td></tr>', Locked = true;

    [TryFunction]
    local procedure TryProcessAndFixRecipe(ItemNo: Code[20])
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
        DetailsHtml: Text;
    begin
        RecipeFluctuationMgt.ClearEmailBuffer();
        RecipeFluctuationMgt.SetEmailTriggerSource(StrSubstNo(TriggerRecipeLbl, Rec."No.", Rec.Description));
        DetailsHtml := BuildFluctuatingComponentsHtml(ItemNo);
        if DetailsHtml <> '' then
            RecipeFluctuationMgt.SetEmailTriggerDetails(DetailsHtml);
        RecipeFluctuationMgt.ProcessAndFixSingleRecipe(ItemNo);
        //JMC - 2026-06-22: Email de fluctuación de costes desactivado (ahora solo se envía al certificar)
        //RecipeFluctuationMgt.FlushConsolidatedEmail();
    end;

    local procedure BuildFluctuatingComponentsHtml(ItemNo: Code[20]): Text
    var
        BOMComponent: Record "BOM Component";
        ComponentItem: Record Item;
        RowsHtml: Text;
        DetailsHtml: Text;
    begin
        BOMComponent.SetRange("Parent Item No.", ItemNo);
        BOMComponent.SetRange(Type, BOMComponent.Type::Item);
        BOMComponent.SetRange(Maquila, false);
        if BOMComponent.FindSet() then
            repeat
                if ComponentItem.Get(BOMComponent."No.") then
                    if ComponentItem."Unit Cost" <> ComponentItem."Standard Cost" then
                        RowsHtml += StrSubstNo(RowTdLbl,
                            ComponentItem."No.",
                            ComponentItem.Description,
                            GetItemTypeLabel(ComponentItem."No. Series"),
                            Format(ComponentItem."Standard Cost"),
                            Format(ComponentItem."Unit Cost"));
            until BOMComponent.Next() = 0;

        if RowsHtml = '' then
            exit('');

        DetailsHtml := FluctComponentsHdrLbl;
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

    local procedure GetLatestBOMVersionInfo()
    var
        BOMVersionHeader: Record "BOM Version Header";
    begin
        Clear(LatestBOMVersion);
        Clear(BOMVersionComment);

        BOMVersionHeader.SetRange("Item No.", Rec."No.");
        BOMVersionHeader.SetCurrentKey("Item No.", "BOM Version");
        BOMVersionHeader.Ascending(false);

        if BOMVersionHeader.FindSet() then
            repeat
                if BOMVersionHeader."Version Date" <> 0D then begin
                    LatestBOMVersion := Format(BOMVersionHeader."BOM Version");
                    BOMVersionComment := BOMVersionHeader.Comment;
                    exit;
                end;
            until BOMVersionHeader.Next() = 0;
    end;

    local procedure CalculateTotalNetWeight()
    var
        BOMComponent: Record "BOM Component";
    begin
        TotalNetWeight := 0;

        BOMComponent.SetRange("Parent Item No.", Rec."No.");
        BOMComponent.SetRange("Unit of Measure Code", 'KG');

        if BOMComponent.FindSet() then
            repeat
                TotalNetWeight += BOMComponent."Net Amount";
            until BOMComponent.Next() = 0;
    end;

    local procedure CalculateTotalGrossWeight()
    var
        BOMComponent: Record "BOM Component";
    begin
        TotalGrossWeight := 0;

        BOMComponent.SetRange("Parent Item No.", Rec."No.");
        BOMComponent.SetRange("Unit of Measure Code", 'KG');

        if BOMComponent.FindSet() then
            repeat
                TotalGrossWeight += BOMComponent."Cantidad por Lote";
            until BOMComponent.Next() = 0;
    end;
}