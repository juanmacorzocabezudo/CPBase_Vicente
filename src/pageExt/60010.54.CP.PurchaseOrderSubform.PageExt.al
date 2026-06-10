pageextension 60010 "Purchase Order Subform" extends "Purchase Order Subform" //54
{
    layout
    {
        // Hide Alxia's PrecioPropuesto field to avoid confusion
        modify(PrecioPropuesto)
        {
            Visible = false;
        }

        addafter("Direct Unit Cost")
        {
            field("CP Proposed Price"; Rec."Proposed Price")
            {
                ApplicationArea = All;
                Caption = 'Precio Propuesto';
                ToolTip = 'Muestra el precio neto propuesto de la lista de precios del Mejor Proveedor (con descuento aplicado).';
                Editable = false;
            }
        }
    }
}
