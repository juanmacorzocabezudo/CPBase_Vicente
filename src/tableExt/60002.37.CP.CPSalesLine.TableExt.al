tableextension 60002 "CP Sales Line" extends "Sales Line"  //37
{
    fields
    {
        field(60000; "CP Return"; Boolean)
        {
            Caption = 'Return';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies if this credit memo line is a return.';
        }
        field(60001; "CP Comment"; Text[250])
        {
            Caption = 'Comment';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies a comment for this credit memo line.';
        }
    }
}
