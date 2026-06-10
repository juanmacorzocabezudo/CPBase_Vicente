pageextension 60006 "Price List Lines" extends "Price List Lines"  //7001
{
    layout
    {
        addafter(AssignToNo)
        {
            field("Customer Name"; CustomerName)
            {
                ApplicationArea = All;
                Caption = 'Customer Name';
                Editable = false;
                ToolTip = 'Specifies the name of the customer.';
            }
            field("Customer Search Name"; CustomerSearchName)
            {
                ApplicationArea = All;
                Caption = 'Search Name';
                Editable = false;
                ToolTip = 'Specifies the search name of the customer.';
            }
        }
    }

    var
        CustomerName: Text[100];
        CustomerSearchName: Code[100];
        CustomerFilter: Text;
        ItemFilter: Text;

    trigger OnAfterGetRecord()
    var
        Customer: Record Customer;
    begin
        Clear(CustomerName);
        Clear(CustomerSearchName);

        if Rec."Assign-to No." <> '' then
            if Customer.Get(Rec."Assign-to No.") then begin
                CustomerName := Customer.Name;
                CustomerSearchName := Customer."Search Name";
            end;
    end;

    procedure SetCustomerFilter(NewCustomerFilter: Text)
    begin
        CustomerFilter := NewCustomerFilter;
    end;

    procedure ClearCustomerFilter()
    begin
        CustomerFilter := '';
    end;

    procedure SetItemFilter(NewItemFilter: Text)
    begin
        ItemFilter := NewItemFilter;
    end;

    procedure ClearItemFilter()
    begin
        ItemFilter := '';
    end;

    procedure UpdatePage()
    begin
        Rec.Reset();

        if CustomerFilter <> '' then
            Rec.SetFilter("Assign-to No.", CustomerFilter);

        if ItemFilter <> '' then
            Rec.SetFilter("Asset No.", ItemFilter);

        CurrPage.Update(false);
    end;
}