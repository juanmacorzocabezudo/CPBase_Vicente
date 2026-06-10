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
                begin
                    PostedAssemblyHeader.SetRange("No.", Rec."No.");
                    Report.RunModal(Report::"CP Production Part", true, false, PostedAssemblyHeader);
                end;
            }
        }
    }
}