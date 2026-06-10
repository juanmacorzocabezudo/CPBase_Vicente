pageextension 60018 "CP Subformulario Receta" extends "Subformulario Receta" //50001
{
    layout
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                SetDefaultVendorFromPriceList();
            end;
        }
    }

    local procedure SetDefaultVendorFromPriceList()
    var
        PriceListLine: Record "Price List Line";
    begin
        if (Rec."No." = '') or (Rec.Type <> Rec.Type::Item) then
            exit;

        PriceListLine.SetRange("Price Type", PriceListLine."Price Type"::Purchase);
        PriceListLine.SetRange("Source Type", PriceListLine."Source Type"::Vendor);
        PriceListLine.SetRange("Asset Type", PriceListLine."Asset Type"::Item);
        PriceListLine.SetRange("Asset No.", Rec."No.");
        PriceListLine.SetRange(Status, PriceListLine.Status::Active);

        case PriceListLine.Count() of
            0:
                exit;
            1:
                begin
                    PriceListLine.FindFirst();
                    Rec."Proveedor por Defecto" := PriceListLine."Source No.";
                    Rec."Variant Code" := PriceListLine."Variant Code";
                end;
            else begin
                PriceListLine.SetRange("Best Vendor", true);
                if PriceListLine.FindFirst() then begin
                    Rec."Proveedor por Defecto" := PriceListLine."Source No.";
                    Rec."Variant Code" := PriceListLine."Variant Code";
                end;
            end;
        end;
    end;
}
