pageextension 60009 "CP Purchase Price List Lines" extends "Purchase Price List Lines"   //7023
{
    layout
    {
        modify("Variant Code Lookup")
        {
            Caption = 'Marca';
        }
        modify("Line Discount %")
        {
            Visible = true;
            Editable = true;
        }

        addafter(AssignToNo)
        {
            field("Vendor Name"; VendorName)
            {
                ApplicationArea = All;
                Caption = 'Vendor Name';
                ToolTip = 'Displays the name of the vendor.';
                Editable = false;
            }
            field("Vendor Search Name"; VendorSearchName)
            {
                ApplicationArea = All;
                Caption = 'Alias';
                ToolTip = 'Displays the search name of the vendor.';
                Editable = false;
            }
        }

        addafter("Variant Code")
        {
            field("Best Vendor"; Rec."Best Vendor")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the vendor is the best option for this item.';

                trigger OnValidate()
                begin
                    ValidateBestVendor();
                end;
            }
        }
        addlast(Control1)
        {
            field("Comments"; Rec."Comments")
            {
                ApplicationArea = All;
                Caption = 'Comments';
                ToolTip = 'Additional comments regarding the price list line.';
                Editable = true;
            }
            field("Net Unit Price"; NetUnitPrice)
            {
                ApplicationArea = All;
                Caption = 'Net Unit Price';
                ToolTip = 'Displays the unit price after applying the line discount percentage.';
                Editable = false;
                DecimalPlaces = 2 : 5;
                AutoFormatType = 2;
                AutoFormatExpression = Rec."Currency Code";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalculateNetUnitPrice();
        GetVendorInfo();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CalculateNetUnitPrice();
        GetVendorInfo();
    end;

    var
        ConfirmQst: Label 'Do you want to set this vendor as the best for item %1? There is currently another vendor marked as the best.', Comment = '%1 = Item No.';
        NetUnitPrice: Decimal;
        VendorName: Text[100];
        VendorSearchName: Code[100];

    procedure SetVendorFilter(VendorFilter: Text)
    begin
        if VendorFilter <> '' then
            Rec.SetFilter("Source No.", VendorFilter);
    end;

    procedure SetItemFilter(ItemFilter: Text)
    begin
        if ItemFilter <> '' then
            Rec.SetFilter("Asset No.", ItemFilter);
    end;

    procedure ClearVendorFilter()
    begin
        Rec.SetRange("Source No.");
    end;

    procedure ClearItemFilter()
    begin
        Rec.SetRange("Asset No.");
    end;

    procedure UpdatePage()
    begin
        CurrPage.Update(false);
    end;

    local procedure CalculateNetUnitPrice()
    begin
        NetUnitPrice := Rec."Direct Unit Cost";
        if Rec."Line Discount %" <> 0 then
            NetUnitPrice := Rec."Direct Unit Cost" - (Rec."Direct Unit Cost" * Rec."Line Discount %" / 100);
    end;

    local procedure GetVendorInfo()
    var
        Vendor: Record Vendor;
    begin
        Clear(VendorName);
        Clear(VendorSearchName);

        if Rec."Source No." = '' then
            exit;

        if Vendor.Get(Rec."Source No.") then begin
            VendorName := Vendor.Name;
            VendorSearchName := Vendor."Search Name";
        end;
    end;

    local procedure ValidateBestVendor()
    var
        PriceListLine: Record "Price List Line";
    begin
        if not Rec."Best Vendor" then
            exit;

        if Rec."Asset Type" <> Rec."Asset Type"::Item then
            exit;

        PriceListLine.SetRange("Asset Type", Rec."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", Rec."Asset No.");
        PriceListLine.SetRange("Best Vendor", true);
        PriceListLine.SetFilter("Line No.", '<>%1', Rec."Line No.");

        if PriceListLine.FindFirst() then begin
            if not Confirm(ConfirmQst, false, Rec."Asset No.") then begin
                Rec."Best Vendor" := false;
                exit;
            end;

            PriceListLine."Best Vendor" := false;
            PriceListLine.Modify(true);
        end;
    end;
}
