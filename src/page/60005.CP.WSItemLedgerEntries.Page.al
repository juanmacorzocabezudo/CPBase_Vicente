page 60005 "WS Item Ledger Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Item Ledger Entry";
    Caption = 'WS Item Ledger Entries';

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

                field("N° mov."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number.';
                }
                field("Fecha registro"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the posting date.';
                }
                field("N° producto"; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the item number.';
                }
                field("Descripción Producto"; Producto.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the product description.';
                }
                field("Marca"; Producto.MarcaProveedor)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the brand from the best vendor.';
                }
                field("N° lote"; Rec."Lot No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lot number.';
                }
                field("Importe Pendiente"; Rec."Remaining Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Importe Pendiente';
                    ToolTip = 'Specifies the remaining quantity.';
                }
                field("Ud. medida Base"; Producto."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure.';
                }
                field("Fecha caducidad"; Rec."Expiration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expiration date.';
                }
                field("Sandach"; Rec.AGRALASandach)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Sandach classification.';
                }
                field(Cantidad; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity.';
                }
                field("Alias cliente"; Cliente."Search Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the customer alias.';
                }
                field("N° documento"; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document number.';
                }
                field("Tipo movimiento"; EntryName)
                {
                    ApplicationArea = All;
                    Caption = 'Tipo movimiento';
                    ToolTip = 'Specifies the entry type.';
                }
                field("Cód. procedencia mov."; Rec."Source No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source number.';
                }
                field("Familia Código"; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the family code.';
                }
                field("Linea de Negocio"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the business line.';
                }
                field("Coste Ud (Real)"; Producto."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the actual unit cost.';
                }
                field("Cantidad facturada"; Rec."Invoiced Quantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the invoiced quantity.';
                }
                field("Importe coste (Real)"; Rec."Cost Amount (Actual)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the actual cost amount.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Producto.Get(Rec."Item No.") then begin
            if Rec."Source Type" = Rec."Source Type"::Customer then begin
                if not Cliente.Get(Rec."Source No.") then
                    Clear(Cliente);
            end else
                Clear(Cliente);
        end else begin
            Clear(Producto);
            Clear(Cliente);
        end;
        TranslateEntryType();
    end;

    var
        Producto: Record Item;
        Cliente: Record Customer;
        EntryName: Text;

    local procedure TranslateEntryType()
    begin
        EntryName := '';
        case Rec."Entry Type" of
            Rec."Entry Type"::Sale:
                EntryName := 'Venta';
            Rec."Entry Type"::Purchase:
                EntryName := 'Compra';
            Rec."Entry Type"::" ":
                EntryName := ' ';
            Rec."Entry Type"::"Assembly Consumption":
                EntryName := 'Consumo ensamblados';
            Rec."Entry Type"::"Assembly Output":
                EntryName := 'Salida de ensamblado';
            Rec."Entry Type"::"Negative Adjmt.":
                EntryName := 'Ajuste negativo';
            Rec."Entry Type"::"Positive Adjmt.":
                EntryName := 'Ajuste positivo';
            Rec."Entry Type"::Transfer:
                EntryName := 'Transferencia';
            Rec."Entry Type"::Consumption:
                EntryName := 'Consumo';
            Rec."Entry Type"::Output:
                EntryName := 'Salida';
        end;
    end;
}
