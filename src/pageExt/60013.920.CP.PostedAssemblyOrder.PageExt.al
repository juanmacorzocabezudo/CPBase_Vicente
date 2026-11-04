pageextension 60013 "Posted Assembly Order" extends "Posted Assembly Order" //920
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(processing)
        {
            action(CPProductionPart)
            {
                ApplicationArea = All;
                Caption = 'Production Part';
                ToolTip = 'Run the production part report for this assembly order.';
                Image = Report;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PostedAssemblyHeader: Record "Posted Assembly Header";
                    ElaborationPrintPrep: Page "CP Elaboration Print Prep";
                    RecipePrintImage: Codeunit "CP Recipe Print Image";
                begin
                    RecipePrintImage.ClearImage();
                    ElaborationPrintPrep.SetRecipe(Rec."Item No.", 680);
                    ElaborationPrintPrep.RunModal();
                    if not RecipePrintImage.HasImage(Rec."Item No.") then
                        exit;

                    PostedAssemblyHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"CP Production Part", true, false, PostedAssemblyHeader);
                    RecipePrintImage.ClearImage();
                end;
            }
        }
    }
}