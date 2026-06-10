page 60013 "Fluctuation Recipients"
{
    ApplicationArea = All;
    Caption = 'Fluctuation Recipients';
    PageType = ListPart;
    SourceTable = "Fluctuation Recipient";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address for the fluctuation notification recipient.';
                }
                field(RecipientType; Rec."Recipient Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether this recipient receives PT (production), CA (catering), or Error notifications.';
                }
                field(IncludeCosts; Rec."Include Costs")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the email sent to this recipient includes cost details (previous cost, new cost, fluctuation) or only item code and description.';
                }
            }
        }
    }
}
