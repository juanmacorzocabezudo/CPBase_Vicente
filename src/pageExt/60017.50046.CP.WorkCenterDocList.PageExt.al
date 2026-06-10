pageextension 60017 "Work Center Doc. List" extends "Work Center Document List" //50046
{
    actions
    {
        addafter(Supply)
        {
            action(CPUpdateWorkCenter)
            {
                ApplicationArea = All;
                Caption = 'Update';
                Image = UpdateUnitCost;
                ToolTip = 'Updates resources costs from supply data, refreshes work center lines, and recalculates all affected recipes.';

                trigger OnAction()
                begin
                    UpdateWorkCenterAndRecipes(Rec);
                end;
            }
        }
        addlast(Promoted)
        {
            actionref(CPEditRef; CPUpdateWorkCenter)
            {
            }
        }
    }

    local procedure UpdateWorkCenterAndRecipes(var WorkCenterHeader: Record "Work center Header")
    var
        WorkCenterLine: Record "Work Center Line";
        SupplyByResource: Record "Supply By Resource";
        ResourceRec: Record Resource;
        BOMComponent: Record "BOM Component";
        ProgressDialog: Dialog;
        AffectedResources: List of [Code[20]];
        AffectedRecipes: List of [Code[20]];
        ProcessedRecipes: List of [Code[20]];
        ResourcesInDetails: List of [Code[20]];
        ResourceCode: Code[20];
        RecipeNo: Code[20];
        RecipeListText: Text;
        SummaryText: Text;
        ChangeRowsHtml: Text;
        DetailsHtml: Text;
        OldResourceCost: Decimal;
        OldWCLResourceCost: Decimal;
        UpdatedWCL: Integer;
        UpdatedResources: Integer;
        UpdatedBOMQty: Integer;
        TotalRecipes: Integer;
        RecipeCounter: Integer;
        NewResourceCost: Decimal;
        RecipeOk: Boolean;
        ErrorRecipes: Integer;
    begin
        if not Confirm(ConfirmUpdateQst, false, WorkCenterHeader."No.", WorkCenterHeader.Description) then
            exit;

        ProgressDialog.Open(UpdateProgressMsg);

        // Phase 1: Refresh Work Center Line costs from Resource."Direct Unit Cost"
        ProgressDialog.Update(1, StrSubstNo(Phase1Txt, WorkCenterHeader."No."));
        ProgressDialog.Update(2, 1000);

        WorkCenterLine.Reset();
        WorkCenterLine.SetRange("Work Center No.", WorkCenterHeader."No.");
        if WorkCenterLine.FindSet() then
            repeat
                if not AffectedResources.Contains(WorkCenterLine."No.") then
                    AffectedResources.Add(WorkCenterLine."No.");

                if ResourceRec.Get(WorkCenterLine."No.") then begin
                    // First, recalculate Resource Direct Unit Cost from Supply By Resource
                    SupplyByResource.Reset();
                    SupplyByResource.SetRange(Resource, WorkCenterLine."No.");
                    SupplyByResource.CalcSums(Cost);
                    NewResourceCost := SupplyByResource.Cost;

                    if ResourceRec."Direct Unit Cost" <> NewResourceCost then begin
                        OldResourceCost := ResourceRec."Direct Unit Cost";
                        ResourceRec.Validate("Direct Unit Cost", NewResourceCost);
                        ResourceRec.Modify();
                        UpdatedResources += 1;
                        if not ResourcesInDetails.Contains(ResourceRec."No.") then begin
                            ChangeRowsHtml += StrSubstNo(RowTdLbl,
                                ResourceRec."No.",
                                ResourceRec.Name,
                                ResourceTypeLbl,
                                Format(OldResourceCost),
                                Format(NewResourceCost));
                            ResourcesInDetails.Add(ResourceRec."No.");
                        end;
                    end;

                    // Then, update Work Center Line Resource Cost
                    if WorkCenterLine."Resource Cost" <> ResourceRec."Direct Unit Cost" then begin
                        OldWCLResourceCost := WorkCenterLine."Resource Cost";
                        WorkCenterLine.Validate("Resource Cost", ResourceRec."Direct Unit Cost");
                        WorkCenterLine.Modify();
                        UpdatedWCL += 1;
                        ChangeRowsHtml += StrSubstNo(RowTdLbl,
                            WorkCenterLine."No.",
                            WorkCenterLine."Resource Name",
                            WorkCenterLineTypeLbl,
                            Format(OldWCLResourceCost),
                            Format(ResourceRec."Direct Unit Cost"));
                    end;
                end;
            until WorkCenterLine.Next() = 0;

        // Phase 2: Sync Work Center Line quantities to BOM Components
        ProgressDialog.Update(1, SyncingQuantitiesTxt);
        ProgressDialog.Update(2, 2000);

        WorkCenterLine.Reset();
        WorkCenterLine.SetRange("Work Center No.", WorkCenterHeader."No.");
        if WorkCenterLine.FindSet() then
            repeat
                BOMComponent.Reset();
                BOMComponent.SetRange(Type, BOMComponent.Type::Resource);
                BOMComponent.SetRange("No.", WorkCenterLine."No.");
                BOMComponent.SetRange("Related Work Center", WorkCenterHeader."No.");
                if BOMComponent.FindSet() then
                    repeat
                        if BOMComponent."Quantity per" <> WorkCenterLine."Quantity per" then begin
                            BOMComponent.Validate("Quantity per", WorkCenterLine."Quantity per");
                            BOMComponent.Modify(true);
                            UpdatedBOMQty += 1;
                        end;
                    until BOMComponent.Next() = 0;
            until WorkCenterLine.Next() = 0;

        // Phase 3: Find affected recipes
        ProgressDialog.Update(1, FindingRecipesTxt);
        ProgressDialog.Update(2, 3000);

        foreach ResourceCode in AffectedResources do begin
            BOMComponent.Reset();
            BOMComponent.SetRange(Type, BOMComponent.Type::Resource);
            BOMComponent.SetRange("No.", ResourceCode);
            if BOMComponent.FindSet() then
                repeat
                    if not AffectedRecipes.Contains(BOMComponent."Parent Item No.") then
                        AffectedRecipes.Add(BOMComponent."Parent Item No.");
                until BOMComponent.Next() = 0;
        end;

        // Phase 3: Process all affected recipes
        TotalRecipes := AffectedRecipes.Count();
        RecipeCounter := 0;
        InitConsolidatedEmail(StrSubstNo(TriggerWorkCenterLbl, WorkCenterHeader."No.", WorkCenterHeader.Description));
        DetailsHtml := BuildWorkCenterChangesHtml(ChangeRowsHtml);
        SetTriggerDetailsFromWorkCenter(DetailsHtml);

        foreach RecipeNo in AffectedRecipes do begin
            RecipeCounter += 1;
            ProgressDialog.Update(1, StrSubstNo(ProcessingRecipeTxt, RecipeNo, RecipeCounter, TotalRecipes));
            if TotalRecipes > 0 then
                ProgressDialog.Update(2, 3000 + Round(RecipeCounter * 6500 / TotalRecipes, 1));

            RecipeOk := true;
            if not TryProcessRecipe(RecipeNo) then begin
                RecipeOk := false;
                ErrorRecipes += 1;
            end;

            if RecipeOk then
                ProcessedRecipes.Add(RecipeNo);
        end;

        FlushConsolidatedEmailFromMgt();
        ProgressDialog.Update(2, 10000);
        ProgressDialog.Close();

        // Build summary
        WorkCenterHeader.CalcFields("Total Cost");
        SummaryText := StrSubstNo(SummaryHeaderTxt,
            WorkCenterHeader."No.", WorkCenterHeader.Description,
            UpdatedResources, UpdatedWCL, UpdatedBOMQty,
            WorkCenterHeader."Total Cost");

        if ProcessedRecipes.Count() > 0 then begin
            foreach RecipeNo in ProcessedRecipes do begin
                if RecipeListText <> '' then
                    RecipeListText += ', ';
                RecipeListText += RecipeNo;
            end;
            SummaryText += StrSubstNo(SummaryRecipesTxt, ProcessedRecipes.Count(), RecipeListText);
        end else
            if AffectedRecipes.Count() = 0 then
                SummaryText += NoAffectedRecipesTxt;

        if ErrorRecipes > 0 then
            SummaryText += StrSubstNo(SummaryErrorsTxt, ErrorRecipes);

        Message(SummaryText);
        CurrPage.Update(false);
    end;

    [TryFunction]
    local procedure TryProcessRecipe(ItemNo: Code[20])
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.ProcessAndFixSingleRecipe(ItemNo);
    end;

    local procedure InitConsolidatedEmail(SourceDescription: Text)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.ClearEmailBuffer();
        RecipeFluctuationMgt.SetEmailTriggerSource(SourceDescription);
    end;

    local procedure SetTriggerDetailsFromWorkCenter(DetailsHtml: Text)
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        if DetailsHtml = '' then
            exit;
        RecipeFluctuationMgt.SetEmailTriggerDetails(DetailsHtml);
    end;

    local procedure BuildWorkCenterChangesHtml(RowsHtml: Text): Text
    var
        DetailsHtml: Text;
    begin
        if RowsHtml = '' then
            exit('');
        DetailsHtml := WorkCenterChangesHdrLbl;
        DetailsHtml += TableOpenLbl;
        DetailsHtml += TableHdrLbl;
        DetailsHtml += RowsHtml;
        DetailsHtml += TableCloseLbl;
        exit(DetailsHtml);
    end;

    local procedure FlushConsolidatedEmailFromMgt()
    var
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        RecipeFluctuationMgt.FlushConsolidatedEmail();
    end;

    var
        ConfirmUpdateQst: Label 'This will update the costs for work center %1 - %2 and recalculate all affected recipes.\Do you want to continue?', Comment = '%1 = Work Center No., %2 = Work Center Description';
        UpdateProgressMsg: Label 'Updating work center costs...\#1##################################################\@2@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@', Comment = '#1 = Current step text, @2 = Progress bar';
        Phase1Txt: Label 'Refreshing resource costs for work center %1...', Comment = '%1 = Work Center No.';
        SyncingQuantitiesTxt: Label 'Syncing quantities from work center lines to recipes...';
        FindingRecipesTxt: Label 'Finding affected recipes...';
        ProcessingRecipeTxt: Label 'Recalculating recipe %1 (%2 of %3)...', Comment = '%1 = Recipe No., %2 = Current, %3 = Total';
        SummaryHeaderTxt: Label 'Update completed for work center %1 - %2.\\Resources updated: %3\Work center lines updated: %4\Recipe BOM quantities updated: %5\New work center total cost: %6', Comment = '%1 = WC No., %2 = WC Description, %3 = Resources updated, %4 = WCL updated, %5 = BOM quantities updated, %6 = New total cost';
        SummaryRecipesTxt: Label '\\Recipes recalculated (%1): %2', Comment = '%1 = Recipe count, %2 = Recipe list';
        NoAffectedRecipesTxt: Label '\\No recipes are affected by this work center.';
        SummaryErrorsTxt: Label '\\WARNING: %1 recipe(s) had errors during recalculation.', Comment = '%1 = Error count';
        TriggerWorkCenterLbl: Label 'Centro de trabajo: %1 - %2', Comment = '%1 = Work Center No., %2 = Work Center Description';
        WorkCenterChangesHdrLbl: Label '<h3>Modified work centers</h3>';
        TableOpenLbl: Label '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">', Locked = true;
        TableHdrLbl: Label '<tr style="background-color:#333;color:#fff;"><th>Code</th><th>Description</th><th>Type</th><th>Previous Price</th><th>New Price</th></tr>', Comment = '#333 and #fff are HTML hex color codes, not placeholders.';
        TableCloseLbl: Label '</table>', Locked = true;
        RowTdLbl: Label '<tr><td>%1</td><td>%2</td><td>%3</td><td>%4</td><td>%5</td></tr>', Locked = true;
        ResourceTypeLbl: Label 'Resource';
        WorkCenterLineTypeLbl: Label 'Work Center Line';
}
