pageextension 60012 "Assembly Order" extends "Assembly Order" //900
{
    layout
    {
        addafter(Control2)
        {
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
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        modify(ProductionReport) { Visible = false; }
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
                    AssemblyHeader: Record "Assembly Header";
                    ElaborationPrintPrep: Page "CP Elaboration Print Prep";
                    RecipePrintImage: Codeunit "CP Recipe Print Image";
                begin
                    RecipePrintImage.ClearImage();
                    ElaborationPrintPrep.SetRecipe(Rec."Item No.", 680);
                    ElaborationPrintPrep.RunModal();
                    if not RecipePrintImage.HasImage(Rec."Item No.") then
                        exit;

                    AssemblyHeader.SetRange("Document Type", Rec."Document Type");
                    AssemblyHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"CP Production Part", true, false, AssemblyHeader);
                    RecipePrintImage.ClearImage();
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        RecipeItem: Record Item;
    begin
        Clear(ElaborationText);
        if RecipeItem.Get(Rec."Item No.") then
            ElaborationText := RecipeItem.GetElaboration();
    end;

    var
        ElaborationText: Text;
}