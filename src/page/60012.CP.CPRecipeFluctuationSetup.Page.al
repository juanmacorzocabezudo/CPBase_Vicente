page 60012 "CP Recipe Fluctuation Setup"
{
    ApplicationArea = All;
    Caption = 'Recipe Fluctuation Setup';
    PageType = Card;
    SourceTable = "CP Recipe Fluctuation Setup";
    UsageCategory = Administration;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field(EmailSubject; Rec."Email Subject")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a custom email subject for fluctuation notifications. Leave empty to use the default subject.';
                }
                field(EmailAccountName; Rec."Email Account Name")
                {
                    ApplicationArea = All;
                    Caption = 'Email Account';
                    ToolTip = 'Specifies the email account used to send fluctuation notifications.';
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        EmailAccount: Record "Email Account";
                        EmailAccounts: Codeunit "Email Account";
                        EmailAccountsPage: Page "Email Accounts";
                    begin
                        EmailAccounts.GetAllAccounts(false, EmailAccount);
                        EmailAccountsPage.SetTableView(EmailAccount);
                        EmailAccountsPage.LookupMode(true);
                        if EmailAccountsPage.RunModal() = Action::LookupOK then begin
                            EmailAccountsPage.GetRecord(EmailAccount);
                            Rec."Email Account Id" := EmailAccount."Account Id";
                            Rec."Email Connector" := EmailAccount.Connector;
                            Rec."Email Account Name" := EmailAccount.Name;
                            Rec.Modify();
                        end;
                    end;
                }
                field(LastRunDate; Rec."Last Run Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date and time of the last recipe fluctuation processing run.';
                }
            }
            group(Recipients)
            {
                Caption = 'Email Recipients';

                part(FluctuationRecipients; "Fluctuation Recipients")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenFluctuationList)
            {
                ApplicationArea = All;
                Caption = 'Fluctuation List';
                ToolTip = 'Specifies the action to open the list of recipe price fluctuations.';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "CP Recipe Price Fluctuation L.";
            }
            action(CreateInitialEntries)
            {
                ApplicationArea = All;
                Caption = 'Create Initial Entries';
                ToolTip = 'Specifies the action to create baseline entries for all non-blocked recipes. Use this after first setup.';
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
                begin
                    if not Confirm(ConfirmCreateInitialQst) then
                        exit;
                    RecipeFluctuationMgt.CreateInitialEntries();
                    Message(InitialEntriesCreatedMsg);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId()) then begin
            if not UserSetup."CP Fluctuation Setup Access" then
                Error(NoAccessErr);
        end else
            Error(NoAccessErr);

        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;

    var
        ConfirmCreateInitialQst: Label 'This will create baseline entries for all non-blocked recipes. Do you want to continue?';
        InitialEntriesCreatedMsg: Label 'Initial entries have been created successfully.';
        NoAccessErr: Label 'You do not have access to the Recipe Fluctuation Setup. Contact your administrator to enable the "Fluctuation Setup Access" field in User Setup.';
}
