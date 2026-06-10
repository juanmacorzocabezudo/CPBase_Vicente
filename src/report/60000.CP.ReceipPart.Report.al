report 60000 "Receip Part"
{
    ApplicationArea = All;
    Caption = 'Receipt Part';
    UsageCategory = Administration;
    DefaultLayout = RDLC;
    //WordLayout = './src/report/layout/ReceipPart.docx';
    RDLCLayout = './src/report/layout/ReceipPart.rdl';

    dataset
    {
        dataitem(Item; Item)
        {
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(imagenproducto; Item.Picture)
            {
            }
            column(No_Item; Item."No.")
            {
            }
            column(LoteReceta_Item; Item."Lote Receta")
            {
            }
            column(PercLoss_Item; Item."Perc. Loss")
            {
            }
            column(StatisticsLot_Item; Item."Statistics Lot")
            {
            }
            column(BaseUnitofMeasure_Item; Item."Base Unit of Measure")
            {
            }
            column(Description_Item; Item.Description)
            {
            }
            column(QuantityCaliente; VarQtyCaliente)
            {
            }
            column(VarMostrarRecursos; VarMostrarRecursos)
            {
            }
            column(ElaborationText; ElaborationText)
            {
            }
            dataitem("BOM Component"; "BOM Component")
            {
                CalcFields = "Assembly BOM";
                DataItemLink = "Parent Item No." = FIELD("No.");
                DataItemTableView = SORTING("Parent Item No.", "Line No.") ORDER(Ascending) WHERE(Type = CONST(Item));

                column(LineNo_BOMComponent; "BOM Component"."Line No.")
                {
                }
                column(No_BOMComponent; "BOM Component"."No.")
                {
                }
                column(VariantCode_BOMComponent; "BOM Component"."Variant Code")
                {
                }
                column(Description_BOMComponent; "BOM Component".Description)
                {
                }
                column(varDescription; varDescripcion)
                {
                }
                column(UnitofMeasureCode_BOMComponent; "BOM Component"."Unit of Measure Code")
                {
                }
                column(Quantityper_BOMComponent; "BOM Component"."Quantity per")
                {
                }
                column(CantidadporLote_BOMComponent; "BOM Component"."Cantidad por Lote")
                {
                }
                column(Position_BOMComponent; "BOM Component".Position)
                {
                }
                column(Position2_BOMComponent; "BOM Component"."Position 2")
                {
                }
                column(Position3_BOMComponent; "BOM Component"."Position 3")
                {
                }
                column(ImportanciaenCoste_BOMComponent; "BOM Component"."Importancia en Coste")
                {
                }
                column(CantidadporBandeja_BOMComponent; "BOM Component"."Cantidad por Bandeja")
                {
                }
                column(ProveedorporDefecto_BOMComponent; "BOM Component"."Proveedor por Defecto")
                {
                }
                column(CosteUnitario_BOMComponent; "BOM Component".CosteUnitario)
                {
                }
                column(Comentario_BOMComponent; "BOM Component".Comentario)
                {
                }
                column(CosteCalculado_BOMComponent; "BOM Component"."Coste Calculado")
                {
                }
                column(TipoRecurso_BOMComponent; "BOM Component".TipoRecurso)
                {
                }
                column(RelatedWorkCenter_BOMComponent; "BOM Component"."Related Work Center")
                {
                }
                column(Maquila_BOMComponent; "BOM Component".Maquila)
                {
                }
                column(PercLoss_BOMComponent; "BOM Component"."Perc. Loss")
                {
                }
                column(NetAmount_BOMComponent; "BOM Component"."Net Amount")
                {
                }
                column(ParentItemDesciption_BOMComponent; "BOM Component"."Parent Item Desciption")
                {
                }
                column(Sombrear; gb_Sombrear)
                {
                }
                column(VarProductoLM; VarProductoLM)
                {
                }
                trigger OnAfterGetRecord()
                var
                    rItem: Record Item;
                begin
                    gb_Sombrear := TRUE;

                    CLEAR(VarProductoLM);
                    CASE "BOM Component".Type OF
                        "BOM Component".Type::Item:
                            BEGIN
                                gr_Item.RESET();
                                gr_Item.SETRANGE("No.", "BOM Component"."No.");
                                IF gr_Item.FINDFIRST() THEN BEGIN
                                    gb_Sombrear := gr_Item."Item Tracking Code" = '';
                                    VarProductoLM := "BOM Component"."Assembly BOM";
                                END;
                            END;
                    END;
                    //SL BEGIN GAP00009 
                    Clear(varDescripcion);
                    rItem.Reset();
                    rItem.SetRange("No.", "BOM Component"."No.");
                    if rItem.FindFirst() then
                        varDescripcion := rItem.Description;
                    //SL END GAP00009 
                end;
            }
            dataitem("BOM Component Resource"; "BOM Component")
            {
                DataItemLink = "Parent Item No." = FIELD("No.");
                DataItemTableView = SORTING("Parent Item No.", "Line No.") ORDER(Ascending) WHERE(Type = FILTER(<> Item));

                column(LineNo_BOMComponentResource; "BOM Component Resource"."Line No.")
                {
                }
                column(No_BOMComponentResource; "BOM Component Resource"."No.")
                {
                }
                column(VarRecursoNegrita; VarRecursoNegrita)
                {
                }
                column(VariantCode_BOMComponentResource; "BOM Component Resource"."Variant Code")
                {
                }
                column(Description_BOMComponentResource; "BOM Component Resource".Description)
                {
                }
                column(UnitofMeasureCode_BOMComponentResource; "BOM Component Resource"."Unit of Measure Code")
                {
                }
                column(Quantityper_BOMComponentResource; "BOM Component Resource"."Quantity per")
                {
                }
                column(CantidadporLote_BOMComponentResource; "BOM Component Resource"."Cantidad por Lote")
                {
                }
                column(Position_BOMComponentResource; "BOM Component Resource".Position)
                {
                }
                column(Position2_BOMComponentResource; "BOM Component Resource"."Position 2")
                {
                }
                column(Position3_BOMComponentResource; "BOM Component Resource"."Position 3")
                {
                }
                column(ImportanciaenCoste_BOMComponentResource; "BOM Component Resource"."Importancia en Coste")
                {
                }
                column(CantidadporBandeja_BOMComponentResource; "BOM Component Resource"."Cantidad por Bandeja")
                {
                }
                column(ProveedorporDefecto_BOMComponentResource; "BOM Component Resource"."Proveedor por Defecto")
                {
                }
                column(CosteUnitario_BOMComponentResource; "BOM Component Resource".CosteUnitario)
                {
                }
                column(Comentario_BOMComponentResource; "BOM Component Resource".Comentario)
                {
                }
                column(CosteCalculado_BOMComponentResource; "BOM Component Resource"."Coste Calculado")
                {
                }
                column(TipoRecurso_BOMComponentResource; "BOM Component Resource".TipoRecurso)
                {
                }
                column(RelatedWorkCenter_BOMComponentResource; "BOM Component Resource"."Related Work Center")
                {
                }
                column(Maquila_BOMComponentResource; "BOM Component Resource".Maquila)
                {
                }
                column(PercLoss_BOMComponentResource; "BOM Component Resource"."Perc. Loss")
                {
                }
                column(NetAmount_BOMComponentResource; "BOM Component Resource"."Net Amount")
                {
                }
                column(ParentItemDesciption_BOMComponentResource; "BOM Component Resource"."Parent Item Desciption")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CLEAR(VarRecursoNegrita);
                    IF ("BOM Component Resource".Type = "BOM Component Resource".Type::" ") AND ("BOM Component Resource"."Related Work Center" <> '') THEN VarRecursoNegrita := TRUE;
                end;
            }
            dataitem("Receta Comentarios"; "Receta Comentarios")
            {
                DataItemLink = "No." = FIELD("No.");
                DataItemTableView = SORTING("Table Name", "No.", "Line No.") WHERE("Table Name" = CONST(Receta));

                column(LineNo_RecetaComentarios; "Receta Comentarios"."Line No.")
                {
                }
                column(No_RecetaComentarios; "Receta Comentarios"."No.")
                {
                }
                column(Comment_RecetaComentarios; "Receta Comentarios".Comment)
                {
                }
                column(ImprimeRojo_RecetaComentarios; "Receta Comentarios"."Imprime Rojo")
                {
                }
                column(Subrayadoamarillo_RecetaComentarios; "Receta Comentarios"."Subrayado amarillo")
                {
                }
                column(FormatLine_RecetaComentarios; "Receta Comentarios"."Format Line")
                {
                }
                column(Comment2_RecetaComentarios; "Receta Comentarios"."Comment 2")
                {
                }
                column(FormatLine2_RecetaComentarios; "Receta Comentarios"."Format Line 2")
                {
                }
                column(Subrayadoamarillo2_RecetaComentarios; "Receta Comentarios"."Subrayado amarillo 2")
                {
                }
                column(VarNormal; VarNormal)
                {
                }
                column(VarNegrita; VarNegrita)
                {
                }
                column(VarAzul; VarAzul)
                {
                }
                column(VarRojo; VarRojo)
                {
                }
                column(VarNormal2; VarNormal2)
                {
                }
                column(VarNegrita2; VarNegrita2)
                {
                }
                column(VarAzul2; VarAzul2)
                {
                }
                column(VarRojo2; VarRojo2)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CLEAR(VarNormal);
                    CLEAR(VarNegrita);
                    CLEAR(VarAzul);
                    CLEAR(VarRojo);
                    CLEAR(VarNormal2);
                    CLEAR(VarNegrita2);
                    CLEAR(VarAzul2);
                    CLEAR(VarRojo2);
                    CASE "Receta Comentarios"."Format Line" OF
                        "Receta Comentarios"."Format Line"::" ":
                            VarNormal := TRUE;
                        "Receta Comentarios"."Format Line"::StandardAccent:
                            VarAzul := TRUE;
                        "Receta Comentarios"."Format Line"::Unfavorable:
                            VarRojo := TRUE;
                        "Receta Comentarios"."Format Line"::Strong:
                            VarNegrita := TRUE;
                    END;
                    CASE "Receta Comentarios"."Format Line 2" OF
                        "Receta Comentarios"."Format Line 2"::" ":
                            VarNormal2 := TRUE;
                        "Receta Comentarios"."Format Line 2"::StandardAccent:
                            VarAzul2 := TRUE;
                        "Receta Comentarios"."Format Line 2"::Unfavorable:
                            VarRojo2 := TRUE;
                        "Receta Comentarios"."Format Line 2"::Strong:
                            VarNegrita2 := TRUE;
                    END;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CLEAR(VarQtyCaliente);
                IF VarElaboracionCaliente THEN
                    VarQtyCaliente := Item."Lote Receta" + ((Item."Lote Receta" * Item."Perc. Loss") / 100)
                ELSE
                    VarQtyCaliente := 0;

                ElaborationText := Item.GetElaboration();
                ElaborationText := PrepareHtmlForRdlc(ElaborationText);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(VarMostrarRecursos; VarMostrarRecursos)
                    {
                        ApplicationArea = All;
                        Caption = 'Mostrar Recursos';
                        ToolTip = 'Indica si se desean mostrar los recursos en el informe.';
                    }
                    field(VarElaboracionCaliente; VarElaboracionCaliente)
                    {
                        ApplicationArea = All;
                        Caption = 'Heat creation';
                        ToolTip = 'Indicates whether to show the hot elaboration quantity in the report.';
                    }
                }
            }
        }
        actions
        {
        }
    }
    labels
    {
        LblReferencia = 'Marca / Referencia';
        LblDescripcion = 'Descripción';
        LblCantidad = 'Quantity';
        LblCantidadNet = 'Quantity Net';
        LblCantidadMadre = 'Quantity from Recepy';
        LblUdm = 'Ud.';
        LblCantConsumida = 'Cant. Consumida';
        LblLote = 'Lote';
        lblBase = 'Base Imponible';
        lblIVA = '% IVA';
        lblImporteIVA = 'Importe IVA';
        lblTotalParcial = 'Total Parcial';
        lblSenalizado = 'SEÑALIZADO';
        lblImpSenal = 'Importe Señal';
        lblImpPendiente = 'Importe Pendiente';
        lblHoraEvento = 'Hora Evento';
        lblEMail = 'E-Mail';
        lblContacto = 'Contacto';
        lblDireccionEvento = 'Dirección evento';
        lblCPLocalidad = 'C.P. Localidad';
        lblProvincia = 'Provincia';
        LblPreparados = 'MP Preparados';
        LblConsumidas = 'MP Consumidas';
        LblEstimacion = 'ESTIMACIÓN PRODUCCIÓN';
        LblIngredientes = 'INGREDIENTES';
        LblElaboracion = 'ELABORACIÓN ANTIGUA';
        LblNotas = 'NOTES';
        LblTotalCaliente = 'TOTAL PESO ELABORADO EN CALIENTE (REAL)';
        LblTotalFrio = 'TOTAL PESO ELABORADO EN FRÍO (REAL)';
        LblTotalCalienteEstimado = 'TOTAL PESO ELABORADO EN CALIENTE (ESTIMADO)';
        LblTotalFrioEstimado = 'TOTAL PESO ELABORADO EN FRÍO (ESTIMADO)';
        LblRecursos = 'RECURSOS';
        LblRComsunidas = 'Consumidas';
        LblRNotas = 'Notas';
        LblComents = 'COMENTARIOS';
    }
    trigger OnInitReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CALCFIELDS(Picture);
        VarElaboracionCaliente := TRUE;
    end;

    trigger OnPostReport()
    begin
    end;

    var
        CompanyInfo: Record "Company Information";
        gr_Item: Record Item;
        gb_Sombrear: Boolean;
        VarProductoLM: Boolean;
        VarNormal: Boolean;
        VarNegrita: Boolean;
        VarAzul: Boolean;
        VarRojo: Boolean;
        VarNormal2: Boolean;
        VarNegrita2: Boolean;
        VarAzul2: Boolean;
        VarRojo2: Boolean;
        VarRecursoNegrita: Boolean;
        VarMostrarRecursos: Boolean;
        VarElaboracionCaliente: Boolean;
        varDescripcion: Text[100];
        VarQtyCaliente: Decimal;
        ElaborationText: Text;

    /// <summary>
    /// Prepares the HTML from BC Rich Text Editor (CKEditor 5) for RDLC rendering.
    /// RDLC supports a limited HTML subset (see MS docs: cc645967).
    /// Supported tags: FONT (color/size/face), B, I, U, S, P, DIV, SPAN, H1-H6, A href, OL, UL, LI.
    /// Supported CSS: color (#hex/named), font-family, font-size, font-weight, text-align, padding.
    /// NOT supported: hsl()/rgb()/rgba() colors, background-color, images, tables, emojis.
    /// CKEditor 5 outputs hsl() or rgba() colors in span style attributes which RDLC ignores.
    /// Solution: Convert span color styles to FONT color tags with hex values which RDLC renders.
    /// Reference: bcdevnotebook.com/2023/11/28/bc23-rich-text-content-on-reports/
    /// </summary>
    local procedure PrepareHtmlForRdlc(HtmlText: Text): Text
    var
        Result: Text;
    begin
        Result := HtmlText;

        // Step 1: Convert <span style="color:..."> to <font color="#hex"> tags
        // RDLC explicitly supports <FONT color="..."> for text coloring
        Result := ConvertColorSpansToFontTags(Result);

        // Step 2: Strip <span style="background-color:..."> tags (RDLC cannot render background colors via HTML)
        Result := StripSpansByStylePrefix(Result, '<span style="background-color:');

        // Step 3: Convert any remaining HSL/HSLA color values to hex (fallback for other inline styles)
        Result := ConvertHslColorsToHex(Result);

        // Step 3b: Convert any remaining RGB/RGBA color values to hex
        Result := ConvertRgbColorsToHex(Result);

        // Step 4: Convert CKEditor 5 semantic tags to RDLC-supported equivalents
        Result := Result.Replace('<strong>', '<b>');
        Result := Result.Replace('</strong>', '</b>');
        Result := Result.Replace('<Strong>', '<b>');
        Result := Result.Replace('</Strong>', '</b>');
        Result := Result.Replace('<em>', '<i>');
        Result := Result.Replace('</em>', '</i>');
        Result := Result.Replace('<Em>', '<i>');
        Result := Result.Replace('</Em>', '</i>');

        // Step 5: Remove unsupported container tags
        Result := Result.Replace('<figure>', '');
        Result := Result.Replace('</figure>', '');
        Result := Result.Replace('<figcaption>', '');
        Result := Result.Replace('</figcaption>', '');

        exit(Result);
    end;

    /// <summary>
    /// Converts span color style tags to FONT color tags for RDLC.
    /// CKEditor 5 generates: span style="color:hsl(0, 75%, 60%);" - text - /span
    /// RDLC needs:           font color="#CC4040" - text - /font
    /// </summary>
    local procedure ConvertColorSpansToFontTags(HtmlText: Text): Text
    var
        Result: Text;
        Remaining: Text;
        SearchToken: Text;
        SpanPos: Integer;
        TagEndPos: Integer;
        OpenTag: Text;
        ColorValue: Text;
        HexColor: Text;
        EndSpanPos: Integer;
    begin
        SearchToken := '<span style="color:';
        Remaining := HtmlText;
        Result := '';

        SpanPos := StrPos(LowerCase(Remaining), SearchToken);
        while SpanPos > 0 do begin
            // Append text before the <span
            if SpanPos > 1 then
                Result += CopyStr(Remaining, 1, SpanPos - 1);

            // Start from the <span position
            Remaining := CopyStr(Remaining, SpanPos);

            // Find closing > of the opening span tag
            TagEndPos := StrPos(Remaining, '>');
            if TagEndPos = 0 then begin
                Result += Remaining;
                exit(Result);
            end;

            // Extract the complete opening tag
            OpenTag := CopyStr(Remaining, 1, TagEndPos);

            // Extract the color value from the style attribute
            ColorValue := ExtractColorValueFromTag(OpenTag, StrLen(SearchToken));
            HexColor := ConvertColorValueToHex(ColorValue);

            // Build the <font> replacement tag
            Result += '<font color="' + HexColor + '">';

            // Move past the opening tag
            if TagEndPos < StrLen(Remaining) then
                Remaining := CopyStr(Remaining, TagEndPos + 1)
            else
                Remaining := '';

            // Find the corresponding </span> and replace with </font>
            EndSpanPos := StrPos(LowerCase(Remaining), '</span>');
            if EndSpanPos > 0 then begin
                if EndSpanPos > 1 then
                    Result += CopyStr(Remaining, 1, EndSpanPos - 1);
                Result += '</font>';
                if (EndSpanPos + 7) <= StrLen(Remaining) then
                    Remaining := CopyStr(Remaining, EndSpanPos + 7)
                else
                    Remaining := '';
            end;

            SpanPos := StrPos(LowerCase(Remaining), SearchToken);
        end;

        Result += Remaining;
        exit(Result);
    end;

    /// <summary>
    /// Strips span tags matching a given style prefix, keeping the inner content.
    /// Used to remove background-color spans that RDLC cannot render.
    /// </summary>
    local procedure StripSpansByStylePrefix(HtmlText: Text; StylePrefix: Text): Text
    var
        Result: Text;
        Remaining: Text;
        LowerPrefix: Text;
        SpanPos: Integer;
        TagEndPos: Integer;
        EndSpanPos: Integer;
    begin
        LowerPrefix := LowerCase(StylePrefix);
        Remaining := HtmlText;
        Result := '';

        SpanPos := StrPos(LowerCase(Remaining), LowerPrefix);
        while SpanPos > 0 do begin
            // Append text before the span
            if SpanPos > 1 then
                Result += CopyStr(Remaining, 1, SpanPos - 1);

            Remaining := CopyStr(Remaining, SpanPos);

            // Find closing > of the opening span tag
            TagEndPos := StrPos(Remaining, '>');
            if TagEndPos = 0 then begin
                Result += Remaining;
                exit(Result);
            end;

            // Skip the opening span tag entirely (don't add to result)
            if TagEndPos < StrLen(Remaining) then
                Remaining := CopyStr(Remaining, TagEndPos + 1)
            else
                Remaining := '';

            // Find and skip the closing </span>
            EndSpanPos := StrPos(LowerCase(Remaining), '</span>');
            if EndSpanPos > 0 then begin
                // Keep the content between the tags
                if EndSpanPos > 1 then
                    Result += CopyStr(Remaining, 1, EndSpanPos - 1);
                // Skip </span> (7 chars)
                if (EndSpanPos + 7) <= StrLen(Remaining) then
                    Remaining := CopyStr(Remaining, EndSpanPos + 7)
                else
                    Remaining := '';
            end;

            SpanPos := StrPos(LowerCase(Remaining), LowerPrefix);
        end;

        Result += Remaining;
        exit(Result);
    end;

    /// <summary>
    /// Extracts the color value from an opening span tag.
    /// Given a tag like: span style="color:hsl(0, 75%, 60%);"
    /// With PrefixLen = 19, returns: hsl(0, 75%, 60%)
    /// </summary>
    local procedure ExtractColorValueFromTag(TagText: Text; PrefixLen: Integer): Text
    var
        Content: Text;
        SemiPos: Integer;
        QuotePos: Integer;
        EndPos: Integer;
    begin
        if PrefixLen >= StrLen(TagText) then
            exit('');

        // Content after the prefix (e.g., after '<span style="color:')
        Content := CopyStr(TagText, PrefixLen + 1);

        // Color value ends at ; or " (whichever comes first)
        SemiPos := StrPos(Content, ';');
        QuotePos := StrPos(Content, '"');

        EndPos := 0;
        if SemiPos > 0 then
            EndPos := SemiPos;
        if (QuotePos > 0) and ((EndPos = 0) or (QuotePos < EndPos)) then
            EndPos := QuotePos;

        if EndPos > 1 then
            exit(CopyStr(Content, 1, EndPos - 1).Trim())
        else
            if EndPos = 0 then
                exit(Content.Trim())
            else
                exit('');
    end;

    /// <summary>
    /// Converts a color value to hex format.
    /// Handles: hsl(), hsla(), rgb(), rgba() to #RRGGBB; hex and named colors pass through unchanged.
    /// </summary>
    local procedure ConvertColorValueToHex(ColorValue: Text): Text
    var
        LowerVal: Text;
    begin
        if ColorValue = '' then
            exit('#000000');

        LowerVal := LowerCase(ColorValue);

        // If it's an HSL/HSLA value, convert to hex
        if LowerVal.StartsWith('hsl') then
            exit(ParseHslToHex(ColorValue));

        // If it's an RGB/RGBA value, convert to hex
        if LowerVal.StartsWith('rgb') then
            exit(ParseRgbToHex(ColorValue));

        // Already hex (#RRGGBB) or named color (Red, Blue, etc.) - return as-is
        exit(ColorValue);
    end;

    /// <summary>
    /// Finds all remaining hsl() and hsla() patterns in the HTML and replaces them with #RRGGBB.
    /// This is a fallback for any hsl values not already handled by span-to-font conversion.
    /// </summary>
    local procedure ConvertHslColorsToHex(HtmlText: Text): Text
    var
        InputText: Text;
        ResultText: Text;
        HslPos: Integer;
        ClosePos: Integer;
        HslExpr: Text;
        HexColor: Text;
    begin
        InputText := HtmlText;
        ResultText := '';

        HslPos := FindHslPattern(InputText);
        while HslPos > 0 do begin
            // Append text before hsl(
            if HslPos > 1 then
                ResultText += CopyStr(InputText, 1, HslPos - 1);

            // From the hsl position onwards
            InputText := CopyStr(InputText, HslPos);

            // Find closing parenthesis
            ClosePos := StrPos(InputText, ')');

            if ClosePos = 0 then begin
                ResultText += InputText;
                exit(ResultText);
            end;

            // Extract full hsl(...) or hsla(...) expression
            HslExpr := CopyStr(InputText, 1, ClosePos);
            HexColor := ParseHslToHex(HslExpr);

            if HexColor <> '' then
                ResultText += HexColor
            else
                ResultText += HslExpr;

            // Move past the closing parenthesis
            if ClosePos < StrLen(InputText) then
                InputText := CopyStr(InputText, ClosePos + 1)
            else
                InputText := '';

            HslPos := FindHslPattern(InputText);
        end;

        ResultText += InputText;
        exit(ResultText);
    end;

    /// <summary>
    /// Finds the first occurrence of hsl( or hsla( in the text.
    /// </summary>
    local procedure FindHslPattern(InputText: Text): Integer
    var
        LowerInput: Text;
        Pos1: Integer;
        Pos2: Integer;
    begin
        // Use lowercase to find hsl() regardless of case
        LowerInput := LowerCase(InputText);
        Pos1 := StrPos(LowerInput, 'hsl(');
        Pos2 := StrPos(LowerInput, 'hsla(');

        if (Pos1 = 0) and (Pos2 = 0) then
            exit(0);
        if Pos1 = 0 then
            exit(Pos2);
        if Pos2 = 0 then
            exit(Pos1);
        if Pos1 < Pos2 then
            exit(Pos1)
        else
            exit(Pos2);
    end;

    /// <summary>
    /// Parses an hsl(H, S%, L%) or hsla(H, S%, L%, A) expression and returns the hex color.
    /// </summary>
    local procedure ParseHslToHex(HslExpr: Text): Text
    var
        LowerExpr: Text;
        Content: Text;
        Parts: List of [Text];
        HText: Text;
        SText: Text;
        LText: Text;
        H: Decimal;
        S: Decimal;
        L: Decimal;
    begin
        // Use lowercase for case-insensitive matching
        LowerExpr := LowerCase(HslExpr);

        // Remove function name and parentheses
        if LowerExpr.StartsWith('hsla(') then
            Content := CopyStr(HslExpr, 6)
        else
            if LowerExpr.StartsWith('hsl(') then
                Content := CopyStr(HslExpr, 5)
            else
                exit('');

        // Remove closing parenthesis
        if StrLen(Content) > 0 then
            Content := CopyStr(Content, 1, StrLen(Content) - 1);
        Content := Content.Trim();

        // Split by comma: "H, S%, L%" or "H, S%, L%, A"
        Parts := Content.Split(',');
        if Parts.Count() < 3 then
            exit('');

        Parts.Get(1, HText);
        Parts.Get(2, SText);
        Parts.Get(3, LText);

        // Clean values
        HText := HText.Trim().Replace('deg', '');
        SText := SText.Trim().Replace('%', '');
        LText := LText.Trim().Replace('%', '');

        if not Evaluate(H, HText) then
            exit('');
        if not Evaluate(S, SText) then
            exit('');
        if not Evaluate(L, LText) then
            exit('');

        exit(HslToHexColor(H, S, L));
    end;

    /// <summary>
    /// Converts HSL values (H: 0-360, S: 0-100, L: 0-100) to a hex color string #RRGGBB.
    /// </summary>
    local procedure HslToHexColor(H: Decimal; S: Decimal; L: Decimal): Text
    var
        C: Decimal;
        X: Decimal;
        M: Decimal;
        R1: Decimal;
        G1: Decimal;
        B1: Decimal;
        R: Integer;
        G: Integer;
        B: Integer;
        HPrime: Decimal;
        HMod2: Decimal;
    begin
        // Normalize S and L to 0..1 range
        S := S / 100;
        L := L / 100;

        C := (1 - Abs(2 * L - 1)) * S;
        HPrime := H / 60;
        // Float modulo 2: HPrime mod 2 = HPrime - 2 * floor(HPrime / 2)
        HMod2 := HPrime - 2 * Round(HPrime / 2, 1, '<');
        X := C * (1 - Abs(HMod2 - 1));
        M := L - C / 2;

        if (H >= 0) and (H < 60) then begin
            R1 := C;
            G1 := X;
            B1 := 0;
        end else
            if (H >= 60) and (H < 120) then begin
                R1 := X;
                G1 := C;
                B1 := 0;
            end else
                if (H >= 120) and (H < 180) then begin
                    R1 := 0;
                    G1 := C;
                    B1 := X;
                end else
                    if (H >= 180) and (H < 240) then begin
                        R1 := 0;
                        G1 := X;
                        B1 := C;
                    end else
                        if (H >= 240) and (H < 300) then begin
                            R1 := X;
                            G1 := 0;
                            B1 := C;
                        end else begin
                            R1 := C;
                            G1 := 0;
                            B1 := X;
                        end;

        R := Round((R1 + M) * 255, 1);
        G := Round((G1 + M) * 255, 1);
        B := Round((B1 + M) * 255, 1);

        // Clamp to valid range
        if R > 255 then R := 255;
        if R < 0 then R := 0;
        if G > 255 then G := 255;
        if G < 0 then G := 0;
        if B > 255 then B := 255;
        if B < 0 then B := 0;

        exit('#' + IntToHex2(R) + IntToHex2(G) + IntToHex2(B));
    end;

    /// <summary>
    /// Parses rgb(R, G, B) or rgba(R, G, B, A) expression and returns the hex color.
    /// RGB values are integers 0-255. Alpha channel is ignored.
    /// CKEditor 5 in some BC versions outputs rgba() instead of hsl().
    /// </summary>
    local procedure ParseRgbToHex(RgbExpr: Text): Text
    var
        LowerExpr: Text;
        Content: Text;
        Parts: List of [Text];
        RText: Text;
        GText: Text;
        BText: Text;
        R: Integer;
        G: Integer;
        B: Integer;
    begin
        LowerExpr := LowerCase(RgbExpr);

        // Remove function name and parentheses
        if LowerExpr.StartsWith('rgba(') then
            Content := CopyStr(RgbExpr, 6)
        else
            if LowerExpr.StartsWith('rgb(') then
                Content := CopyStr(RgbExpr, 5)
            else
                exit('');

        // Remove closing parenthesis
        if StrLen(Content) > 0 then
            Content := CopyStr(Content, 1, StrLen(Content) - 1);
        Content := Content.Trim();

        // Split by comma: "R, G, B" or "R, G, B, A"
        Parts := Content.Split(',');
        if Parts.Count() < 3 then
            exit('');

        Parts.Get(1, RText);
        Parts.Get(2, GText);
        Parts.Get(3, BText);

        RText := RText.Trim();
        GText := GText.Trim();
        BText := BText.Trim();

        if not Evaluate(R, RText) then
            exit('');
        if not Evaluate(G, GText) then
            exit('');
        if not Evaluate(B, BText) then
            exit('');

        // Clamp to valid range
        if R > 255 then R := 255;
        if R < 0 then R := 0;
        if G > 255 then G := 255;
        if G < 0 then G := 0;
        if B > 255 then B := 255;
        if B < 0 then B := 0;

        exit('#' + IntToHex2(R) + IntToHex2(G) + IntToHex2(B));
    end;

    /// <summary>
    /// Finds all remaining rgb() and rgba() patterns in the HTML and replaces them with #RRGGBB.
    /// This is a fallback for any rgb values not already handled by span-to-font conversion.
    /// </summary>
    local procedure ConvertRgbColorsToHex(HtmlText: Text): Text
    var
        InputText: Text;
        ResultText: Text;
        RgbPos: Integer;
        ClosePos: Integer;
        RgbExpr: Text;
        HexColor: Text;
    begin
        InputText := HtmlText;
        ResultText := '';

        RgbPos := FindRgbPattern(InputText);
        while RgbPos > 0 do begin
            // Append text before rgb(
            if RgbPos > 1 then
                ResultText += CopyStr(InputText, 1, RgbPos - 1);

            // From the rgb position onwards
            InputText := CopyStr(InputText, RgbPos);

            // Find closing parenthesis
            ClosePos := StrPos(InputText, ')');

            if ClosePos = 0 then begin
                ResultText += InputText;
                exit(ResultText);
            end;

            // Extract full rgb(...) or rgba(...) expression
            RgbExpr := CopyStr(InputText, 1, ClosePos);
            HexColor := ParseRgbToHex(RgbExpr);

            if HexColor <> '' then
                ResultText += HexColor
            else
                ResultText += RgbExpr;

            // Move past the closing parenthesis
            if ClosePos < StrLen(InputText) then
                InputText := CopyStr(InputText, ClosePos + 1)
            else
                InputText := '';

            RgbPos := FindRgbPattern(InputText);
        end;

        ResultText += InputText;
        exit(ResultText);
    end;

    /// <summary>
    /// Finds the first occurrence of rgb( or rgba( in the text.
    /// </summary>
    local procedure FindRgbPattern(InputText: Text): Integer
    var
        LowerInput: Text;
        Pos1: Integer;
        Pos2: Integer;
    begin
        LowerInput := LowerCase(InputText);
        Pos1 := StrPos(LowerInput, 'rgb(');
        Pos2 := StrPos(LowerInput, 'rgba(');

        if (Pos1 = 0) and (Pos2 = 0) then
            exit(0);
        if Pos1 = 0 then
            exit(Pos2);
        if Pos2 = 0 then
            exit(Pos1);
        if Pos1 < Pos2 then
            exit(Pos1)
        else
            exit(Pos2);
    end;

    /// <summary>
    /// Converts an integer (0-255) to a two-character uppercase hex string.
    /// </summary>
    local procedure IntToHex2(Value: Integer): Text
    var
        HexChars: Text;
    begin
        HexChars := '0123456789ABCDEF';
        exit(CopyStr(HexChars, (Value div 16) + 1, 1) + CopyStr(HexChars, (Value mod 16) + 1, 1));
    end;
}
