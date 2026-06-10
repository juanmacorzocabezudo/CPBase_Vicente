pageextension 60001 "Ficha Evento" extends "Ficha Evento" //50006
{
    layout
    {
        modify("Textos Evento")
        {
            Caption = 'Textos Evento (Antiguo)';
            Visible = false;
        }
        addbefore("Textos Evento")
        {
            group(GreetingTextGroup)
            {
                Caption = 'Greeting (Text)';

                field("Greeting Text"; GreetingText)
                {
                    Caption = 'Greeting Text';
                    ToolTip = 'Greeting text for the event.';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SaveGreetingText(GreetingText);
                    end;
                }
            }
            group(ObservationsTextGroup)
            {
                Caption = 'Observations 1 (Text)';
                field("Observations Text"; ObservationsText)
                {
                    Caption = 'Observations Text 1';
                    ToolTip = 'Observations text 1 for the event.';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SaveObservationsText(ObservationsText);
                    end;
                }
            }
            group(ObservationsText2Group)
            {
                Caption = 'Observations 2 (Text)';
                field("Observations Text 2"; ObservationsText2)
                {
                    Caption = 'Observations Text 2';
                    ToolTip = 'Observations text 2 for the event.';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SaveObservationsText2(ObservationsText2);
                    end;
                }
            }
            group(FormOfContractGroup)
            {
                Caption = 'Form of Contract and Payment (Text)';
                field("Form of Contract and Payment"; FormOfContractText)
                {
                    Caption = 'Form of Contract and Payment';
                    ToolTip = 'Form of contract and payment text for the event.';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.SaveFormOfContractText(FormOfContractText);
                    end;
                }
            }
        }
    }

    actions
    {
        addfirst(g5)
        {
            action(PrintProductionSheet)
            {
                Caption = 'Print production sheet';
                ToolTip = 'Print the event components production sheet.';
                ApplicationArea = All;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EventComponentsReport: Report "Event Components";
                begin
                    EventComponentsReport.fijafiltros(Rec."Codigo Evento", 0);
                    EventComponentsReport.Run();
                end;
            }
            action("PrintBudget")
            {
                Caption = 'Print Budget';
                ToolTip = 'Print the event budget report with greeting text, observations and form of contract.';
                ApplicationArea = All;
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Evento: Record Evento;
                    EventBudgetReport: Report "Event Budget";
                begin
                    Evento.SetRange("Codigo Evento", Rec."Codigo Evento");
                    EventBudgetReport.SetTableView(Evento);
                    EventBudgetReport.SetOptions(true, false, false, true, true, true);
                    EventBudgetReport.Run();
                end;
            }
            action(PrintProFormaInvoice)
            {
                Caption = 'Print Pro Forma Invoice';
                ToolTip = 'Print the event budget as a pro forma invoice with billing data and observations.';
                ApplicationArea = All;
                Image = PrintDocument;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Evento: Record Evento;
                    EventBudgetReport: Report "Event Budget";
                begin
                    Evento.SetRange("Codigo Evento", Rec."Codigo Evento");
                    EventBudgetReport.SetTableView(Evento);
                    EventBudgetReport.SetOptions(false, true, false, true, false, false);
                    EventBudgetReport.Run();
                end;
            }
            action(PrintEventReport)
            {
                Caption = 'Print Event Report';
                ToolTip = 'Print the event report with comments and observations.';
                ApplicationArea = All;
                Image = Report;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Evento: Record Evento;
                    EventBudgetReport: Report "Event Budget";
                begin
                    Evento.SetRange("Codigo Evento", Rec."Codigo Evento");
                    EventBudgetReport.SetTableView(Evento);
                    EventBudgetReport.SetOptions(false, false, true, true, false, false);
                    EventBudgetReport.Run();
                end;
            }
            action(SendBudgetByEmail)
            {
                Caption = 'Send Budget by Email';
                ToolTip = 'Generate the event budget report as PDF and open the email editor to send it.';
                ApplicationArea = All;
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Evento: Record Evento;
                    EventBudgetReport: Report "Event Budget";
                    TempBlob: Codeunit "Temp Blob";
                    EmailMessage: Codeunit "Email Message";
                    Email: Codeunit Email;
                    OutStream: OutStream;
                    InStream: InStream;
                    EmailSubject: Text;
                    Recipients: Text;
                    AttachmentFileName: Text[250];
                    ReportTypeChoice: Integer;
                begin
                    ReportTypeChoice := StrMenu(ReportTypeOptionsLbl, 1, SelectReportTypeLbl);
                    if ReportTypeChoice = 0 then
                        exit;

                    Evento.SetRange("Codigo Evento", Rec."Codigo Evento");
                    EventBudgetReport.SetTableView(Evento);

                    case ReportTypeChoice of
                        1: // Budget
                            EventBudgetReport.SetOptions(true, false, false, true, true, true);
                        2: // Pro Forma Invoice
                            EventBudgetReport.SetOptions(false, true, false, true, false, false);
                        3: // Event Report
                            EventBudgetReport.SetOptions(false, false, true, true, false, false);
                    end;

                    // Generate report as PDF
                    TempBlob.CreateOutStream(OutStream);
                    if not EventBudgetReport.SaveAs('', ReportFormat::Pdf, OutStream) then
                        Error(ReportGenerationErr);

                    TempBlob.CreateInStream(InStream);

                    // Prepare email
                    AttachmentFileName := StrSubstNo(AttachmentFileNameLbl, Rec."Codigo Evento");
                    EmailSubject := StrSubstNo(EmailBudgetSubjectLbl, Rec."Codigo Evento", Rec.Descripcion);
                    Recipients := Rec."E-Mail";

                    EmailMessage.Create(Recipients, EmailSubject, '', false);
                    EmailMessage.AddAttachment(AttachmentFileName, CopyStr('application/pdf', 1, 250), InStream);

                    Email.OpenInEditor(EmailMessage);
                end;
            }
        }
        modify(Imprimir)
        {
            Visible = true;
        }
        addfirst(navigation)
        {
            action(EventTypes)
            {
                Caption = 'Event Types';
                ToolTip = 'Open the list of event types.';
                ApplicationArea = All;
                Image = Category;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "Event Type List";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LoadEventTexts();
    end;

    local procedure LoadEventTexts()
    begin
        GreetingText := Rec.GetGreetingText();
        ObservationsText := Rec.GetObservationsText();
        ObservationsText2 := Rec.GetObservationsText2();
        FormOfContractText := Rec.GetFormOfContractText();
    end;

    var
        GreetingText: Text;
        ObservationsText: Text;
        ObservationsText2: Text;
        FormOfContractText: Text;
        EmailBudgetSubjectLbl: Label 'Event Budget - %1 %2', Comment = '%1 = Event Code, %2 = Event Description';
        AttachmentFileNameLbl: Label 'EventBudget_%1.pdf', Comment = '%1 = Event Code';
        ReportGenerationErr: Label 'The budget report could not be generated. Please try again.';
        ReportTypeOptionsLbl: Label 'Budget,Pro Forma Invoice,Event Report';
        SelectReportTypeLbl: Label 'Select the report type to send:';
}
