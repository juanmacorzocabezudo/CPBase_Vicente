codeunit 60005 "Item Management"
{
    procedure DuplicateItem(var SourceItem: Record Item)
    var
        NewItem: Record Item;
        InventorySetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        SelectedNoSeries: Code[20];
        NewItemNo: Code[20];
    begin
        if SourceItem."No." = '' then
            exit;

        if not Confirm(ConfirmDuplicateQst, false) then
            exit;

        // Get Inventory Setup
        InventorySetup.Get();
        InventorySetup.TestField("Item Nos.");

        // Show No. Series selection (AssistEdit)
        SelectedNoSeries := SourceItem."No. Series";
        if not NoSeriesMgt.LookupRelatedNoSeries(InventorySetup."Item Nos.", SourceItem."No. Series", SelectedNoSeries) then
            exit;

        // Get next number from selected series
        NewItemNo := NoSeriesMgt.GetNextNo(SelectedNoSeries);
        if NewItemNo = '' then
            exit;

        // Create new item and open it
        NewItem := CreateDuplicateItem(SourceItem, NewItemNo, SelectedNoSeries);
        Page.Run(Page::"Item Card", NewItem);
    end;

    local procedure CreateDuplicateItem(SourceItem: Record Item; NewItemNo: Code[20]; NoSeriesCode: Code[20]) ItemCopy: Record Item
    begin
        // Create new item with specified number
        ItemCopy.TransferFields(SourceItem);
        ItemCopy."No." := NewItemNo;
        ItemCopy."No. Series" := NoSeriesCode;
        ItemCopy.Blocked := true;
        ItemCopy.Insert(true);

        // Validate dimensions and costs
        ItemCopy.Validate("Global Dimension 1 Code");
        ItemCopy.Validate("Global Dimension 2 Code");
        ItemCopy.Validate("Unit Cost", 0);
        ItemCopy.Validate("Standard Cost", 0);
        ItemCopy.Validate("Last Direct Cost", 0);
        ItemCopy.Validate("Status LM", ItemCopy."Status LM"::"Under Construction");
        ItemCopy.Modify(true);

        // Copy default dimensions
        CopyDefaultDimensions(SourceItem."No.", ItemCopy."No.");

        // Restore global dimensions from source
        ItemCopy.Validate("Global Dimension 1 Code", SourceItem."Global Dimension 1 Code");
        ItemCopy.Validate("Global Dimension 2 Code", SourceItem."Global Dimension 2 Code");
        ItemCopy.Modify();

        // Copy units of measure
        CopyUnitsOfMeasure(SourceItem."No.", ItemCopy."No.");

        // Copy BOM components
        CopyBOMComponents(SourceItem."No.", ItemCopy."No.");

        // Copy BOM additional costs
        CopyBOMAdditionalCosts(SourceItem."No.", ItemCopy."No.");

        // Set final status
        ItemCopy.Validate("Status LM", ItemCopy."Status LM"::"Under Construction");
        ItemCopy.Modify();
    end;

    local procedure CopyDefaultDimensions(SourceItemNo: Code[20]; TargetItemNo: Code[20])
    var
        SourceDimension: Record "Default Dimension";
        TargetDimension: Record "Default Dimension";
    begin
        SourceDimension.Reset();
        SourceDimension.SetRange("Table ID", Database::Item);
        SourceDimension.SetRange("No.", SourceItemNo);
        if SourceDimension.FindSet() then
            repeat
                TargetDimension.TransferFields(SourceDimension);
                TargetDimension."No." := TargetItemNo;
                TargetDimension.Insert(true);
            until SourceDimension.Next() = 0;
    end;

    local procedure CopyUnitsOfMeasure(SourceItemNo: Code[20]; TargetItemNo: Code[20])
    var
        SourceUnitOfMeasure: Record "Item Unit of Measure";
        TargetUnitOfMeasure: Record "Item Unit of Measure";
    begin
        SourceUnitOfMeasure.Reset();
        SourceUnitOfMeasure.SetRange("Item No.", SourceItemNo);
        if SourceUnitOfMeasure.FindSet() then
            repeat
                TargetUnitOfMeasure.TransferFields(SourceUnitOfMeasure);
                TargetUnitOfMeasure."Item No." := TargetItemNo;
                TargetUnitOfMeasure.Insert(true);
            until SourceUnitOfMeasure.Next() = 0;
    end;

    local procedure CopyBOMComponents(SourceItemNo: Code[20]; TargetItemNo: Code[20])
    var
        SourceBOMComponent: Record "BOM Component";
        TargetBOMComponent: Record "BOM Component";
    begin
        SourceBOMComponent.Reset();
        SourceBOMComponent.SetRange("Parent Item No.", SourceItemNo);
        if SourceBOMComponent.FindSet() then
            repeat
                TargetBOMComponent.TransferFields(SourceBOMComponent);
                TargetBOMComponent."Parent Item No." := TargetItemNo;
                TargetBOMComponent.Insert(true);
            until SourceBOMComponent.Next() = 0;
    end;

    local procedure CopyBOMAdditionalCosts(SourceItemNo: Code[20]; TargetItemNo: Code[20])
    var
        SourceBOMAditionalCost: Record "BOM Aditional Cost";
        TargetBOMAditionalCost: Record "BOM Aditional Cost";
    begin
        SourceBOMAditionalCost.Reset();
        SourceBOMAditionalCost.SetRange("Item No", SourceItemNo);
        if SourceBOMAditionalCost.FindSet() then
            repeat
                TargetBOMAditionalCost.TransferFields(SourceBOMAditionalCost);
                TargetBOMAditionalCost."Item No" := TargetItemNo;
                TargetBOMAditionalCost.Insert(true);
            until SourceBOMAditionalCost.Next() = 0;
    end;

    procedure ActivateProduct(var ItemToActivate: Record Item)
    var
        NoSeriesMgt: Codeunit "No. Series";
        OldItemNo: Code[20];
        NewItemNo: Code[20];
        ItemPrefix: Text[6];
        NoSeriesCode: Code[20];
    begin
        if ItemToActivate."No." = '' then
            exit;

        // Check if the item has a DES-MA, DES-MP or DES-PT prefix
        ItemPrefix := CopyStr(ItemToActivate."No.", 1, 6);
        if not ((ItemPrefix = 'DES-MA') or (ItemPrefix = 'DES-MP') or (ItemPrefix = 'DES-PT')) then begin
            Error(ProductAlreadyActiveErr);
            exit;
        end;

        // Determine the corresponding No. Series based on the prefix
        case ItemPrefix of
            'DES-MA':
                NoSeriesCode := 'M_MA';
            'DES-MP':
                NoSeriesCode := 'M_MP';
            'DES-PT':
                NoSeriesCode := 'M_PT';
        end;

        // Get next number from the corresponding series
        NewItemNo := NoSeriesMgt.GetNextNo(NoSeriesCode);
        if NewItemNo = '' then
            exit;

        if not Confirm(ConfirmActivateQst, false, ItemToActivate."No.", NewItemNo) then
            exit;

        OldItemNo := ItemToActivate."No.";

        // Rename the item to the new number
        ItemToActivate.Rename(NewItemNo);

        // Activate the main item
        ItemToActivate.Get(NewItemNo);
        ItemToActivate."No. Series" := NoSeriesCode;
        ItemToActivate.Blocked := false;
        ItemToActivate.Modify(true);

        // If it's an assembly BOM, activate all components recursively
        if ItemToActivate."Replenishment System" = ItemToActivate."Replenishment System"::Assembly then
            ActivateBOMComponents(ItemToActivate."No.");

        Message(ProductActivatedMsg, OldItemNo, NewItemNo);

        // Open email dialog
        OpenEmailDialog(ItemToActivate);
    end;

    local procedure OpenEmailDialog(ItemToActivate: Record Item)
    var
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailSubject: Text;
        Recipients: Text;
    begin
        EmailSubject := StrSubstNo(EmailSubjectLbl, ItemToActivate."No.", ItemToActivate.Description);
        Recipients := 'calidad@comidaspopulares.com; procesos@comidaspopulares.com; laboratorio@comidaspopulares.com; compras@comidaspopulares.com; gestion@comidaspopulares.com; contabilidad@comidaspopulares.com; info@comidaspopulares.com; administracion@comidaspopulares.com; produccion@comidaspopulares.com; javier.lorenzo@comidaspopulares.com';

        EmailMessage.Create(Recipients, EmailSubject, '', false);

        Email.OpenInEditor(EmailMessage);
    end;

    local procedure ActivateBOMComponents(ParentItemNo: Code[20])
    var
        BOMComponent: Record "BOM Component";
        ComponentItem: Record Item;
        NoSeriesMgt: Codeunit "No. Series";
        ItemPrefix: Text[6];
        NoSeriesCode: Code[20];
        NewItemNo: Code[20];
    begin
        BOMComponent.Reset();
        BOMComponent.SetRange("Parent Item No.", ParentItemNo);
        BOMComponent.SetRange(Type, BOMComponent.Type::Item);
        if BOMComponent.FindSet() then
            repeat
                if ComponentItem.Get(BOMComponent."No.") then begin
                    // Check if the component has a DES-MA, DES-MP or DES-PT prefix
                    ItemPrefix := CopyStr(ComponentItem."No.", 1, 6);
                    if (ItemPrefix = 'DES-MA') or (ItemPrefix = 'DES-MP') or (ItemPrefix = 'DES-PT') then begin
                        // Determine the corresponding No. Series based on the prefix
                        case ItemPrefix of
                            'DES-MA':
                                NoSeriesCode := 'M_MA';
                            'DES-MP':
                                NoSeriesCode := 'M_MP';
                            'DES-PT':
                                NoSeriesCode := 'M_PT';
                        end;

                        // Get next number from the corresponding series
                        NewItemNo := NoSeriesMgt.GetNextNo(NoSeriesCode);
                        if NewItemNo <> '' then begin
                            // Rename the component item to the new number
                            ComponentItem.Rename(NewItemNo);
                            ComponentItem.Get(NewItemNo);
                            ComponentItem."No. Series" := NoSeriesCode;

                            // Update BOM Component reference to the new number
                            BOMComponent."No." := NewItemNo;
                            BOMComponent.Modify(true);
                        end;
                    end;

                    // Activate the component
                    ComponentItem.Blocked := false;
                    ComponentItem.Modify(true);

                    // If this component is also an assembly BOM, activate its components recursively
                    if ComponentItem."Replenishment System" = ComponentItem."Replenishment System"::Assembly then
                        ActivateBOMComponents(ComponentItem."No.");
                end;
            until BOMComponent.Next() = 0;
    end;

    var
        ConfirmDuplicateQst: Label 'Warning: A new item reference will be created as a copy of the current one. Are you sure?';
        ConfirmActivateQst: Label 'Do you want to activate product %1 and change its number to %2, including all its BOM components?', Comment = '%1 = Old Item No., %2 = New Item No.';
        ProductActivatedMsg: Label 'Product %1 has been activated and renumbered to %2. All components have been activated successfully.', Comment = '%1 = Old Item No., %2 = New Item No.';
        ProductAlreadyActiveErr: Label 'This product is already active or does not have a DES-MA, DES-MP, or DES-PT prefix. It cannot be activated again.';
        EmailSubjectLbl: Label 'Product %1 - %2 has been activated', Comment = '%1 = Item No., %2 = Item Description';
}
