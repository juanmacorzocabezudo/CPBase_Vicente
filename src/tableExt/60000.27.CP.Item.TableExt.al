tableextension 60000 Item extends Item  //27
{
    fields
    {
        field(60000; "Elaboration"; Blob)
        {
            DataClassification = CustomerContent;
            Caption = 'Elaboration';
            SubType = Memo;
        }
    }

    /// <summary>
    /// Reads the Elaboration blob value into a stream and outputs the value as a text representation.
    /// </summary>
    /// <returns>A text value, which can be used with a Rich Text Editor.</returns>
    procedure GetElaboration(): Text
    var
        TextValue: Text;
    begin
        if not TryGetElaboration(TextValue) then begin
            // If reading fails (corrupted data), clear the field
            ClearElaboration();
            exit('');
        end;
        exit(TextValue);
    end;

    [TryFunction]
    local procedure TryGetElaboration(var TextValue: Text)
    var
        InStream: InStream;
    begin
        Rec.CalcFields(Rec.Elaboration);
        Rec.Elaboration.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(TextValue);
    end;

    local procedure ClearElaboration()
    var
        OutStream: OutStream;
    begin
        Clear(Rec.Elaboration);
        Rec.Elaboration.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write('');
        Rec.Modify(true);
    end;

    /// <summary>
    /// Saves the text parameter in the Elaboration blob field.
    /// </summary>
    /// <param name="ElaborationText">The value to save in blob field.</param>
    procedure SaveElaboration(ElaborationText: Text)
    var
        OutStream: OutStream;
    begin
        if Rec."Status LM" <> Rec."Status LM"::"Under Construction" then
            Error(CannotEditElaborationCertifiedErr, Rec."No.", Rec."Status LM");
        Rec.Elaboration.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(ElaborationText);
        Rec.Modify();
    end;

    var
        CannotEditElaborationCertifiedErr: Label 'You cannot modify the elaboration of recipe %1 because its status is %2. Set the recipe to ''Under Construction'' to edit it.', Comment = '%1 = Item No., %2 = Status LM value';
}