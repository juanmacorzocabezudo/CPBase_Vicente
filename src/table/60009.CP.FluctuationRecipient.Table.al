table 60009 "Fluctuation Recipient"
{
    Caption = 'Fluctuation Recipient';
    DataClassification = CustomerContent;
    LookupPageId = "Fluctuation Recipients";
    DrillDownPageId = "Fluctuation Recipients";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Email Address"; Text[250])
        {
            Caption = 'Email Address';
            ToolTip = 'Specifies the email address for the fluctuation notification recipient.';
        }
        field(3; "Recipient Type"; Enum "Fluctuation Recipient Type")
        {
            Caption = 'Recipient Type';
            ToolTip = 'Specifies whether this recipient receives PT (production), CA (catering), or Error notifications.';
        }
        field(4; "Include Costs"; Boolean)
        {
            Caption = 'Include Costs';
            InitValue = true;
            ToolTip = 'Specifies whether the email sent to this recipient includes cost details (previous cost, new cost, fluctuation) or only item code and description.';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(TypeEmail; "Recipient Type", "Email Address")
        {
        }
    }
}
