codeunit 60001 "CP Recipe Print Image"
{
    SingleInstance = true;

    procedure SetImage(ItemNo: Code[20]; ImageBase64: Text)
    begin
        BufferedItemNo := ItemNo;
        BufferedImageBase64 := ImageBase64;
    end;

    procedure GetImage(ItemNo: Code[20]): Text
    begin
        if BufferedItemNo <> ItemNo then
            exit('');

        exit(BufferedImageBase64);
    end;

    procedure HasImage(ItemNo: Code[20]): Boolean
    begin
        exit((BufferedItemNo = ItemNo) and (BufferedImageBase64 <> ''));
    end;

    procedure ClearImage()
    begin
        Clear(BufferedItemNo);
        Clear(BufferedImageBase64);
    end;

    var
        BufferedItemNo: Code[20];
        BufferedImageBase64: Text;
}