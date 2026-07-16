pageextension 60020 "BOM Version List" extends "BOM Version List" //50049
{
    layout
    {
        addafter(Comment)
        {
            field(Elaboration; ElaborationText)
            {
                ApplicationArea = All;
                Caption = 'Elaboración';
                ToolTip = 'Especifica las instrucciones de elaboración para esta versión de LM.';
                MultiLine = true;
                ExtendedDatatype = RichContent;

                trigger OnValidate()
                begin
                    Rec.SaveElaboration(ElaborationText);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ElaborationText := Rec.GetElaboration();
    end;

    var
        ElaborationText: Text;
}
