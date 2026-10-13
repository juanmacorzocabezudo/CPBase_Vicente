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
        field(10; "Sender Email"; Text[250])
        {
            Caption = 'Sender Email';
            ExtendedDatatype = EMail;

            trigger OnValidate()
            var
                TempEmailAccount: Record "Email Account";
                EmailAccounts: Codeunit "Email Account";
            begin
                if "Sender Email" = '' then begin
                    Clear("Email Account Id");
                    Clear("Email Connector");
                    "Email Account Name" := '';
                end else begin
                    EmailAccounts.GetAllAccounts(false, TempEmailAccount);
                    TempEmailAccount.SetRange("Email Address", "Sender Email");
                    if TempEmailAccount.FindFirst() then begin
                        "Email Account Id" := TempEmailAccount."Account Id";
                        "Email Connector" := TempEmailAccount.Connector;
                        "Email Account Name" := TempEmailAccount.Name;
                    end else begin
                        TempEmailAccount.Reset();
                        TempEmailAccount.SetRange(Name, "Sender Email");
                        if TempEmailAccount.FindFirst() then begin
                            "Email Account Id" := TempEmailAccount."Account Id";
                            "Email Connector" := TempEmailAccount.Connector;
                            "Email Account Name" := TempEmailAccount.Name;
                            "Sender Email" := TempEmailAccount."Email Address";
                        end;
                    end;
                end;
            end;

            trigger OnLookup()
            var
                TempEmailAccount: Record "Email Account";
                EmailAccounts: Codeunit "Email Account";
                EmailAccountsPage: Page "Email Accounts";
            begin
                EmailAccounts.GetAllAccounts(false, TempEmailAccount);
                EmailAccountsPage.SetTableView(TempEmailAccount);
                EmailAccountsPage.LookupMode(true);
                if EmailAccountsPage.RunModal() = Action::LookupOK then begin
                    EmailAccountsPage.GetRecord(TempEmailAccount);
                    "Email Account Id" := TempEmailAccount."Account Id";
                    "Email Connector" := TempEmailAccount.Connector;
                    "Email Account Name" := TempEmailAccount.Name;
                    "Sender Email" := TempEmailAccount."Email Address";
                end;
            end;
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

    procedure GetEmailAccount(var TempEmailAccount: Record "Email Account"): Boolean
    var
        EmailAccounts: Codeunit "Email Account";
    begin
        GetSetup();
        EmailAccounts.GetAllAccounts(false, TempEmailAccount);

        if not IsNullGuid("Email Account Id") then begin
            TempEmailAccount.SetRange("Account Id", "Email Account Id");
            TempEmailAccount.SetRange(Connector, "Email Connector");
            if TempEmailAccount.FindFirst() then
                exit(true);
        end;

        if "Sender Email" <> '' then begin
            TempEmailAccount.Reset();
            TempEmailAccount.SetRange("Email Address", "Sender Email");
            if TempEmailAccount.FindFirst() then
                exit(true);
        end;

        if "Email Account Name" <> '' then begin
            TempEmailAccount.Reset();
            TempEmailAccount.SetRange(Name, "Email Account Name");
            if TempEmailAccount.FindFirst() then
                exit(true);
        end;

        exit(false);
    end;
}
