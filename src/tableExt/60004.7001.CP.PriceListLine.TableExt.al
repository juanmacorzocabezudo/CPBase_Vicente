tableextension 60004 "Price List Line" extends "Price List Line"    //7001
{
    fields
    {
        field(60000; "Best Vendor"; Boolean)
        {
            Caption = 'Best Vendor';
            DataClassification = CustomerContent;
        }
        field(60001; "Comments"; Text[250])
        {
            Caption = 'Comments';
            DataClassification = CustomerContent;
        }
        field(60002; "Amount Discount"; Decimal)
        {
            Caption = 'Amount Discount';
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

}