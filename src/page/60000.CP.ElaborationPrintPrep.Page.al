page 60000 "CP Elaboration Print Prep"
{
    PageType = Card;
    SourceTable = Item;
    Caption = 'Preparing receipt part';
    ApplicationArea = All;
    UsageCategory = None;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            group(Preparation)
            {
                Caption = 'Preparing report';

                label(PreparingMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Preparing the formatted elaboration for the PDF...';
                }

                usercontrol(Renderer; "CP Rich Text Renderer")
                {
                    ApplicationArea = All;

                    trigger ControlReady()
                    begin
                        CurrPage.Renderer.RenderHtml(ElaborationHtml);
                    end;

                    trigger ImageReady(ImageBase64: Text)
                    var
                        RecipePrintImage: Codeunit "CP Recipe Print Image";
                    begin
                        RecipePrintImage.SetImage(Rec."No.", ImageBase64);
                        CurrPage.Close();
                    end;

                    trigger RenderFailed(ErrorMessage: Text)
                    begin
                        Error(RenderFailedErr, ErrorMessage);
                    end;
                }
            }
        }
    }

    procedure SetRecipe(ItemNo: Code[20])
    begin
        Rec.Get(ItemNo);
        ElaborationHtml := Rec.GetElaboration();
    end;

    var
        ElaborationHtml: Text;
        RenderFailedErr: Label 'The recipe elaboration could not be prepared for printing: %1', Comment = '%1 = Rendering error';
}