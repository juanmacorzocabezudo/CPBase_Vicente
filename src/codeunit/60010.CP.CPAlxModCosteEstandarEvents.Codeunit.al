codeunit 60010 "CP AlxModCosteEstandar Events"
{
    SingleInstance = true;

    [EventSubscriber(ObjectType::Page, Page::AlxModCosteEstandar, 'OnBeforeActionEvent', 'Aceptar', false, false)]
    local procedure OnBeforeActionAceptarAlxModCosteEstandar(var Rec: Record Item)
    var
        ItemBefore: Record Item;
    begin
        if Rec."No." = '' then
            exit;
        if ItemBefore.Get(Rec."No.") then
            PreviousStandardCost := ItemBefore."Standard Cost";
    end;

    [EventSubscriber(ObjectType::Page, Page::AlxModCosteEstandar, 'OnAfterActionEvent', 'Aceptar', false, false)]
    local procedure OnAfterActionAceptarAlxModCosteEstandar(var Rec: Record Item)
    var
        ItemAfter: Record Item;
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
        ProcessWindow: Dialog;
    begin
        if Rec."No." = '' then
            exit;

        // Diálogo de progreso visible durante el recálculo de costes y envío de email.
        // Sin esto la página parece quedarse "pensando" sin dar pistas al usuario.
        ProcessWindow.Open(StrSubstNo(ProcessingMsgLbl, Rec."No."));

        // Read the item from the database to get the updated Standard Cost
        if ItemAfter.Get(Rec."No.") then
            RecipeFluctuationMgt.SetEmailTriggerCosts(PreviousStandardCost, ItemAfter."Standard Cost");

        // Recalculate and fix standard cost for all parent recipes that use this item as a BOM component.
        // Do NOT process the item itself (it's a raw material with a manually entered cost).
        RecipeFluctuationMgt.ProcessParentRecipes(Rec."No.");

        ProcessWindow.Close();
    end;

    var
        PreviousStandardCost: Decimal;
        ProcessingMsgLbl: Label 'Recalculando costes y enviando notificación para %1...\Por favor, espere.', Comment = '%1 = Item No.';
}