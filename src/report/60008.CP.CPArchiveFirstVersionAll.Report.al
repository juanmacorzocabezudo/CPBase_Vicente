report 60008 "CP Archive First Version All"
{
    Caption = 'Archive First Version - All Recipes';
    ProcessingOnly = true;
    ApplicationArea = All;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Item; Item)
        {
            trigger OnPreDataItem()
            begin
                Window.Open(ProcessingMsg);
                TotalRecipes := 0;
                ProcessedRecipes := 0;
                SkippedRecipes := 0;
            end;

            trigger OnAfterGetRecord()
            var
                BOMComponent: Record "BOM Component";
                BOMVersionHeader: Record 50024;
                BOMAditionalCost: Record 50029;
                BOMVersionLines: Record 50025;
                HasComponents: Boolean;
                HasVersions: Boolean;
            begin
                // Verificar si el Item tiene componentes (es una receta)
                BOMComponent.Reset();
                BOMComponent.SetRange("Parent Item No.", Item."No.");
                HasComponents := not BOMComponent.IsEmpty();

                if not HasComponents then begin
                    SkippedRecipes += 1;
                    exit;
                end;

                // Verificar si ya tiene versiones archivadas (en cualquier tabla)
                BOMVersionHeader.Reset();
                BOMVersionHeader.SetRange("Item No.", Item."No.");
                HasVersions := not BOMVersionHeader.IsEmpty();

                if not HasVersions then begin
                    // Verificar también en BOM Version Lines
                    BOMVersionLines.Reset();
                    BOMVersionLines.SetRange("Parent Item No.", Item."No.");
                    BOMVersionLines.SetFilter("BOM Version", '>0');
                    HasVersions := not BOMVersionLines.IsEmpty();
                end;

                if not HasVersions then begin
                    // Verificar también en BOM Additional Cost versionados
                    BOMAditionalCost.Reset();
                    BOMAditionalCost.SetRange("Item No", Item."No.");
                    BOMAditionalCost.SetFilter("BOM Version", '>0');
                    HasVersions := not BOMAditionalCost.IsEmpty();
                end;

                if HasVersions then begin
                    SkippedRecipes += 1;
                    exit;
                end;

                // Archivar la primera versión
                TotalRecipes += 1;
                Window.Update(1, Item."No.");
                Window.Update(2, TotalRecipes);

                if ArchiveFirstVersion(Item) then
                    ProcessedRecipes += 1;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close();
                Message(CompletionMsg, ProcessedRecipes, TotalRecipes, SkippedRecipes);
            end;
        }
    }

    local procedure ArchiveFirstVersion(var RecipeItem: Record Item): Boolean
    var
        BOMComponent: Record "BOM Component";
        RecetaComentarios: Record 50009;
        BOMVersionHeader: Record 50024;
        BOMVersionLines: Record 50025;
        BOMCommentVersion: Record 50026;
        BOMAditionalCost: Record 50029;
        BOMAditionalCostVersion: Record 50029;
        TableEvents: Codeunit "Table Events";
        VersionNum: Integer;
    begin
        VersionNum := 1;

        BOMComponent.Reset();
        BOMComponent.SetRange("Parent Item No.", RecipeItem."No.");
        if not BOMComponent.FindSet() then
            exit(false);

        // Crear cabecera de versión
        BOMVersionHeader.Init();
        BOMVersionHeader.Validate("Item No.", RecipeItem."No.");
        BOMVersionHeader.Validate("BOM Version", VersionNum);
        BOMVersionHeader.Validate(Description, RecipeItem.Description);
        BOMVersionHeader.Validate("Base Unit of Measure", RecipeItem."Base Unit of Measure");
        BOMVersionHeader.Validate("Lote Receta", RecipeItem."Lote Receta");
        BOMVersionHeader.Validate("Statistics Lot", RecipeItem."Statistics Lot");
        BOMVersionHeader.Validate("Statistics Unit of Measurement", RecipeItem."Statistics Unit of Measurement");
        BOMVersionHeader.Validate("Version Date", WorkDate());
        BOMVersionHeader.StandarCost := RecipeItem."Standard Cost";
        BOMVersionHeader.UnitCost := RecipeItem."Unit Cost";
        BOMVersionHeader.CosteLMFijado := RecipeItem.Receta_CosteLMFijado;
        BOMVersionHeader.CostesGenerales := TableEvents.CalcAditionalFixedTotalCoste(RecipeItem."No.", 0);
        BOMVersionHeader.ExWork := TableEvents.CalcAditionalFixedTotalCoste(RecipeItem."No.", 0) + RecipeItem.Receta_CosteLMFijado;

        // Copiar campo Elaboration (BLOB)
        CopyElaborationField(RecipeItem, BOMVersionHeader);

        BOMVersionHeader.Insert();

        // Copiar líneas de componentes
        repeat
            BOMVersionLines.Init();
            BOMVersionLines.TransferFields(BOMComponent);
            BOMVersionLines."BOM Version" := VersionNum;
            BOMVersionLines.Insert();
        until BOMComponent.Next() = 0;

        // Copiar comentarios
        RecetaComentarios.Reset();
        RecetaComentarios.SetRange("No.", RecipeItem."No.");
        if RecetaComentarios.FindSet() then
            repeat
                BOMCommentVersion.Init();
                BOMCommentVersion.TransferFields(RecetaComentarios);
                BOMCommentVersion."BOM Version" := VersionNum;
                BOMCommentVersion.Insert();
            until RecetaComentarios.Next() = 0;

        // Copiar costes adicionales
        BOMAditionalCost.Reset();
        BOMAditionalCost.SetRange("Item No", RecipeItem."No.");
        BOMAditionalCost.SetRange("BOM Version", 0);
        if BOMAditionalCost.FindSet() then
            repeat
                BOMAditionalCost.Validate(BOMAditionalCost.Value);

                BOMAditionalCostVersion.Init();
                BOMAditionalCostVersion.TransferFields(BOMAditionalCost);
                BOMAditionalCostVersion."BOM Version" := VersionNum;
                BOMAditionalCostVersion.Insert();
            until BOMAditionalCost.Next() = 0;

        exit(true);
    end;

    local procedure CopyElaborationField(var SourceItem: Record Item; var TargetBOMVersionHeader: Record 50024)
    var
        SourceInStream: InStream;
        TargetOutStream: OutStream;
    begin
        // Copiar el campo Elaboration (BLOB) del Item a BOMVersionHeader
        SourceItem.CalcFields(Elaboration);
        if SourceItem.Elaboration.HasValue() then begin
            SourceItem.Elaboration.CreateInStream(SourceInStream);
            TargetBOMVersionHeader.Elaboration.CreateOutStream(TargetOutStream);
            CopyStream(TargetOutStream, SourceInStream);
        end;
    end;

    var
        Window: Dialog;
        TotalRecipes: Integer;
        ProcessedRecipes: Integer;
        SkippedRecipes: Integer;
        ProcessingMsg: Label 'Archiving first version...\Recipe: #1##########\Processed: #2######', Comment = '#1 = Item No., #2 = Processed count';
        CompletionMsg: Label '%1 recipes archived successfully.\Total recipes found: %2\Skipped (already have versions or no components): %3', Comment = '%1 = Processed count, %2 = Total count, %3 = Skipped count';
}
