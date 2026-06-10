pageextension 60015 "CP Supply List" extends "Supply List"
{
    actions
    {
        modify(Actualizar)
        {
            Visible = false;
        }
        addafter(Actualizar)
        {
            action(CPUpdateSupplyCosts)
            {
                ApplicationArea = All;
                Caption = 'Update Supply Costs';
                Image = UpdateUnitCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Updates all supply prices and propagates changes to resources and work center lines. Shows a progress indicator and a summary of all changes.';

                trigger OnAction()
                begin
                    if not Confirm(ConfirmUpdateQst) then
                        exit;
                    UpdateSupplyCosts();
                end;
            }
        }
    }

    local procedure UpdateSupplyCosts()
    var
        Supply: Record Supply;
        SupplyByResource: Record "Supply By Resource";
        SupplyByResourceSum: Record "Supply By Resource";
        ResourceRec: Record Resource;
        WorkCenterLine: Record "Work Center Line";
        BOMComponent: Record "BOM Component";
        ProgressDialog: Dialog;
        AllResources: List of [Code[20]];
        ChangedResources: List of [Code[20]];
        AffectedRecipes: List of [Code[20]];
        ResourceCode: Code[20];
        RecipeNo: Code[20];
        FailedRecipeListText: Text;
        ChangedSuppliesHtml: Text;
        SummaryText: Text;
        TotalSupplies: Integer;
        SupplyCount: Integer;
        UpdatedSBR: Integer;
        UpdatedResources: Integer;
        UpdatedWCL: Integer;
        TotalResources: Integer;
        ResourceCounter: Integer;
        TotalAffectedRecipes: Integer;
        RecipeCounter: Integer;
        RecalculatedRecipes: Integer;
        FailedRecalculations: Integer;
        NewResourceCost: Decimal;
        SupplyOldPrice: Decimal;
        SupplyChanged: Boolean;
    begin
        Supply.Reset();
        TotalSupplies := Supply.Count();
        if TotalSupplies = 0 then begin
            Message(NoSuppliesToUpdateMsg);
            exit;
        end;

        ProgressDialog.Open(UpdateProgressMsg);
        SupplyCount := 0;

        // Phase 1: Sync Supply By Resource prices from Supply master
        if Supply.FindSet() then
            repeat
                SupplyCount += 1;
                ProgressDialog.Update(1, StrSubstNo(ProcessingSupplyTxt, Supply."No.", Supply.Description));
                ProgressDialog.Update(2, Round(SupplyCount * 5000 / TotalSupplies, 1));

                SupplyChanged := false;
                SupplyOldPrice := 0;

                SupplyByResource.Reset();
                SupplyByResource.SetRange(Type, Supply.Type);
                SupplyByResource.SetRange("No.", Supply."No.");
                if SupplyByResource.FindSet() then
                    repeat
                        if SupplyByResource.Price <> Supply.Price then begin
                            if not SupplyChanged then begin
                                SupplyOldPrice := SupplyByResource.Price;
                                SupplyChanged := true;
                            end;
                            SupplyByResource.Validate(Price, Supply.Price);
                            SupplyByResource.Modify();
                            UpdatedSBR += 1;
                        end;
                        if not AllResources.Contains(SupplyByResource.Resource) then
                            AllResources.Add(SupplyByResource.Resource);
                    until SupplyByResource.Next() = 0;

                if SupplyChanged then
                    ChangedSuppliesHtml += '<tr><td>' + Supply."No." + '</td><td>' + Supply.Description + '</td><td>' + Format(SupplyOldPrice) + '</td><td>' + Format(Supply.Price) + '</td></tr>';
            until Supply.Next() = 0;

        // Phase 2: Recalculate Resource Direct Unit Cost and Work Center Lines
        TotalResources := AllResources.Count();
        ResourceCounter := 0;
        foreach ResourceCode in AllResources do begin
            ResourceCounter += 1;
            ProgressDialog.Update(1, StrSubstNo(UpdatingResourceTxt, ResourceCode));
            if TotalResources > 0 then
                ProgressDialog.Update(2, 5000 + Round(ResourceCounter * 4000 / TotalResources, 1));

            if ResourceRec.Get(ResourceCode) then begin
                SupplyByResourceSum.Reset();
                SupplyByResourceSum.SetRange(Resource, ResourceCode);
                SupplyByResourceSum.CalcSums(Cost);
                NewResourceCost := SupplyByResourceSum.Cost;

                if ResourceRec."Direct Unit Cost" <> NewResourceCost then begin
                    ResourceRec.Validate("Direct Unit Cost", NewResourceCost);
                    ResourceRec.Modify();
                    UpdatedResources += 1;
                    if not ChangedResources.Contains(ResourceCode) then
                        ChangedResources.Add(ResourceCode);
                end;

                // Update Work Center Lines
                WorkCenterLine.Reset();
                WorkCenterLine.SetRange("No.", ResourceCode);
                if WorkCenterLine.FindSet() then
                    repeat
                        if WorkCenterLine."Resource Cost" <> NewResourceCost then begin
                            WorkCenterLine.Validate("Resource Cost", NewResourceCost);
                            WorkCenterLine.Modify();
                            UpdatedWCL += 1;
                        end;
                    until WorkCenterLine.Next() = 0;
            end;
        end;

        // Phase 3: Find affected recipes (only for resources with cost changes)
        ProgressDialog.Update(1, FindingRecipesTxt);
        ProgressDialog.Update(2, 9500);

        foreach ResourceCode in ChangedResources do begin
            BOMComponent.Reset();
            BOMComponent.SetRange(Type, BOMComponent.Type::Resource);
            BOMComponent.SetRange("No.", ResourceCode);
            if BOMComponent.FindSet() then
                repeat
                    if not AffectedRecipes.Contains(BOMComponent."Parent Item No.") then
                        AffectedRecipes.Add(BOMComponent."Parent Item No.");
                until BOMComponent.Next() = 0;
        end;

        // Phase 4: Recalculate standard cost automatically for affected recipes
        TotalAffectedRecipes := AffectedRecipes.Count();
        RecipeCounter := 0;
        SetSuppressMessagesFlag(true);
        InitConsolidatedEmail('Actualización de costes de suministros');
        if ChangedSuppliesHtml <> '' then
            SetTriggerDetailsFromSupplies(ChangedSuppliesHtml);

        foreach RecipeNo in AffectedRecipes do begin
            RecipeCounter += 1;
            ProgressDialog.Update(1, StrSubstNo(RecalculatingRecipeTxt, RecipeNo));
            if TotalAffectedRecipes > 0 then
                ProgressDialog.Update(2, 9500 + Round(RecipeCounter * 500 / TotalAffectedRecipes, 1));

            if TryRecalculateRecipeStandardCost(RecipeNo) then
                RecalculatedRecipes += 1
            else begin
                FailedRecalculations += 1;
                if FailedRecipeListText <> '' then
                    FailedRecipeListText += ', ';
                FailedRecipeListText += RecipeNo;
            end;
        end;

        FlushConsolidatedEmailFromMgt();
        SetSuppressMessagesFlag(false);
        ProgressDialog.Update(2, 10000);
        ProgressDialog.Close();

        // Build summary
        SummaryText := StrSubstNo(SummaryHeaderTxt, TotalSupplies, UpdatedSBR, UpdatedResources, UpdatedWCL);

        if TotalAffectedRecipes > 0 then
            SummaryText += StrSubstNo(SummaryRecipesTxt, TotalAffectedRecipes, RecalculatedRecipes);

        if FailedRecalculations > 0 then
            SummaryText += StrSubstNo(SummaryFailedRecipesTxt, FailedRecalculations, FailedRecipeListText);

        Message(SummaryText);
    end;

    [TryFunction]
    local procedure TryRecalculateRecipeStandardCost(RecipeNo: Code[20])
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.ProcessAndFixSingleRecipe(RecipeNo);
    end;

    local procedure SetSuppressMessagesFlag(Suppress: Boolean)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.SetSuppressMessages(Suppress);
    end;

    local procedure InitConsolidatedEmail(SourceDescription: Text)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.ClearEmailBuffer();
        RecipeFluctuationMgt.SetEmailTriggerSource(SourceDescription);
    end;

    local procedure SetTriggerDetailsFromSupplies(SupplyRowsHtml: Text)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
        DetailsHtml: Text;
    begin
        DetailsHtml := '<h3>Suministros modificados</h3>';
        DetailsHtml += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">';
        DetailsHtml += '<tr style="background-color:#333;color:#fff;"><th>Código</th><th>Descripción</th><th>Precio anterior</th><th>Precio nuevo</th></tr>';
        DetailsHtml += SupplyRowsHtml;
        DetailsHtml += '</table>';
        RecipeFluctuationMgt.SetEmailTriggerDetails(DetailsHtml);
    end;

    local procedure FlushConsolidatedEmailFromMgt()
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.FlushConsolidatedEmail();
    end;

    var
        ConfirmUpdateQst: Label 'This will update all supply costs and propagate changes to resources and work centers.\Do you want to continue?';
        NoSuppliesToUpdateMsg: Label 'There are no supplies to update.';
        UpdateProgressMsg: Label 'Updating supply costs...\#1##################################################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Comment = '#1 = Current item text, @2 = Progress bar';
        ProcessingSupplyTxt: Label 'Supply: %1 - %2', Comment = '%1 = Supply No., %2 = Supply Description';
        UpdatingResourceTxt: Label 'Resource: %1', Comment = '%1 = Resource Code';
        FindingRecipesTxt: Label 'Finding affected recipes...';
        RecalculatingRecipeTxt: Label 'Recalculating recipe: %1', Comment = '%1 = Recipe No.';
        SummaryHeaderTxt: Label 'Update completed.\\Supplies processed: %1\Supply-resource records updated: %2\Resources updated: %3\Work center lines updated: %4', Comment = '%1 = Total supplies, %2 = Supply-resource updated, %3 = Resources updated, %4 = Work center lines updated';
        SummaryRecipesTxt: Label '\\Affected recipes: %1\Automatically recalculated recipes: %2', Comment = '%1 = Affected recipe count, %2 = Successfully recalculated recipe count';
        SummaryFailedRecipesTxt: Label '\\Recipes with recalculation errors (%1): %2', Comment = '%1 = Error recipe count, %2 = Recipe list with errors';
}
