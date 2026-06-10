codeunit 60011 "Assembly Elaboration Events"
{
    [EventSubscriber(ObjectType::Table, Database::"Assembly Header", 'OnAfterValidateEvent', 'Item No.', false, false)]
    local procedure OnAfterValidateAssemblyHeaderItemNo(var Rec: Record "Assembly Header"; var xRec: Record "Assembly Header"; CurrFieldNo: Integer)
    var
        Item: Record Item;
        InStream: InStream;
        OutStream: OutStream;
        ElaborationText: Text;
    begin
        if Rec.IsTemporary() then
            exit;

        Clear(Rec.Elaboration);

        if Rec."Item No." = '' then
            exit;

        Item.SetLoadFields(Elaboration);
        if not Item.Get(Rec."Item No.") then
            exit;

        Item.CalcFields(Elaboration);
        if not Item.Elaboration.HasValue() then
            exit;

        Item.Elaboration.CreateInStream(InStream, TextEncoding::UTF8);
        InStream.Read(ElaborationText);

        Rec.Elaboration.CreateOutStream(OutStream, TextEncoding::UTF8);
        OutStream.Write(ElaborationText);
    end;
}
