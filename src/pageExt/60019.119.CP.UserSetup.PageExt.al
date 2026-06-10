pageextension 60019 "CP User Setup" extends "User Setup"
{
    layout
    {
        addlast(Control1)
        {
            field(CPFluctuationSetupAccess; Rec."CP Fluctuation Setup Access")
            {
                ApplicationArea = All;
            }
        }
    }
}
