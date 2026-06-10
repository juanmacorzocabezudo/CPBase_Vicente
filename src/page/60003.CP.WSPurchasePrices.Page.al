page 60003 "WS Purchase Prices"
{
    ApplicationArea = All;
    Caption = 'WS Purchase Prices';
    PageType = List;
    SourceTable = "Price List Line";
    SourceTableView = where("Price Type" = const(Purchase), "Source Type" = const(Vendor), "Asset Type" = const(Item));
    UsageCategory = Lists;

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    LinksAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("N° Producto"; Rec."Asset No.")
                {
                    ApplicationArea = All;
                    Caption = 'N° Producto';
                    ToolTip = 'Specifies the number of the item that the purchase price applies to.';
                }
                field("N° Proveedor"; Rec."Source No.")
                {
                    ApplicationArea = All;
                    Caption = 'N° Proveedor';
                    ToolTip = 'Specifies the number of the vendor who offers the line discount on the item.';
                }
                field("Cód. Divisa"; Rec."Currency Code")
                {
                    ApplicationArea = All;
                    Caption = 'Cód. Divisa';
                    ToolTip = 'Specifies the currency code of the purchase price.';
                }
                field("Fecha inicio"; Rec."Starting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Fecha inicio';
                    ToolTip = 'Specifies the date from which the purchase price is valid.';
                }
                field("Costo unitario"; Rec."Direct Unit Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Costo unitario';
                    ToolTip = 'Specifies the cost of one unit of the selected item or resource.';
                }
                field("Cantidad minima"; Rec."Minimum Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Cantidad minima';
                    ToolTip = 'Specifies the minimum quantity of the item that you must buy from the vendor in order to get the purchase price.';
                }
                field("Fecha fin"; Rec."Ending Date")
                {
                    ApplicationArea = All;
                    Caption = 'Fecha fin';
                    ToolTip = 'Specifies the date to which the purchase price is valid.';
                }
                field("Cód. unidad medida"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = All;
                    Caption = 'Cód. unidad medida';
                    ToolTip = 'Specifies how each unit of the item or resource is measured.';
                }
                field("Cód. variante"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    Caption = 'Cód. variante';
                    ToolTip = 'Specifies the variant of the item on the line.';
                }
                field(AGRALADescription; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Descripción del producto';
                    ToolTip = 'Specifies the description of the product.';
                }
                field(Definicion; Rec."Comments")
                {
                    ApplicationArea = All;
                    Caption = 'Definicion';
                    ToolTip = 'Specifies additional definition or comments.';
                }
                field(AGRALANombreProveedor; VendorName)
                {
                    ApplicationArea = All;
                    Caption = 'Nombre proveedor';
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor.';
                }
                field(AGRALALineDescuento; Rec."Line Discount %")
                {
                    ApplicationArea = All;
                    Caption = '% Descuento linea';
                    ToolTip = 'Specifies the line discount percentage.';
                }
                field(AGRALAImporteDescontado; Rec."Amount Discount")
                {
                    ApplicationArea = All;
                    Caption = 'Coste unit. direct. con descuento';
                    Editable = false;
                    ToolTip = 'Specifies the direct unit cost after applying the discount.';
                }
                field("Mejor Proveedor"; Rec."Best Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Mejor Proveedor';
                    ToolTip = 'Specifies if this is the best vendor for this item.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Vendor: Record Vendor;
    begin
        Clear(VendorName);
        if Rec."Source No." <> '' then
            if Vendor.Get(Rec."Source No.") then
                VendorName := Vendor.Name;
    end;

    var
        VendorName: Text[100];
}
