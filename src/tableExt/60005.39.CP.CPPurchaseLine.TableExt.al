tableextension 60005 "CP Purchase Line" extends "Purchase Line"   //39
{
    fields
    {
        modify(PrecioPropuesto) { Caption = 'precio propuesto antiguo'; }
        field(60000; "Saved Line Discount %"; Decimal)
        {
            Caption = 'Saved Line Discount %';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(60001; "Proposed Price"; Decimal)
        {
            Caption = 'Proposed Price';
            DataClassification = CustomerContent;

            Editable = false;
            DecimalPlaces = 2 : 5;
            AutoFormatType = 2;
            AutoFormatExpression = "Currency Code";
        }
    }
}
