pageextension 60014 "BOM Aditional Cost OLD" extends "BOM Aditional Cost" //50059
{
    Caption = 'LM. Adicional Coste OLD';

    actions
    {
        modify(ActualiceCost) { Visible = false; } // Fusionado en "Calculate Standard Cost" de Receta
    }
}
