table 60007 "CP Recipe Price Fluctuation"
{
    Caption = 'Recipe Price Fluctuation';
    DataClassification = CustomerContent;
    LookupPageId = "CP Recipe Price Fluctuation L.";
    DrillDownPageId = "CP Recipe Price Fluctuation L.";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
        }
        field(3; "Item Description"; Text[100])
        {
            Caption = 'Item Description';
            FieldClass = FlowField;
            CalcFormula = lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
        field(4; "Previous Standard Cost"; Decimal)
        {
            Caption = 'Previous Standard Cost';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(5; "Current Standard Cost"; Decimal)
        {
            Caption = 'Current Standard Cost';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(6; "Fluctuation Amount"; Decimal)
        {
            Caption = 'Fluctuation Amount';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(7; "Fluctuation %"; Decimal)
        {
            Caption = 'Fluctuation %';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(8; "Detection Date"; DateTime)
        {
            Caption = 'Detection Date';
            Editable = false;
        }
        field(9; "Recipe Fixed"; Boolean)
        {
            Caption = 'Recipe Fixed';
            trigger OnValidate()
            var
                OtherEntry: Record "CP Recipe Price Fluctuation";
                RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
            begin
                if "Recipe Fixed" then begin
                    // Uncheck all other entries for the same item
                    OtherEntry.SetRange("Item No.", "Item No.");
                    OtherEntry.SetRange("Recipe Fixed", true);
                    OtherEntry.SetFilter("Entry No.", '<>%1', "Entry No.");
                    if OtherEntry.FindSet() then
                        repeat
                            OtherEntry."Recipe Fixed" := false;
                            Clear(OtherEntry."Fixed Date");
                            Clear(OtherEntry."Fixed By");
                            OtherEntry.Modify(false);
                        until OtherEntry.Next() = 0;

                    RecipeFluctuationMgt.FixRecipeCost("Item No.");
                    "Fixed Date" := CurrentDateTime();
                    "Fixed By" := CopyStr(UserId(), 1, MaxStrLen("Fixed By"));
                end else begin
                    Clear("Fixed Date");
                    Clear("Fixed By");
                end;
            end;
        }
        field(10; "Fixed Date"; DateTime)
        {
            Caption = 'Fixed Date';
            Editable = false;
        }
        field(11; "Fixed By"; Code[50])
        {
            Caption = 'Fixed By';
            Editable = false;
        }
        field(12; "Fluctuation Items"; Text[2048])
        {
            Caption = 'Fluctuation Items';
            Editable = false;
        }
        field(13; "Notification Sent"; Boolean)
        {
            Caption = 'Notification Sent';
            Editable = false;
        }
        field(14; "External Link"; Text[500])
        {
            Caption = 'External Link';
            ExtendedDatatype = URL;
        }
        field(15; "Item No. Series"; Code[20])
        {
            Caption = 'Item No. Series';
            Editable = false;
        }
        field(16; "Error Text"; Text[2048])
        {
            Caption = 'Error Text';
            Editable = false;
        }
        field(17; "Has Error"; Boolean)
        {
            Caption = 'Has Error';
            Editable = false;
        }

        // Datos del artículo (snapshot)
        field(20; "Recipe Lot"; Decimal)
        {
            Caption = 'Recipe Lot';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(21; "Unit of Measure"; Code[10])
        {
            Caption = 'Unit of Measure';
            Editable = false;
        }
        field(22; "Statistics Lot"; Decimal)
        {
            Caption = 'Statistics Lot';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(23; "Statistics Lot UoM"; Text[30])
        {
            Caption = 'Statistics Lot UoM';
            Editable = false;
        }

        // Costes Fijados (snapshot al momento de la detección)
        field(30; "Fixed BOM Total Cost"; Decimal)
        {
            Caption = 'Fixed BOM Total Cost';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(31; "Fixed General Costs"; Decimal)
        {
            Caption = 'Fixed General Costs';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(32; "Fixed EXWORK Standard"; Decimal)
        {
            Caption = 'Fixed EXWORK Standard';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(33; "Fixed Profit"; Decimal)
        {
            Caption = 'Fixed Profit';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(34; "Fixed Profit %"; Decimal)
        {
            Caption = 'Fixed Profit %';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }

        // Costes Actuales (snapshot al momento de la detección)
        field(40; "Current BOM Total Cost"; Decimal)
        {
            Caption = 'Current BOM Total Cost';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(41; "Current General Costs"; Decimal)
        {
            Caption = 'Current General Costs';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(42; "Current EXWORK Standard"; Decimal)
        {
            Caption = 'Current EXWORK Standard';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(43; "Current Profit"; Decimal)
        {
            Caption = 'Current Profit';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(44; "Current Profit %"; Decimal)
        {
            Caption = 'Current Profit %';
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ItemNo; "Item No.", "Detection Date")
        {
        }
        key(DetectionDate; "Detection Date")
        {
        }
        key(RecipeFixed; "Recipe Fixed")
        {
        }
    }
}
