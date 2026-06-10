pageextension 60004 "Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform"  //515
{
    layout
    {
        addlast(Control1)
        {
            field("CP Return"; Rec."CP Return")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if this credit memo line is a return.';
            }
            field("CP Comment"; Rec."CP Comment")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies a comment for this credit memo line.';
            }
        }
    }
}
