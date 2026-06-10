codeunit 60008 "CP Recipe Fluctuation Mgt"
{
    SingleInstance = true;

    // Codeunit para gestionar la detección de fluctuaciones de costes en recetas,
    // envío de notificaciones por email y fijación de costes estándar.

    procedure ProcessAllRecipes()
    var
        Item: Record Item;
        BOMComponent: Record "BOM Component";
        Setup: Record "CP Recipe Fluctuation Setup";
        ErrorItems: Text;
    begin
        Setup.GetSetup();
        SuppressEvents := true;
        ClearEmailBuffer();
        SetEmailTriggerSource(TriggerAllRecipesLbl);

        // Filtrar artículos no bloqueados
        Item.SetRange(Blocked, false);
        if Item.FindSet() then
            repeat
                // Solo procesar artículos que son recetas (tienen componentes LM)
                BOMComponent.SetRange("Parent Item No.", Item."No.");
                if not BOMComponent.IsEmpty() then
                    if not ProcessSingleRecipe(Item) then
                        ErrorItems += Item."No." + ', ';
            until Item.Next() = 0;

        // Actualizar fecha de última ejecución
        Setup.GetSetup();
        Setup."Last Run Date" := CurrentDateTime();
        Setup.Modify();

        // Enviar email con errores si hubo
        if ErrorItems <> '' then
            SendErrorNotification(ErrorItems);

        // Enviar email consolidado con todas las fluctuaciones
        FlushConsolidatedEmail();

        SuppressEvents := false;
    end;

    local procedure ProcessSingleRecipe(var Item: Record Item): Boolean
    var
        RecalcItem: Record Item;
        PreviousCost: Decimal;
        BOMCost: Decimal;
        CurrentEXWORK: Decimal;
    begin
        // Dedup: si este item ya se procesó en el batch actual, no volver a calcular ni
        // generar otra entrada de fluctuación. Evita duplicados cuando varios items de origen
        // comparten ancestros (p. ej. dos PI cuyo padre PT es el mismo).
        if ProcessedItemsInBatch.Contains(Item."No.") then
            exit(true);
        ProcessedItemsInBatch.Add(Item."No.");

        // Comparar contra el último coste registrado en fluctuaciones, no el actual del Item
        PreviousCost := GetLastRecordedCost(Item."No.");

        // Intentar recalcular coste estándar
        if not TryCalcItemCost(Item."No.") then begin
            CreateErrorEntry(Item, GetLastErrorText());
            exit(false);
        end;

        // Usar variable local para no alterar filtros del loop de ProcessAllRecipes
        RecalcItem.Get(Item."No.");

        // Calcular el EXWORK estándar real (BOM + costes adicionales) directamente desde componentes
        // y costes adicionales. Esto evita depender de que Alxia.CalcItem haya persistido Standard Cost,
        // cosa que no ocurre cuando la receta no tiene líneas de "Coste General" (BOM Aditional Cost).
        BOMCost := CalcBOMCostFromComponents(RecalcItem."No.");
        CurrentEXWORK := Round(BOMCost + CalcProductAdditionalCosts(RecalcItem."No.", BOMCost), 0.01);

        // Si Standard Cost no refleja el EXWORK real, persistirlo aquí
        if RecalcItem."Standard Cost" <> CurrentEXWORK then begin
            RecalcItem."Standard Cost" := CurrentEXWORK;
            RecalcItem.Modify();
        end;

        // Detectar si hay fluctuación respecto al último registro
        if RecalcItem."Standard Cost" <> PreviousCost then
            CreateFluctuationEntry(RecalcItem, PreviousCost);

        exit(true);
    end;

    [TryFunction]
    local procedure TryCalcItemCost(ItemNo: Code[20])
    var
        CalculateStdCost: Codeunit AlxiaCalculateStandardCost;
        AssemblyContainsProdBOM: Boolean;
    begin
        Clear(CalculateStdCost);
        // Pre-configurar parámetros para evitar diálogo StrMenu
        CalculateStdCost.GetCalcItemParameters(true, 2, AssemblyContainsProdBOM, false);
        CalculateStdCost.CalcItem(ItemNo, true);
    end;

    local procedure RecalcStandardCostOnly(ItemNo: Code[20]): Boolean
    var
        Item: Record Item;
        OldCost: Decimal;
        BOMCost: Decimal;
        NewCost: Decimal;
    begin
        // Recalcula y persiste únicamente el Standard Cost de un item, sin generar entrada
        // de fluctuación. Devuelve true si el coste cambió respecto a su valor anterior.
        // Se usa en el bucle iterativo de RecalcAndRecordAncestorFluctuations para estabilizar
        // costes antes de registrar las fluctuaciones (caso "diamante" en la cadena de LM).
        if not Item.Get(ItemNo) then
            exit(false);
        if Item.Blocked then
            exit(false);
        OldCost := Item."Standard Cost";
        if not TryCalcItemCost(ItemNo) then
            exit(false);
        if not Item.Get(ItemNo) then
            exit(false);
        BOMCost := CalcBOMCostFromComponents(ItemNo);
        NewCost := Round(BOMCost + CalcProductAdditionalCosts(ItemNo, BOMCost), 0.01);
        if Item."Standard Cost" <> NewCost then begin
            Item."Standard Cost" := NewCost;
            Item.Modify();
        end;
        exit(Item."Standard Cost" <> OldCost);
    end;

    local procedure RecalcAndRecordAncestorFluctuations(ComponentItemNo: Code[20])
    var
        Item: Record Item;
        AncestorList: List of [Code[20]];
        PreviousCosts: Dictionary of [Code[20], Decimal];
        ItemNo: Code[20];
        AnyChange: Boolean;
        Iteration: Integer;
        MaxIterations: Integer;
    begin
        // Recolecta todos los ancestros (recetas padre, abuelas, etc.) que dependen del componente
        // modificado. Recalcula sus costes estándar iterativamente hasta que ninguno cambia
        // (esto cubre topologías "diamante": un mismo padre que depende de varios hijos afectados).
        // Solo entonces registra UNA única entrada de fluctuación por item, comparando contra el
        // baseline previo. Evita así las entradas duplicadas con costes intermedios.
        GetAllParentRecipes(ComponentItemNo, AncestorList);
        if AncestorList.Count() = 0 then
            exit;

        // Snapshot del coste previo registrado para cada ancestro
        foreach ItemNo in AncestorList do
            if not PreviousCosts.ContainsKey(ItemNo) then
                PreviousCosts.Add(ItemNo, GetLastRecordedCost(ItemNo));

        // Bucle de estabilización. Cota de seguridad: profundidad máxima del subgrafo
        MaxIterations := AncestorList.Count() + 2;
        Iteration := 0;
        repeat
            AnyChange := false;
            Iteration += 1;
            foreach ItemNo in AncestorList do
                if RecalcStandardCostOnly(ItemNo) then
                    AnyChange := true;
        until (not AnyChange) or (Iteration >= MaxIterations);

        // Registrar a lo sumo UNA fluctuación por item, contra el baseline
        foreach ItemNo in AncestorList do
            if not ProcessedItemsInBatch.Contains(ItemNo) then
                if Item.Get(ItemNo) then
                    if not Item.Blocked then
                        if Item."Standard Cost" <> PreviousCosts.Get(ItemNo) then begin
                            ProcessedItemsInBatch.Add(ItemNo);
                            CreateFluctuationEntry(Item, PreviousCosts.Get(ItemNo));
                        end;
    end;

    local procedure CreateFluctuationEntry(var Item: Record Item; PreviousCost: Decimal)
    var
        Fluctuation: Record "CP Recipe Price Fluctuation";
        FluctuationAmount: Decimal;
        FluctuationPct: Decimal;
    begin
        FluctuationAmount := Item."Standard Cost" - PreviousCost;
        if PreviousCost <> 0 then
            FluctuationPct := (FluctuationAmount / PreviousCost) * 100
        else
            FluctuationPct := 100;

        Fluctuation.Init();
        Fluctuation."Item No." := Item."No.";
        Fluctuation."Previous Standard Cost" := PreviousCost;
        Fluctuation."Current Standard Cost" := Item."Standard Cost";
        Fluctuation."Fluctuation Amount" := FluctuationAmount;
        Fluctuation."Fluctuation %" := FluctuationPct;
        Fluctuation."Detection Date" := CurrentDateTime();
        Fluctuation."Item No. Series" := Item."No. Series";
        Fluctuation."Fluctuation Items" := CopyStr(GetFluctuatingComponents(Item."No."), 1, MaxStrLen(Fluctuation."Fluctuation Items"));
        if not TryPopulateCostSnapshot(Fluctuation, Item) then;
        Fluctuation.Insert(true);

        // Auto-fijar la nueva entrada como "Receta fijada" para todos EXCEPTO los productos
        // cuyo "No." empieza por 'PT'. En esos, la receta fijada solo cambia cuando el usuario
        // lo hace manualmente desde la página.
        if CopyStr(Item."No.", 1, 2) <> 'PT' then
            AutoFixNewFluctuationEntry(Fluctuation);

        // Acumular para email consolidado (ya no se envía individual)
        AddToEmailBuffer(Fluctuation, Item);
    end;

    local procedure AutoFixNewFluctuationEntry(var NewFluctuation: Record "CP Recipe Price Fluctuation")
    var
        OtherEntry: Record "CP Recipe Price Fluctuation";
    begin
        // Desmarcar cualquier otra entrada fijada del mismo item
        OtherEntry.SetRange("Item No.", NewFluctuation."Item No.");
        OtherEntry.SetRange("Recipe Fixed", true);
        OtherEntry.SetFilter("Entry No.", '<>%1', NewFluctuation."Entry No.");
        if OtherEntry.FindSet() then
            repeat
                OtherEntry."Recipe Fixed" := false;
                Clear(OtherEntry."Fixed Date");
                Clear(OtherEntry."Fixed By");
                OtherEntry.Modify(false);
            until OtherEntry.Next() = 0;

        // Ejecutar la fijación completa (historial, costes adicionales, sub-ensamblados)
        FixRecipeCost(NewFluctuation."Item No.");

        // Marcar la nueva entrada como fijada
        NewFluctuation."Recipe Fixed" := true;
        NewFluctuation."Fixed Date" := CurrentDateTime();
        NewFluctuation."Fixed By" := CopyStr(UserId(), 1, MaxStrLen(NewFluctuation."Fixed By"));
        NewFluctuation.Modify(false);
    end;

    local procedure CreateErrorEntry(var Item: Record Item; ErrorText: Text)
    var
        Fluctuation: Record "CP Recipe Price Fluctuation";
    begin
        Fluctuation.Init();
        Fluctuation."Item No." := Item."No.";
        Fluctuation."Previous Standard Cost" := Item."Standard Cost";
        Fluctuation."Current Standard Cost" := Item."Standard Cost";
        Fluctuation."Fluctuation Amount" := 0;
        Fluctuation."Fluctuation %" := 0;
        Fluctuation."Detection Date" := CurrentDateTime();
        Fluctuation."Item No. Series" := Item."No. Series";
        Fluctuation."Has Error" := true;
        Fluctuation."Error Text" := CopyStr(ErrorText, 1, MaxStrLen(Fluctuation."Error Text"));
        if not TryPopulateCostSnapshot(Fluctuation, Item) then;
        Fluctuation.Insert(true);
    end;

    procedure GetFluctuatingComponents(ItemNo: Code[20]): Text
    var
        BOMComponent: Record "BOM Component";
        ComponentItem: Record Item;
        Result: Text;
    begin
        // Identificar componentes cuyo coste actual difiere del coste fijado en la receta
        BOMComponent.SetRange("Parent Item No.", ItemNo);
        BOMComponent.SetRange(Type, BOMComponent.Type::Item);
        BOMComponent.SetRange(Maquila, false);
        if BOMComponent.FindSet() then
            repeat
                if ComponentItem.Get(BOMComponent."No.") then
                    if ComponentItem."Unit Cost" <> ComponentItem."Standard Cost" then begin
                        if Result <> '' then
                            Result += ', ';
                        Result += ComponentItem."No." + ' (' + ComponentItem.Description + ')';
                    end;
            until BOMComponent.Next() = 0;

        exit(Result);
    end;

    local procedure AddToEmailBuffer(var Fluctuation: Record "CP Recipe Price Fluctuation"; var Item: Record Item)
    begin
        EmailBufferEntryNo += 1;
        TempEmailBuffer.Init();
        TempEmailBuffer.TransferFields(Fluctuation);
        TempEmailBuffer."Entry No." := EmailBufferEntryNo;
        TempEmailBuffer."Item No. Series" := Item."No. Series";
        TempEmailBuffer.Insert();
    end;

    procedure SetEmailTriggerSource(SourceDescription: Text)
    begin
        TriggerSourceDescription := SourceDescription;
    end;

    procedure SetEmailTriggerCosts(PreviousCost: Decimal; CurrentCost: Decimal)
    begin
        TriggerItemPreviousCost := PreviousCost;
        TriggerItemCurrentCost := CurrentCost;
        HasTriggerCosts := true;
    end;

    procedure SetEmailTriggerDetails(DetailsHtml: Text)
    begin
        TriggerCostDetailsHtml := DetailsHtml;
    end;

    procedure ClearEmailBuffer()
    begin
        TempEmailBuffer.DeleteAll();
        EmailBufferEntryNo := 0;
        TriggerSourceDescription := '';
        TriggerItemPreviousCost := 0;
        TriggerItemCurrentCost := 0;
        HasTriggerCosts := false;
        TriggerCostDetailsHtml := '';
        // Reiniciar el control de items ya procesados al iniciar un nuevo batch
        Clear(ProcessedItemsInBatch);
    end;

    procedure FlushConsolidatedEmail()
    var
        TempPTBuffer: Record "CP Recipe Price Fluctuation" temporary;
        TempCABuffer: Record "CP Recipe Price Fluctuation" temporary;
        TempOtherBuffer: Record "CP Recipe Price Fluctuation" temporary;
        Subject: Text;
    begin
        if TempEmailBuffer.IsEmpty() then
            exit;

        // Classify entries by series into separate temp buffers
        if TempEmailBuffer.FindSet() then
            repeat
                case TempEmailBuffer."Item No. Series" of
                    'M_PT':
                        begin
                            TempPTBuffer.TransferFields(TempEmailBuffer);
                            if TempPTBuffer.Insert() then;
                        end;
                    'M_CA':
                        begin
                            TempCABuffer.TransferFields(TempEmailBuffer);
                            if TempCABuffer.Insert() then;
                        end;
                    else
                        ClassifyByParentRecipes(TempEmailBuffer, TempPTBuffer, TempCABuffer, TempOtherBuffer);
                end;
            until TempEmailBuffer.Next() = 0;

        Subject := ConsolidatedEmailSubjectLbl;

        // Send PT emails (with and without costs separately)
        if not TempPTBuffer.IsEmpty() then
            SendEmailsByRecipientType("Fluctuation Recipient Type"::PT, Subject, TempPTBuffer);

        // Send CA emails
        if not TempCABuffer.IsEmpty() then
            SendEmailsByRecipientType("Fluctuation Recipient Type"::CA, Subject, TempCABuffer);

        // Send Other (unrecognized series) to both groups
        if not TempOtherBuffer.IsEmpty() then begin
            SendEmailsByRecipientType("Fluctuation Recipient Type"::PT, Subject, TempOtherBuffer);
            SendEmailsByRecipientType("Fluctuation Recipient Type"::CA, Subject, TempOtherBuffer);
        end;

        ClearEmailBuffer();
    end;

    local procedure SendEmailsByRecipientType(RecipientType: Enum "Fluctuation Recipient Type"; Subject: Text; var TempBufferEntries: Record "CP Recipe Price Fluctuation" temporary)
    var
        Recipient: Record "Fluctuation Recipient";
        CostRecipients: Text;
        InfoRecipients: Text;
    begin
        Recipient.SetRange("Recipient Type", RecipientType);
        if not Recipient.FindSet() then
            exit;

        repeat
            if Recipient."Include Costs" then begin
                if CostRecipients <> '' then
                    CostRecipients += ';';
                CostRecipients += Recipient."Email Address";
            end else begin
                if InfoRecipients <> '' then
                    InfoRecipients += ';';
                InfoRecipients += Recipient."Email Address";
            end;
        until Recipient.Next() = 0;

        if CostRecipients <> '' then
            SendConsolidatedEmailForGroup(CostRecipients, Subject, TempBufferEntries, true);

        if InfoRecipients <> '' then
            SendConsolidatedEmailForGroup(InfoRecipients, Subject, TempBufferEntries, false);
    end;

    local procedure SendConsolidatedEmailForGroup(Recipients: Text; Subject: Text; var TempBufferEntries: Record "CP Recipe Price Fluctuation" temporary; IncludeCosts: Boolean)
    var
        Item: Record Item;
        Body: Text;
    begin
        Body := '<h2>Fluctuación de coste detectada</h2>';

        if TriggerSourceDescription <> '' then
            Body += StrSubstNo(EmailOriginLbl, TriggerSourceDescription);

        if IncludeCosts and HasTriggerCosts then
            Body += StrSubstNo(EmailTriggerCostLbl, Format(TriggerItemPreviousCost), Format(TriggerItemCurrentCost));

        if IncludeCosts and (TriggerCostDetailsHtml <> '') then
            Body += TriggerCostDetailsHtml;

        Body += '<br/>';
        Body += '<table border="1" cellpadding="6" cellspacing="0" style="border-collapse:collapse;">';
        Body += '<tr style="background-color:#333;color:#fff;">';
        if IncludeCosts then
            Body += '<th>Cod Prod</th><th>Descripción</th><th>Coste anterior</th><th>Coste nuevo</th><th>Fluctuación</th>'
        else
            Body += '<th>Cod Prod</th><th>Descripción</th>';
        Body += '</tr>';

        if TempBufferEntries.FindSet() then
            repeat
                if Item.Get(TempBufferEntries."Item No.") then;

                Body += '<tr>';
                Body += StrSubstNo(EmailTdLbl, TempBufferEntries."Item No.");
                Body += StrSubstNo(EmailTdLbl, Item.Description);
                if IncludeCosts then begin
                    Body += StrSubstNo(EmailTdLbl, Format(TempBufferEntries."Previous Standard Cost"));
                    Body += StrSubstNo(EmailTdLbl, Format(TempBufferEntries."Current Standard Cost"));
                    Body += StrSubstNo(EmailTdFluctuationLbl, Format(TempBufferEntries."Fluctuation Amount"), Format(TempBufferEntries."Fluctuation %") + '%');
                end;
                Body += '</tr>';
            until TempBufferEntries.Next() = 0;

        Body += '</table>';

        CreateAndSendEmail(Recipients, Subject, Body);
    end;

    local procedure SendErrorNotification(ErrorItems: Text)
    var
        Recipient: Record "Fluctuation Recipient";
        Recipients: Text;
        Subject: Text;
        Body: Text;
    begin
        Recipient.SetRange("Recipient Type", "Fluctuation Recipient Type"::Error);
        if Recipient.FindSet() then
            repeat
                if Recipients <> '' then
                    Recipients += ';';
                Recipients += Recipient."Email Address";
            until Recipient.Next() = 0;

        // Fallback: if no Error recipients, send to PT + CA recipients
        if Recipients = '' then
            Recipients := GetAllRecipientsForTypes();

        if Recipients = '' then
            exit;

        Subject := ErrorEmailSubjectLbl;
        Body := StrSubstNo(ErrorEmailBodyLbl, ErrorItems);

        CreateAndSendEmail(Recipients, Subject, Body);
    end;

    local procedure GetAllRecipientsForTypes(): Text
    var
        Recipient: Record "Fluctuation Recipient";
        Recipients: Text;
    begin
        Recipient.SetFilter("Recipient Type", '%1|%2', "Fluctuation Recipient Type"::PT, "Fluctuation Recipient Type"::CA);
        if Recipient.FindSet() then
            repeat
                if Recipients <> '' then
                    Recipients += ';';
                Recipients += Recipient."Email Address";
            until Recipient.Next() = 0;
        exit(Recipients);
    end;

    [TryFunction]
    local procedure TrySendEmail(Recipients: Text; Subject: Text; Body: Text)
    var
        FluctuationSetup: Record "CP Recipe Fluctuation Setup";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        RecipientList: List of [Text];
    begin
        FluctuationSetup.GetSetup();
        if IsNullGuid(FluctuationSetup."Email Account Id") then
            Error(NoEmailAccountConfiguredErr);

        RecipientList := Recipients.Split(';');
        EmailMessage.Create(RecipientList, Subject, Body, true);
        Email.Send(EmailMessage, FluctuationSetup."Email Account Id", FluctuationSetup."Email Connector");
    end;

    local procedure CreateAndSendEmail(Recipients: Text; Subject: Text; Body: Text)
    begin
        if not TrySendEmail(Recipients, Subject, Body) then
            if not SuppressMessages then
                Message(EmailSendFailedMsg, GetLastErrorText());
    end;

    procedure FixRecipeCost(ItemNo: Code[20])
    var
        ItemLocal: Record Item;
        BOMAditionalCost: Record "BOM Aditional Cost";
        BOMComponent: Record "BOM Component";
        CostHistory: Record AGRALAHistoricoCosteGeneral;
        CalculateStdCost: Codeunit AlxiaCalculateStandardCost;
        AssemblyContainsProdBOM: Boolean;
    begin
        // 1. Recalcular coste estándar desde componentes LM
        Clear(CalculateStdCost);
        // Pre-configurar parámetros para evitar diálogo StrMenu
        CalculateStdCost.GetCalcItemParameters(true, 2, AssemblyContainsProdBOM, false);
        CalculateStdCost.CalcItem(ItemNo, true);

        // Recargar el artículo con el coste actualizado
        if not ItemLocal.Get(ItemNo) then
            exit;

        // 2. Registrar historial de coste estándar
        CostHistory.Reset();
        CostHistory.SetRange(AGRALAIdProducto, ItemNo);
        CostHistory.SetRange(AGRALACosteGeneral, ItemLocal."Standard Cost");
        if not CostHistory.FindFirst() then begin
            CostHistory.AGRALAIdProducto := ItemLocal."No.";
            CostHistory.AGRALACosteGeneral := ItemLocal."Standard Cost";
            CostHistory.AGRALAFechaModificacion := CurrentDateTime();
            CostHistory.Insert();
        end;

        // 3. Fijar costes adicionales del producto principal.
        //    Si NO hay líneas de Coste General, ActualicyCost no se llamaría y Standard Cost
        //    quedaría sin actualizar. En ese caso lo persistimos manualmente con el EXWORK real.
        BOMAditionalCost.Reset();
        BOMAditionalCost.SetRange("Item No", ItemNo);
        BOMAditionalCost.SetRange("BOM Version", 0);
        if BOMAditionalCost.FindFirst() then
            BOMAditionalCost.ActualicyCost(ItemNo, 0)
        else
            PersistStandardCostFromComponents(ItemNo);

        // 4. Fijar costes de sub-ensamblados
        BOMComponent.Reset();
        BOMComponent.SetRange("Parent Item No.", ItemNo);
        BOMComponent.SetRange(Maquila, false);
        BOMComponent.SetRange("Assembly BOM", true);
        if BOMComponent.FindSet() then
            repeat
                BOMAditionalCost.Reset();
                BOMAditionalCost.SetRange("Item No", BOMComponent."No.");
                if BOMAditionalCost.FindSet() then
                    repeat
                        BOMAditionalCost.ActualicyCost(BOMAditionalCost."Item No", BOMAditionalCost."BOM Version");
                    until BOMAditionalCost.Next() = 0;
            until BOMComponent.Next() = 0;

        // 5. Re-fijar costes del producto principal tras sub-ensamblados
        BOMAditionalCost.Reset();
        BOMAditionalCost.SetRange("Item No", ItemNo);
        BOMAditionalCost.SetRange("BOM Version", 0);
        if BOMAditionalCost.FindFirst() then
            BOMAditionalCost.ActualicyCost(ItemNo, 0)
        else
            PersistStandardCostFromComponents(ItemNo);
    end;

    local procedure PersistStandardCostFromComponents(ItemNo: Code[20])
    var
        ItemLocal: Record Item;
        BOMCost: Decimal;
        ExworkCost: Decimal;
    begin
        // Calcula el EXWORK estándar real (BOM + costes adicionales) y lo persiste en Item.
        // Necesario para recetas SIN líneas de "Coste General", donde ActualicyCost no se ejecuta.
        if not ItemLocal.Get(ItemNo) then
            exit;
        BOMCost := CalcBOMCostFromComponents(ItemNo);
        ExworkCost := Round(BOMCost + CalcProductAdditionalCosts(ItemNo, BOMCost), 0.01);
        if ItemLocal."Standard Cost" <> ExworkCost then begin
            ItemLocal."Standard Cost" := ExworkCost;
            ItemLocal.Modify();
        end;
    end;

    procedure CreateInitialEntries()
    var
        Item: Record Item;
        BOMComponent: Record "BOM Component";
        Fluctuation: Record "CP Recipe Price Fluctuation";
        ExistingFluctuation: Record "CP Recipe Price Fluctuation";
    begin
        // Crear entradas base para todas las recetas no bloqueadas que tienen componentes LM
        Item.SetRange(Blocked, false);
        if Item.FindSet() then
            repeat
                // Solo procesar artículos que son recetas (tienen componentes LM)
                BOMComponent.SetRange("Parent Item No.", Item."No.");
                if not BOMComponent.IsEmpty() then begin
                    // Solo crear si no existe ya una entrada para este artículo
                    ExistingFluctuation.SetRange("Item No.", Item."No.");
                    if ExistingFluctuation.IsEmpty() then begin
                        Fluctuation.Init();
                        Fluctuation."Entry No." := 0;
                        Fluctuation."Item No." := Item."No.";
                        Fluctuation."Previous Standard Cost" := Item."Standard Cost";
                        Fluctuation."Current Standard Cost" := Item."Standard Cost";
                        Fluctuation."Fluctuation Amount" := 0;
                        Fluctuation."Fluctuation %" := 0;
                        Fluctuation."Detection Date" := CurrentDateTime();
                        Fluctuation."Item No. Series" := Item."No. Series";
                        Fluctuation."Recipe Fixed" := true;
                        Fluctuation."Fixed Date" := CurrentDateTime();
                        Fluctuation."Fixed By" := CopyStr(UserId(), 1, MaxStrLen(Fluctuation."Fixed By"));
                        PopulateCostSnapshot(Fluctuation, Item);
                        Fluctuation.Insert(false);
                    end;
                end;
            until Item.Next() = 0;
    end;

    local procedure PopulateCostSnapshot(var Fluctuation: Record "CP Recipe Price Fluctuation"; var Item: Record Item)
    var
        BeneficioLine: Record "BOM Aditional Cost";
        TotalFixedCost: Decimal;
        TotalProductCosts: Decimal;
        BOMCost: Decimal;
        FixedProfitVal: Decimal;
        ProductProfitVal: Decimal;
    begin
        // Datos del artículo
        Fluctuation."Recipe Lot" := Item."Lote Receta";
        Fluctuation."Unit of Measure" := Item."Base Unit of Measure";
        Fluctuation."Statistics Lot" := Item."Statistics Lot";
        Fluctuation."Statistics Lot UoM" := CopyStr(Format(Item."Statistics Lot") + ' ' + Item."Base Unit of Measure", 1, MaxStrLen(Fluctuation."Statistics Lot UoM"));

        // ==== COSTES FIJADOS ====
        Fluctuation."Fixed BOM Total Cost" := Round(Item.Receta_CosteLMFijado, 0.01);
        TotalFixedCost := CalcFixedAdditionalCosts(Item."No.");

        // Separar beneficio fijado
        if FindBeneficioLine(BeneficioLine, Item."No.") then begin
            FixedProfitVal := BeneficioLine."Aditional fixed cost";
            Fluctuation."Fixed General Costs" := Round(TotalFixedCost - FixedProfitVal, 0.01);
            Fluctuation."Fixed Profit" := Round(FixedProfitVal, 0.01);
        end else begin
            Fluctuation."Fixed General Costs" := Round(TotalFixedCost, 0.01);
            Fluctuation."Fixed Profit" := 0;
        end;
        Fluctuation."Fixed EXWORK Standard" := Round(Item.Receta_CosteLMFijado + TotalFixedCost, 0.01);

        if (Fluctuation."Fixed General Costs" + Item.Receta_CosteLMFijado) <> 0 then
            Fluctuation."Fixed Profit %" := Round((FixedProfitVal / (Fluctuation."Fixed General Costs" + Item.Receta_CosteLMFijado) * 100), 0.01)
        else
            Fluctuation."Fixed Profit %" := 0;

        // ==== COSTES ACTUALES (PRODUCTO) ====
        BOMCost := CalcBOMCostFromComponents(Item."No.");
        Fluctuation."Current BOM Total Cost" := Round(BOMCost, 0.01);
        TotalProductCosts := CalcProductAdditionalCosts(Item."No.", BOMCost);

        // Separar beneficio producto
        if FindBeneficioLine(BeneficioLine, Item."No.") then begin
            ProductProfitVal := CalcBeneficioProductCost(BeneficioLine, Item."No.", BOMCost);
            Fluctuation."Current General Costs" := Round(TotalProductCosts - ProductProfitVal, 0.01);
            Fluctuation."Current Profit" := Round(ProductProfitVal, 0.01);
        end else begin
            Fluctuation."Current General Costs" := Round(TotalProductCosts, 0.01);
            Fluctuation."Current Profit" := 0;
        end;
        Fluctuation."Current EXWORK Standard" := Round(BOMCost + TotalProductCosts, 0.01);

        if (Fluctuation."Current General Costs" + BOMCost) <> 0 then
            Fluctuation."Current Profit %" := Round((ProductProfitVal / (Fluctuation."Current General Costs" + BOMCost) * 100), 0.01)
        else
            Fluctuation."Current Profit %" := 0;
    end;

    local procedure CalcBOMCostFromComponents(ItemNo: Code[20]): Decimal
    var
        BOMComp: Record "BOM Component";
        ComponentItem: Record Item;
        Resource: Record Resource;
        ItemUoM: Record "Item Unit of Measure";
        TotalCost: Decimal;
        UoMFactor: Decimal;
    begin
        BOMComp.SetRange("Parent Item No.", ItemNo);
        BOMComp.SetRange(Maquila, false);
        if BOMComp.FindSet() then
            repeat
                if BOMComp.Type = BOMComp.Type::Item then begin
                    if ComponentItem.Get(BOMComp."No.") then begin
                        if ItemUoM.Get(BOMComp."No.", BOMComp."Unit of Measure Code") then
                            UoMFactor := ItemUoM."Qty. per Unit of Measure"
                        else
                            UoMFactor := 1;
                        TotalCost += BOMComp."Quantity per" * ComponentItem."Standard Cost" * UoMFactor;
                    end;
                end else
                    if BOMComp.Type = BOMComp.Type::Resource then
                        if Resource.Get(BOMComp."No.") then
                            TotalCost += BOMComp."Quantity per" * Resource."Unit Cost";
            // Tipos desconocidos (Producto Estudio, Materia Prima Nueva, Supply) se omiten
            until BOMComp.Next() = 0;
        exit(TotalCost);
    end;

    local procedure CalcFixedAdditionalCosts(ItemNo: Code[20]): Decimal
    var
        BOMAditionalCost: Record "BOM Aditional Cost";
        TotalCost: Decimal;
    begin
        BOMAditionalCost.SetRange("Item No", ItemNo);
        BOMAditionalCost.SetRange("BOM Version", 0);
        if BOMAditionalCost.FindSet() then
            repeat
                TotalCost += BOMAditionalCost."Aditional fixed cost";
            until BOMAditionalCost.Next() = 0;
        exit(TotalCost);
    end;

    local procedure CalcProductAdditionalCosts(ItemNo: Code[20]; BOMCost: Decimal): Decimal
    var
        BOMAditionalCost: Record "BOM Aditional Cost";
        TotalCost: Decimal;
    begin
        // Fase 1: líneas sin "Apply on all cost"
        BOMAditionalCost.SetRange("Item No", ItemNo);
        BOMAditionalCost.SetRange("BOM Version", 0);
        BOMAditionalCost.SetRange("Apply on all cost", false);
        if BOMAditionalCost.FindSet() then
            repeat
                if BOMAditionalCost."Type Coste" = BOMAditionalCost."Type Coste"::"%" then
                    TotalCost += BOMCost * BOMAditionalCost.Value / 100
                else
                    TotalCost += BOMAditionalCost.Value;
            until BOMAditionalCost.Next() = 0;

        // Fase 2: líneas con "Apply on all cost" (típicamente el beneficio)
        BOMAditionalCost.SetRange("Apply on all cost", true);
        if BOMAditionalCost.FindSet() then
            repeat
                if BOMAditionalCost."Type Coste" = BOMAditionalCost."Type Coste"::"%" then
                    TotalCost += (TotalCost + BOMCost) * BOMAditionalCost.Value / 100
                else
                    TotalCost += BOMAditionalCost.Value;
            until BOMAditionalCost.Next() = 0;

        exit(TotalCost);
    end;

    local procedure CalcBeneficioProductCost(var BeneficioLine: Record "BOM Aditional Cost"; ItemNo: Code[20]; BOMCost: Decimal): Decimal
    var
        BOMAditionalCost: Record "BOM Aditional Cost";
        OtherLinesCost: Decimal;
    begin
        // Línea de beneficio sin "Apply on all" (caso fallback por descripción)
        if not BeneficioLine."Apply on all cost" then
            if BeneficioLine."Type Coste" = BeneficioLine."Type Coste"::"%" then
                exit(Round(BeneficioLine.Value * BOMCost / 100, 0.01))
            else
                exit(BeneficioLine.Value);

        // Calcular coste de todas las OTRAS líneas adicionales
        BOMAditionalCost.SetRange("Item No", ItemNo);
        BOMAditionalCost.SetRange("BOM Version", 0);
        BOMAditionalCost.SetFilter("No. Cost", '<>%1', BeneficioLine."No. Cost");
        if BOMAditionalCost.FindSet() then
            repeat
                if BOMAditionalCost."Type Coste" = BOMAditionalCost."Type Coste"::"%" then
                    OtherLinesCost += Round(BOMAditionalCost.Value * BOMCost / 100, 0.01)
                else
                    OtherLinesCost += BOMAditionalCost.Value;
            until BOMAditionalCost.Next() = 0;

        // Aplicar beneficio sobre (coste componentes + costes adicionales)
        if BeneficioLine."Type Coste" = BeneficioLine."Type Coste"::"%" then
            exit(Round(BeneficioLine.Value * (OtherLinesCost + BOMCost) / 100, 0.01))
        else
            exit(OtherLinesCost + BeneficioLine.Value);
    end;

    [TryFunction]
    local procedure TryPopulateCostSnapshot(var Fluctuation: Record "CP Recipe Price Fluctuation"; var Item: Record Item)
    begin
        PopulateCostSnapshot(Fluctuation, Item);
    end;

    local procedure FindBeneficioLine(var BeneficioLine: Record "BOM Aditional Cost"; ItemNo: Code[20]): Boolean
    begin
        // Primero: línea con "Apply on all cost" = TRUE
        BeneficioLine.Reset();
        BeneficioLine.SetRange("Item No", ItemNo);
        BeneficioLine.SetRange("BOM Version", 0);
        BeneficioLine.SetRange("Apply on all cost", true);
        if BeneficioLine.FindFirst() then
            exit(true);

        // Segundo: línea cuya descripción contenga 'beneficio'
        BeneficioLine.Reset();
        BeneficioLine.SetRange("Item No", ItemNo);
        BeneficioLine.SetRange("BOM Version", 0);
        if BeneficioLine.FindSet() then
            repeat
                if StrPos(LowerCase(BeneficioLine."Description Cost"), 'beneficio') > 0 then
                    exit(true);
            until BeneficioLine.Next() = 0;

        exit(false);
    end;

    local procedure GetLastRecordedCost(ItemNo: Code[20]): Decimal
    var
        LastEntry: Record "CP Recipe Price Fluctuation";
        Item: Record Item;
    begin
        LastEntry.SetRange("Item No.", ItemNo);
        LastEntry.SetRange("Has Error", false);
        LastEntry.SetCurrentKey("Item No.", "Detection Date");
        if LastEntry.FindLast() then
            exit(LastEntry."Current Standard Cost");

        // Si no hay entradas previas, usar el coste actual del Item como baseline
        if Item.Get(ItemNo) then
            exit(Item."Standard Cost");
        exit(0);
    end;

    procedure ProcessAndFixSingleRecipe(ItemNo: Code[20])
    var
        Item: Record Item;
        Fluctuation: Record "CP Recipe Price Fluctuation";
        PreviousCost: Decimal;
    begin
        if not Item.Get(ItemNo) then
            exit;

        // Dedup: si este item ya fue procesado en el batch actual (incluyendo propagaciones
        // desde otras llamadas), no repetir el cálculo ni generar otra fluctuación.
        if ProcessedItemsInBatch.Contains(ItemNo) then
            exit;
        ProcessedItemsInBatch.Add(ItemNo);

        PreviousCost := GetLastRecordedCost(ItemNo);

        SuppressEvents := true;
        FixRecipeCost(ItemNo);

        Item.Get(ItemNo);

        if Item."Standard Cost" <> PreviousCost then begin
            CreateFluctuationEntry(Item, PreviousCost);

            // Para productos cuyo "No." empieza por 'PT' NO se actualiza la "Receta fijada"
            // automáticamente. La fijación de receta solo cambia cuando el usuario lo hace
            // manualmente desde la página de fluctuaciones.
            if CopyStr(Item."No.", 1, 2) <> 'PT' then begin
                // Marcar la entrada como fijada (el usuario la fijó explícitamente)
                // First, uncheck all other fixed entries for this item
                Fluctuation.SetRange("Item No.", ItemNo);
                Fluctuation.SetRange("Recipe Fixed", true);
                if Fluctuation.FindSet() then
                    repeat
                        Fluctuation."Recipe Fixed" := false;
                        Clear(Fluctuation."Fixed Date");
                        Clear(Fluctuation."Fixed By");
                        Fluctuation.Modify(false);
                    until Fluctuation.Next() = 0;

                // Then, mark the new entry as fixed
                Fluctuation.Reset();
                Fluctuation.SetRange("Item No.", ItemNo);
                Fluctuation.SetRange("Has Error", false);
                Fluctuation.SetCurrentKey("Item No.", "Detection Date");
                if Fluctuation.FindLast() then begin
                    Fluctuation."Recipe Fixed" := true;
                    Fluctuation."Fixed Date" := CurrentDateTime();
                    Fluctuation."Fixed By" := CopyStr(UserId(), 1, MaxStrLen(Fluctuation."Fixed By"));
                    Fluctuation.Modify(false);
                end;
            end;

            // Propagar a recetas padre con el mismo flujo iterativo (estabilizar costes y
            // registrar a lo sumo una fluctuación por ancestro). Cubre topologías diamante.
            RecalcAndRecordAncestorFluctuations(ItemNo);
        end;

        SuppressEvents := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterModifyEvent', '', false, false)]
    local procedure OnItemCostChanged(var Rec: Record Item; var xRec: Record Item; RunTrigger: Boolean)
    begin
        if SuppressEvents then
            exit;
        if Rec."Standard Cost" = xRec."Standard Cost" then
            exit;

        SuppressEvents := true;
        ClearEmailBuffer();
        SetEmailTriggerSource(StrSubstNo(TriggerItemCostChangedLbl, Rec."No.", Rec.Description));
        SetEmailTriggerCosts(xRec."Standard Cost", Rec."Standard Cost");

        // Mismo flujo iterativo que ProcessParentRecipes para evitar duplicados / costes intermedios.
        RecalcAndRecordAncestorFluctuations(Rec."No.");

        FlushConsolidatedEmail();
        SuppressEvents := false;
    end;

    [EventSubscriber(ObjectType::Table, Database::"BOM Component", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnBOMComponentSubstitution(var Rec: Record "BOM Component"; var xRec: Record "BOM Component"; RunTrigger: Boolean)
    var
        OldItem: Record Item;
        NewItem: Record Item;
        OldDesc: Text;
        NewDesc: Text;
    begin
        if SuppressEvents then
            exit;
        // Solo procesar sustituciones reales: ambos No. deben tener valor y ser distintos
        if (Rec."No." = xRec."No.") or (xRec."No." = '') or (Rec."No." = '') then
            exit;
        if Rec.Type <> Rec.Type::Item then
            exit;

        if OldItem.Get(xRec."No.") then
            OldDesc := OldItem.Description;
        if NewItem.Get(Rec."No.") then
            NewDesc := NewItem.Description;

        SuppressEvents := true;
        SuppressMessages := true;
        ClearEmailBuffer();
        SetEmailTriggerSource(StrSubstNo(TriggerSubstitutionLbl, xRec."No.", OldDesc, Rec."No.", NewDesc, Rec."Parent Item No."));

        ProcessAndFixSingleRecipe(Rec."Parent Item No.");

        FlushConsolidatedEmail();
        SuppressEvents := false;
        SuppressMessages := false;
    end;

    local procedure GetAllParentRecipes(ComponentNo: Code[20]; var RecipesToProcess: List of [Code[20]])
    var
        BOMComponent: Record "BOM Component";
    begin
        BOMComponent.SetRange(Type, BOMComponent.Type::Item);
        BOMComponent.SetRange("No.", ComponentNo);
        if BOMComponent.FindSet() then
            repeat
                if not RecipesToProcess.Contains(BOMComponent."Parent Item No.") then begin
                    RecipesToProcess.Add(BOMComponent."Parent Item No.");
                    // Buscar recursivamente hacia arriba en la cadena de LM
                    GetAllParentRecipes(BOMComponent."Parent Item No.", RecipesToProcess);
                end;
            until BOMComponent.Next() = 0;
    end;

    local procedure ClassifyByParentRecipes(var SourceEntry: Record "CP Recipe Price Fluctuation" temporary; var TempPTBuffer: Record "CP Recipe Price Fluctuation" temporary; var TempCABuffer: Record "CP Recipe Price Fluctuation" temporary; var TempOtherBuffer: Record "CP Recipe Price Fluctuation" temporary)
    var
        ParentItem: Record Item;
        ParentRecipes: List of [Code[20]];
        ParentItemNo: Code[20];
        AddedToPT: Boolean;
        AddedToCA: Boolean;
    begin
        // Buscar todas las recetas padre (recursivo) y clasificar según su serie
        GetAllParentRecipes(SourceEntry."Item No.", ParentRecipes);

        foreach ParentItemNo in ParentRecipes do
            if ParentItem.Get(ParentItemNo) then
                case ParentItem."No. Series" of
                    'M_PT':
                        AddedToPT := true;
                    'M_CA':
                        AddedToCA := true;
                end;

        if AddedToPT then begin
            TempPTBuffer.TransferFields(SourceEntry);
            if TempPTBuffer.Insert() then;
        end;

        if AddedToCA then begin
            TempCABuffer.TransferFields(SourceEntry);
            if TempCABuffer.Insert() then;
        end;

        // Si no tiene padres PT ni CA reconocidos, fallback al buffer "Other" (se envía a ambos)
        if (not AddedToPT) and (not AddedToCA) then begin
            TempOtherBuffer.TransferFields(SourceEntry);
            if TempOtherBuffer.Insert() then;
        end;
    end;

    procedure ProcessParentRecipes(ComponentItemNo: Code[20])
    var
        ComponentItem: Record Item;
        SavedPreviousCost: Decimal;
        SavedCurrentCost: Decimal;
        SavedHasTriggerCosts: Boolean;
    begin
        SuppressMessages := true;
        // SuppressEvents evita que cada Item.Modify desencadene OnItemCostChanged y vuelva a iterar
        SuppressEvents := true;
        // Preservar los costes de disparo establecidos por el llamador (p.ej. página Modificar Coste Estándar),
        // ya que ClearEmailBuffer los resetea y son necesarios para mostrar el bloque
        // "Coste estándar anterior // Coste estándar actual" en el email consolidado.
        SavedPreviousCost := TriggerItemPreviousCost;
        SavedCurrentCost := TriggerItemCurrentCost;
        SavedHasTriggerCosts := HasTriggerCosts;
        ClearEmailBuffer();
        if SavedHasTriggerCosts then
            SetEmailTriggerCosts(SavedPreviousCost, SavedCurrentCost);
        if ComponentItem.Get(ComponentItemNo) then
            SetEmailTriggerSource(StrSubstNo(TriggerRawMaterialLbl, ComponentItemNo, ComponentItem.Description))
        else
            SetEmailTriggerSource(StrSubstNo(TriggerRawMaterialNoDescLbl, ComponentItemNo));

        // Recalcula iterativamente hasta estabilizar y registra a lo sumo una fluctuación por item.
        // Esto evita duplicados tanto en cadenas lineales como en topologías "diamante".
        RecalcAndRecordAncestorFluctuations(ComponentItemNo);

        FlushConsolidatedEmail();
        SuppressEvents := false;
        SuppressMessages := false;
    end;

    procedure SetSuppressMessages(NewValue: Boolean)
    begin
        SuppressMessages := NewValue;
    end;

    var
        TempEmailBuffer: Record "CP Recipe Price Fluctuation" temporary;
        ProcessedItemsInBatch: List of [Code[20]];
        TriggerSourceDescription: Text;
        SuppressEvents: Boolean;
        SuppressMessages: Boolean;
        ConsolidatedEmailSubjectLbl: Label 'Fluctuación de coste detectada';
        ErrorEmailSubjectLbl: Label 'Recipe Cost Calculation Errors';
        ErrorEmailBodyLbl: Label '<h2>Recipe Cost Calculation Errors</h2><p>The following recipes had errors during cost recalculation:</p><p>%1</p>', Comment = '%1 = List of items with errors';
        NoEmailAccountConfiguredErr: Label 'No email account is configured in Recipe Fluctuation Setup. Please select an email account.';
        EmailSendFailedMsg: Label 'The email notification could not be sent. The process will continue.\Error: %1', Comment = '%1 = Error message';
        EmailOriginLbl: Label '<p><strong>Origen:</strong> %1</p>', Comment = '%1 = Trigger source description';
        EmailTdLbl: Label '<td>%1</td>', Comment = '%1 = Cell value';
        EmailTdFluctuationLbl: Label '<td>%1 (%2)</td>', Comment = '%1 = Fluctuation amount, %2 = Fluctuation percentage with symbol';
        TriggerItemCostChangedLbl: Label 'Cambio de coste estándar: %1 - %2', Comment = '%1 = Item No., %2 = Item Description';
        TriggerRawMaterialLbl: Label 'Materia prima: %1 - %2', Comment = '%1 = Item No., %2 = Item Description';
        TriggerRawMaterialNoDescLbl: Label 'Materia prima: %1', Comment = '%1 = Item No.';
        TriggerAllRecipesLbl: Label 'Proceso automático de todas las recetas';
        TriggerSubstitutionLbl: Label 'Sustitución de material en receta %5: %1 (%2) → %3 (%4)', Comment = '%1 = Old Item No., %2 = Old Description, %3 = New Item No., %4 = New Description, %5 = Parent Item No.';
        EmailTriggerCostLbl: Label '<p style="color:#c00000;"><strong>Coste estandar anterior: %1 €</strong> // <strong>Coste estandar actual: %2 €</strong></p>', Comment = '%1 = Previous cost, %2 = Current cost';
        EmailBufferEntryNo: Integer;
        TriggerItemPreviousCost: Decimal;
        TriggerItemCurrentCost: Decimal;
        HasTriggerCosts: Boolean;
        TriggerCostDetailsHtml: Text;
}
