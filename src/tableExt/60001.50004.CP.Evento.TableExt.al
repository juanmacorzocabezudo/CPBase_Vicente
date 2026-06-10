tableextension 60001 Evento extends Evento  //50004
{
    fields
    {
        modify("Tipo Evento")
        {
            trigger OnAfterValidate()
            var
                TipoEvento: Record "Tipo de Evento";
                LoadTemplateQst: Label 'Do you want to load the text template from event type "%1"?', Comment = '%1 = Event Type Description';
                OverwriteWarningQst: Label 'The event already has greeting and/or observation texts.\\Do you want to overwrite them with the event type template?';
                GreetingTemplate: Text;
                ObservationsTemplate: Text;
                Observations2Template: Text;
                FormOfContractTemplate: Text;
                HasExistingTexts: Boolean;
            begin
                // Solo procesar si el campo "Tipo Evento" tiene un valor
                if Rec."Tipo Evento" = '' then
                    exit;

                // Buscar el registro del Tipo de Evento
                if not TipoEvento.Get(Rec."Tipo Evento") then
                    exit;

                // Preguntar si desea cargar la plantilla
                if not Confirm(StrSubstNo(LoadTemplateQst, TipoEvento.Descripcion), false) then
                    exit;

                // Verificar si ya existen textos en el evento
                HasExistingTexts := (Rec.GetGreetingText() <> '') or (Rec.GetObservationsText() <> '') or (Rec.GetObservationsText2() <> '') or (Rec.GetFormOfContractText() <> '');

                // Si hay textos existentes, advertir antes de sobreescribir
                if HasExistingTexts then
                    if not Confirm(OverwriteWarningQst, false) then
                        exit;

                // Obtener los textos de la plantilla del Tipo de Evento
                GreetingTemplate := TipoEvento.GetGreeting();
                ObservationsTemplate := TipoEvento.GetObservations();
                Observations2Template := TipoEvento.GetObservations2();
                FormOfContractTemplate := TipoEvento.GetFormOfContract();

                // Copiar los textos al evento
                if GreetingTemplate <> '' then
                    Rec.SaveGreetingText(GreetingTemplate);

                if ObservationsTemplate <> '' then
                    Rec.SaveObservationsText(ObservationsTemplate);

                if Observations2Template <> '' then
                    Rec.SaveObservationsText2(Observations2Template);

                if FormOfContractTemplate <> '' then
                    Rec.SaveFormOfContractText(FormOfContractTemplate);
            end;
        }
        field(60000; "Greeting Text"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Greeting Text';
            Subtype = Memo;
        }
        field(60001; "Observations Text 1"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Observations Text 1';
            Subtype = Memo;
        }
        field(60002; "Observations Text 2"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Observations Text 2';
            Subtype = Memo;
        }
        field(60003; "Form of Contract and Payment"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Form of Contract and Payment';
            Subtype = Memo;
        }
    }

    procedure SaveGreetingText(TextValue: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Greeting Text".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(TextValue);
        Rec.Modify();
    end;

    procedure SaveObservationsText(TextValue: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Observations Text 1".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(TextValue);
        Rec.Modify();
    end;

    procedure SaveObservationsText2(TextValue: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Observations Text 2".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(TextValue);
        Rec.Modify();
    end;

    procedure GetGreetingText(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields("Greeting Text");
        Rec."Greeting Text".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
        exit(TextValue);
    end;

    procedure GetObservationsText(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields("Observations Text 1");
        Rec."Observations Text 1".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
        exit(TextValue);
    end;

    procedure GetObservationsText2(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields("Observations Text 2");
        Rec."Observations Text 2".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
        exit(TextValue);
    end;

    procedure SaveFormOfContractText(TextValue: Text)
    var
        OutStream: OutStream;
    begin
        Rec."Form of Contract and Payment".CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(TextValue);
        Rec.Modify();
    end;

    procedure GetFormOfContractText(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields("Form of Contract and Payment");
        Rec."Form of Contract and Payment".CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
        exit(TextValue);
    end;
}
