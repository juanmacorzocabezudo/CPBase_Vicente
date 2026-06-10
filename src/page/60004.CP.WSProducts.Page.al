page 60004 "WS Products"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Item;
    Caption = 'WS Products';

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Control50000)
            {
                ShowCaption = false;

                field("N°"; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Descripción"; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item description.';
                }
                field(Inventario; Rec.Inventory)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the inventory quantity.';
                }
                field("Stock disponible"; _stockDisponible)
                {
                    ApplicationArea = All;
                    Caption = 'Stock disponible';
                    ToolTip = 'Specifies the available stock (Inventory - Assembly Orders - Sales Orders).';
                }
                field("Stock de seguridad"; Rec."Safety Stock Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the safety stock quantity.';
                }
                field("Coste unitario"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit cost.';
                }
                field("Coste estándar"; Rec."Standard Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the standard cost.';
                }
                field("Último coste directo"; Rec."Last Direct Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last direct cost.';
                }
                field("Diferencia"; Abs(Rec."Last Direct Cost" - Rec."Standard Cost"))
                {
                    ApplicationArea = All;
                    Caption = 'Diferencia';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the difference between last direct cost and standard cost.';
                }
                field("Nombre Proveedor"; Proveedor.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor name.';
                }
                field("N° proveedor"; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the vendor number.';
                }
                field("Último proveedor"; UltProveedor.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last vendor name.';
                }
                field("Fecha ultima factura compra"; Rec."Fecha ultima factura compra")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the last purchase invoice.';
                }
                field("Unidad medida base"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure.';
                }
                field("T° Conservación"; Rec.AGRALATempConservacion)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the conservation temperature.';
                }
                field("Sandach"; Rec.AGRALASandach)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sandach classification.';
                }
                field("Crítico"; Rec.Critico)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item is critical.';
                }
                field(Bloqueado; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if the item is blocked.';
                }
                field("Ubicación 1"; Ubicacion."Bin Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the bin location.';
                }
                field("Nombre familia"; Rec."Nombre Familia")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the family name.';
                }
                field("Nombre sub familia"; SubFamilia2.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subfamily description.';
                }
                field("Familia producto"; Rec."Item Category Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item category code.';
                }
                field("Sub familia producto"; SubFamilia2.Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subfamily code.';
                }
                field("Marca Proveedor"; Rec.MarcaProveedor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the brand from the best vendor price list line.';
                }
            }
        }
    }

    var
        Proveedor: Record Vendor;
        UltProveedor: Record Vendor;
        Ubicacion: Record "Bin Content";
        Factura: Record "Purch. Inv. Line";
        SubFamilia: Record "Item Category";
        SubFamilia2: Record "Item Category";
        _StockDisponible: Decimal;

    trigger OnAfterGetRecord()
    begin
        if Rec."Vendor No." <> '' then begin
            if not Proveedor.Get(Rec."Vendor No.") then
                Clear(Proveedor);
        end else
            Clear(Proveedor);

        Factura.Reset();
        Factura.SetRange("No.", Rec."No.");
        if not Factura.FindLast() then
            Clear(Factura);

        if Factura."Buy-from Vendor No." <> '' then begin
            if not UltProveedor.Get(Factura."Buy-from Vendor No.") then
                Clear(UltProveedor);
        end else
            Clear(UltProveedor);

        Ubicacion.Reset();
        Ubicacion.SetRange("Item No.", Rec."No.");
        if not Ubicacion.FindFirst() then
            Clear(Ubicacion);

        SubFamilia.Reset();
        SubFamilia.SetRange(Code, Rec."Item Category Code");
        if not SubFamilia.FindFirst() then
            Clear(SubFamilia);

        Clear(SubFamilia2);
        if SubFamilia."Parent Category" <> '' then
            if not SubFamilia2.Get(SubFamilia."Parent Category") then
                Clear(SubFamilia2);

        CalcularStockDisponible();
    end;

    local procedure CalcularStockDisponible()
    begin
        Clear(_StockDisponible);
        Rec.CalcFields(Inventory);
        Rec.CalcFields(AGRALAQtyAssemblyOrderLine);
        Rec.CalcFields(AGRALAQtyOnSalesOrder);
        _StockDisponible := Rec.Inventory - Rec.AGRALAQtyAssemblyOrderLine - Rec.AGRALAQtyOnSalesOrder;
    end;
}
