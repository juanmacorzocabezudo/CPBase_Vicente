pageextension 60016 "CP Work Center Subpage" extends "Work Center Subpage"
{
    layout
    {
        modify("Quantity per")
        {
            Editable = true;

            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }
        modify(Cost)
        {
            Editable = true;

            trigger OnAfterValidate()
            begin
                CurrPage.Update(true);
            end;
        }
    }
}
