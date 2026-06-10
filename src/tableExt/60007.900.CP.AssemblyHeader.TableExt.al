tableextension 60007 "Assembly Header" extends "Assembly Header" //900
{
    fields
    {
        field(60100; "Elaboration"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Elaboration';
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
}
