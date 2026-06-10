pageextension 60003 "Item List" extends "Item List" //31
{
    layout
    {

        addbefore(Description)
        {
            field(Block; Rec.Blocked)
            {
                Caption = 'Blocked';
                ToolTip = 'Indicates whether the item is blocked for use in transactions.';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        modify("Duplicar Producto")
        {
            Visible = false;
        }
        addfirst(processing)
        {
            action("Duplicate Item")
            {
                Caption = 'Duplicate Item';
                ToolTip = 'Create a copy of the current item with all its components and settings.';
                Image = Copy;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ItemMgt: Codeunit "Item Management";
                begin
                    ItemMgt.DuplicateItem(Rec);
                end;
            }
            action("Activate Product")
            {
                Caption = 'Activate Product';
                ToolTip = 'Unblock this product and all its BOM components recursively.';
                Image = Approve;
                ApplicationArea = All;

                trigger OnAction()
                var
                    ItemMgt: Codeunit "Item Management";
                begin
                    ItemMgt.ActivateProduct(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
        addfirst(Category_Process)
        {
            actionref("Duplicate Item_Promoted"; "Duplicate Item")
            {
            }
            actionref("Activate Product_Promoted"; "Activate Product")
            {
            }
        }
    }
}