tableextension 60008 "CP User Setup" extends "User Setup"
{
    fields
    {
        field(60000; "CP Fluctuation Setup Access"; Boolean)
        {
            Caption = 'Fluctuation Setup Access';
            DataClassification = CustomerContent;
            ToolTip = 'Specifies whether the user has access to the Recipe Fluctuation Setup page.';
        }
    }
}
