page 60011 "CP Recipe Price Fluctuation L."
{
    ApplicationArea = All;
    Caption = 'Recipe Price Fluctuation List';
    PageType = List;
    SourceTable = "CP Recipe Price Fluctuation";
    UsageCategory = Lists;
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    SourceTableView = sorting("Detection Date") order(descending);

    layout
    {
        area(content)
        {
            repeater(General)
            {
                FreezeColumn = ItemDescription;
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique entry number for this fluctuation record.';
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number of the recipe with the price fluctuation.';
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the item.';
                }
                field(RecipeLot; Rec."Recipe Lot")
                {
                    ApplicationArea = All;
                    Caption = 'Recipe Lot';
                    ToolTip = 'Specifies the lot size of the recipe at the time of detection.';
                    DecimalPlaces = 0 : 5;
                }
                field(UnitOfMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure';
                    ToolTip = 'Specifies the base unit of measure of the recipe.';
                }
                field(StatisticsLot; Rec."Statistics Lot")
                {
                    ApplicationArea = All;
                    Caption = 'Statistics Lot';
                    ToolTip = 'Specifies the statistics lot of the recipe at the time of detection.';
                    DecimalPlaces = 0 : 5;
                }
                field(StatisticsLotUoM; Rec."Statistics Lot UoM")
                {
                    ApplicationArea = All;
                    Caption = 'Statistics Lot UoM';
                    ToolTip = 'Specifies the statistics lot with unit of measure.';
                }
                field(DetectionDate; Rec."Detection Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the fluctuation was detected.';
                }
                field(RecipeFixed; Rec."Recipe Fixed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the recipe cost has been fixed. Checking this will recalculate and fix the standard cost.';
                }
                // === COSTES FIJADOS ===
                // === COSTES ACTUALES ===
                field(CurrentBOMTotalCost; Rec."Current BOM Total Cost")
                {
                    ApplicationArea = All;
                    Caption = 'BOM Total Cost (Fixed)';
                    ToolTip = 'Specifies the current BOM total cost at the time of detection.';
                    DecimalPlaces = 2 : 2;
                }
                field(CurrentGeneralCosts; Rec."Current General Costs")
                {
                    ApplicationArea = All;
                    Caption = 'General Costs (Fixed)';
                    ToolTip = 'Specifies the current general costs (excluding profit) at the time of detection.';
                    DecimalPlaces = 2 : 2;
                }
                field(CurrentEXWORK; Rec."Current EXWORK Standard")
                {
                    ApplicationArea = All;
                    Caption = 'EXWORK Standard (Fixed)';
                    ToolTip = 'Specifies the current EXWORK standard cost at the time of detection.';
                    DecimalPlaces = 2 : 2;
                }
                field(CurrentProfit; Rec."Current Profit")
                {
                    ApplicationArea = All;
                    Caption = 'Profit (Fixed)';
                    ToolTip = 'Specifies the current profit amount at the time of detection.';
                    DecimalPlaces = 2 : 2;
                }
                field(CurrentProfitPct; Rec."Current Profit %")
                {
                    ApplicationArea = All;
                    Caption = 'Profit % (Fixed)';
                    ToolTip = 'Specifies the current profit percentage at the time of detection.';
                    DecimalPlaces = 2 : 2;
                }
                // === DETALLES ===
                field(FluctuationItems; Rec."Fluctuation Items")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BOM components that caused the cost fluctuation.';
                    Width = 40;
                }
                field(ExternalLink; Rec."External Link")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies an external link (URL or file path) for documents or photos related to this fluctuation.';
                }
                // === CAMPOS OCULTOS ===
                field(PreviousStandardCost; Rec."Previous Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the standard cost before the fluctuation was detected.';
                    Visible = false;
                }
                field(CurrentStandardCost; Rec."Current Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current standard cost after recalculation.';
                    Visible = false;
                }
                field(FluctuationAmount; Rec."Fluctuation Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the difference between the previous and current standard cost.';
                    StyleExpr = FluctuationStyleTxt;
                    Visible = false;
                }
                field(FluctuationPct; Rec."Fluctuation %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the fluctuation as a percentage of the previous standard cost.';
                    StyleExpr = FluctuationStyleTxt;
                    Visible = false;
                }
                field(FixedDate; Rec."Fixed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time when the recipe was fixed.';
                    Visible = false;
                }
                field(FixedBy; Rec."Fixed By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who fixed the recipe cost.';
                    Visible = false;
                }
                field(ItemNoSeries; Rec."Item No. Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number series of the item.';
                    Visible = false;
                }
                field(NotificationSent; Rec."Notification Sent")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether an email notification was sent for this fluctuation.';
                    Visible = false;
                }
                field(HasError; Rec."Has Error")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether an error occurred during cost recalculation for this recipe.';
                    StyleExpr = ErrorStyleTxt;
                    Visible = false;
                }
                field(ErrorText; Rec."Error Text")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the error message if the cost recalculation failed.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ProcessAllRecipes)
            {
                ApplicationArea = All;
                Caption = 'Process All Recipes';
                ToolTip = 'Specifies the action to recalculate costs for all non-blocked recipes and detect fluctuations.';
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
                begin
                    if not Confirm(ConfirmProcessAllQst) then
                        exit;
                    RecipeFluctuationMgt.ProcessAllRecipes();
                    CurrPage.Update(false);
                    Message(ProcessCompleteMsg);
                end;
            }
            action(CreateInitialEntries)
            {
                ApplicationArea = All;
                Caption = 'Create Initial Entries';
                ToolTip = 'Specifies the action to create baseline entries for all non-blocked recipes. Use this after first setup.';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
                begin
                    if not Confirm(ConfirmCreateInitialQst) then
                        exit;
                    RecipeFluctuationMgt.CreateInitialEntries();
                    CurrPage.Update(false);
                    Message(InitialEntriesCreatedMsg);
                end;
            }
            action(OpenSetup)
            {
                ApplicationArea = All;
                Caption = 'Setup';
                ToolTip = 'Specifies the action to open the recipe fluctuation setup.';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "CP Recipe Fluctuation Setup";
            }
            action(OpenRecipe)
            {
                ApplicationArea = All;
                Caption = 'Open Recipe';
                ToolTip = 'Specifies the action to open the recipe card for the selected item.';
                Image = Item;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    Item: Record Item;
                begin
                    if Item.Get(Rec."Item No.") then
                        Page.Run(Page::Receta, Item);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateStyles();
    end;

    local procedure UpdateStyles()
    begin
        if Rec."Has Error" then
            ErrorStyleTxt := 'Unfavorable'
        else
            ErrorStyleTxt := 'Standard';

        if Rec."Fluctuation Amount" > 0 then
            FluctuationStyleTxt := 'Unfavorable'
        else
            if Rec."Fluctuation Amount" < 0 then
                FluctuationStyleTxt := 'Favorable'
            else
                FluctuationStyleTxt := 'Standard';
    end;

    var
        FluctuationStyleTxt: Text;
        ErrorStyleTxt: Text;
        ConfirmProcessAllQst: Label 'This will recalculate the standard cost for all non-blocked recipes and detect price fluctuations. Do you want to continue?';
        ProcessCompleteMsg: Label 'Recipe price fluctuation processing completed.';
        ConfirmCreateInitialQst: Label 'This will create baseline entries for all non-blocked recipes. Do you want to continue?';
        InitialEntriesCreatedMsg: Label 'Initial entries have been created successfully.';
}
