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
                begin
                    AssemblyHeader.SetRange("Document Type", Rec."Document Type");
                    AssemblyHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"CP Production Part", true, false, AssemblyHeader);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ElaborationText := Rec.GetElaboration();
    end;

    var
        ElaborationText: Text;
}