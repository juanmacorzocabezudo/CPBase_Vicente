tableextension 60009 "BOM Version Header" extends "BOM Version Header" //50024
{
    fields
    {
        field(60000; "Elaboration"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Elaboración';
            SubType = Memo;
        }
    }

    procedure GetElaboration(): Text
    var
        InStream: InStream;
        TextValue: Text;
    begin
        Rec.CalcFields(Elaboration);
        if not Rec.Elaboration.HasValue() then
            exit('');
        Rec.Elaboration.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
        exit(TextValue);
    end;

    procedure SaveElaboration(NewText: Text)
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Elaboration);
        Rec.Elaboration.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.WriteText(NewText);
    end;
}
