tableextension 60006 "Tipo de Evento" extends "Tipo de Evento" //50001"
{
    fields
    {
        field(60000; "Greeting Text"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Greeting Text';
            Subtype = Memo;
        }
        field(60001; "Observations Text"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Observations Text';
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

    procedure GetGreeting(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Greeting Text");
        Rec."Greeting Text".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure SaveGreeting(NewGreeting: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Greeting Text");
        Rec."Greeting Text".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewGreeting);
        Modify(true);
    end;

    procedure GetObservations(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Observations Text");
        Rec."Observations Text".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure SaveObservations(NewObservations: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Observations Text");
        Rec."Observations Text".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewObservations);
        Modify(true);
    end;

    procedure GetObservations2(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Observations Text 2");
        Rec."Observations Text 2".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure SaveObservations2(NewObservations2: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Observations Text 2");
        Rec."Observations Text 2".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewObservations2);
        Modify(true);
    end;

    procedure GetFormOfContract(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Form of Contract and Payment");
        Rec."Form of Contract and Payment".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator()));
    end;

    procedure SaveFormOfContract(NewFormOfContract: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec."Form of Contract and Payment");
        Rec."Form of Contract and Payment".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewFormOfContract);
        Modify(true);
    end;
}