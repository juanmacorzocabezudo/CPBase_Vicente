table 60008 "CP Recipe Fluctuation Setup"
{
    Caption = 'Recipe Fluctuation Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "PT Email Recipients"; Text[500])
        {
            Caption = 'PT Email Recipients';
        }
        field(3; "CA Email Recipients"; Text[500])
        {
            Caption = 'CA Email Recipients';
        }
        field(4; "Error Email Recipients"; Text[500])
        {
            Caption = 'Error Email Recipients';
        }
        field(5; "Email Subject"; Text[250])
        {
            Caption = 'Email Subject';
        }
        field(6; "Last Run Date"; DateTime)
        {
            Caption = 'Last Run Date';
            Editable = false;
        }
        field(7; "Email Account Id"; Guid)
        {
            Caption = 'Email Account Id';
        }
        field(8; "Email Connector"; Enum "Email Connector")
        {
            Caption = 'Email Connector';
        }
        field(9; "Email Account Name"; Text[250])
        {
            Caption = 'Email Account Name';
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSetup()
    begin
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}
