pageextension 60002 "Item Card" extends "Item Card" //30
{
    layout
    {
        modify(NombreProveedor) { Visible = false; }
        addafter("Vendor No.")
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
                ToolTip = 'Shows the name of the vendor assigned to this item.';
                Editable = false;

                trigger OnDrillDown()
                var
                    Vendor: Record Vendor;
                begin
                    if Vendor.Get(Rec."Vendor No.") then
                        Page.Run(Page::"Vendor Card", Vendor);
                end;
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

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        if Vendor.Get(Rec."Vendor No.") then
            VendorName := Vendor.Name
        else
            VendorName := '';
    end;

    var
        VendorName: Text[100];
}