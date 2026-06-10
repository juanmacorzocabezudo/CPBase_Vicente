page 60002 "Event Type Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Tipo de Evento";
    Caption = 'Event Type';

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Codigo"; Rec.Codigo)
                {
                    ApplicationArea = All;
                    Caption = 'Code';
                    ToolTip = 'Specifies the code of the event type.';
                }
                field(Descripcion; Rec.Descripcion)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies the description of the event type.';
                }
            }

            group(GreetingGroup)
            {
                Caption = 'Greeting';

                field("Greeting"; GreetingText)
                {
                    Caption = 'Greeting Text';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the greeting text for this event type.';

                    trigger OnValidate()
                    begin
                        Rec.SaveGreeting(GreetingText);
                    end;
                }
            }

            group(ObservationsGroup)
            {
                Caption = 'Observations';

                field("Observations"; ObservationsText)
                {
                    Caption = 'Observations Text';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the observations text for this event type.';

                    trigger OnValidate()
                    begin
                        Rec.SaveObservations(ObservationsText);
                    end;
                }
            }
            group(ObservationsText2Group)
            {
                Caption = 'Observations 2';

                field("Observations2"; ObservationsText2)
                {
                    Caption = 'Observations Text 2';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the observations text 2 for this event type.';

                    trigger OnValidate()
                    begin
                        Rec.SaveObservations2(ObservationsText2);
                    end;
                }
            }
            group(FormOfContractGroup)
            {
                Caption = 'Form of Contract and Payment';

                field("FormOfContract"; FormOfContractText)
                {
                    Caption = 'Form of Contract and Payment';
                    ShowCaption = false;
                    MultiLine = true;
                    ExtendedDatatype = RichContent;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the form of contract and payment text for this event type.';

                    trigger OnValidate()
                    begin
                        Rec.SaveFormOfContract(FormOfContractText);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GreetingText := Rec.GetGreeting();
        ObservationsText := Rec.GetObservations();
        ObservationsText2 := Rec.GetObservations2();
        FormOfContractText := Rec.GetFormOfContract();
    end;

    var
        GreetingText: Text;
        ObservationsText: Text;
        ObservationsText2: Text;
        FormOfContractText: Text;
}
