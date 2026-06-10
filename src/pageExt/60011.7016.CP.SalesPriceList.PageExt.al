pageextension 60011 "Sales Price List" extends "Sales Price List"   //7016
{
    layout
    {
        addafter(General)
        {
            group(Filters)
            {
                Caption = 'Quick Filters';

                field(FilterCustomerNo; CustomerNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Customer No. Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                    begin
                        if CustomerNoFilter <> '' then begin
                            Customer.SetFilter("No.", CustomerNoFilter);
                            if not Customer.FindFirst() then begin
                                Customer.SetRange("No.");
                                Customer.SetFilter(Name, '@' + CustomerNoFilter + '*');
                                if Customer.FindFirst() then
                                    CustomerNoFilter := Customer."No.";
                            end;
                        end;
                        CustomerNoFilterOnAfterValidate();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Customer: Record Customer;
                        CustomerList: Page "Customer List";
                    begin
                        CustomerList.LookupMode(true);
                        if CustomerList.RunModal() = Action::LookupOK then begin
                            CustomerList.GetRecord(Customer);
                            CustomerNoFilter := Customer."No.";
                            CustomerNoFilterOnAfterValidate();
                        end;
                    end;
                }

                field(FilterItemNo; ItemNoFilter)
                {
                    ApplicationArea = All;
                    Caption = 'Item No. Filter';
                    ToolTip = 'Specifies a filter for which sales prices to display.';

                    trigger OnValidate()
                    var
                        Item: Record Item;
                    begin
                        if ItemNoFilter <> '' then begin
                            Item.SetFilter("No.", ItemNoFilter);
                            if not Item.FindFirst() then begin
                                Item.SetRange("No.");
                                Item.SetFilter(Description, '@' + ItemNoFilter + '*');
                                if Item.FindFirst() then
                                    ItemNoFilter := Item."No.";
                            end;
                        end;
                        ItemNoFilterOnAfterValidate();
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Item: Record Item;
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode(true);
                        if ItemList.RunModal() = Action::LookupOK then begin
                            ItemList.GetRecord(Item);
                            ItemNoFilter := Item."No.";
                            ItemNoFilterOnAfterValidate();
                        end;
                    end;
                }

                field(ClearFilters; ClearFiltersLbl)
                {
                    ApplicationArea = All;
                    Caption = 'Clear Filters';
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowCaption = false;

                    trigger OnDrillDown()
                    begin
                        ClearAllFilters();
                    end;
                }
            }
        }
    }

    var
        CustomerNoFilter: Text;
        ItemNoFilter: Text;
        ClearFiltersLbl: Label 'Clear All Filters';

    local procedure CustomerNoFilterOnAfterValidate()
    begin
        SetRecFilters();
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        SetRecFilters();
    end;

    local procedure SetRecFilters()
    begin
        if CustomerNoFilter <> '' then
            CurrPage.Lines.Page.SetCustomerFilter(CustomerNoFilter)
        else
            CurrPage.Lines.Page.ClearCustomerFilter();

        if ItemNoFilter <> '' then
            CurrPage.Lines.Page.SetItemFilter(ItemNoFilter)
        else
            CurrPage.Lines.Page.ClearItemFilter();

        CurrPage.Lines.Page.UpdatePage();
    end;

    local procedure ClearAllFilters()
    begin
        CustomerNoFilter := '';
        ItemNoFilter := '';
        CurrPage.Lines.Page.ClearCustomerFilter();
        CurrPage.Lines.Page.ClearItemFilter();
        CurrPage.Lines.Page.UpdatePage();
        CurrPage.Update(false);
    end;
}
