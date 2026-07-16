tableextension 60010 "CP Price List Header" extends "Price List Header"    //7000
{
    fields
    {
        field(60000; "CP Negotiated Prices"; Boolean)
        {
            Caption = 'Negotiated Prices';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies if prices in this list are negotiated and should not trigger recipe cost recalculations.';
        }
    }
}
