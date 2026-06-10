report 60006 "CP Production Part"
{
    // #9969 - Se crea el report nuevo
    DefaultLayout = RDLC;
    RDLCLayout = './src/report/layout/ProductionPart.rdl';
    WordMergeDataItem = "Assembly Header";
    Caption = 'Production Part';

    dataset
    {
        dataitem("Assembly Header"; 900)
        {
            column(VarMostrarRecursos; VarMostrarRecursos)
            {
            }
            column(PaymentTermsDescription; PaymentTerms.Description)
            {
            }
            column(PaymentMethodDescription; PaymentMethod.Description)
            {
            }
            column(PmtTermsDescCaption; PmtTermsDescCaptionLbl)
            {
            }
            column(PmtMethodDescCaption; PmtMethodDescCaptionLbl)
            {
            }
            column(HomePageCaption; HomePageCaptionCap)
            {
            }
            column(DocumentType_AssemblyHeader; "Assembly Header"."Document Type")
            {
            }
            column(No_AssemblyHeader; "Assembly Header"."No.")
            {
            }
            column(Description_AssemblyHeader; "Assembly Header".Description)
            {
            }
            column(SearchDescription_AssemblyHeader; "Assembly Header"."Search Description")
            {
            }
            column(Description2_AssemblyHeader; "Assembly Header"."Description 2")
            {
            }
            column(CreationDate_AssemblyHeader; "Assembly Header"."Creation Date")
            {
            }
            column(LastDateModified_AssemblyHeader; "Assembly Header"."Last Date Modified")
            {
            }
            column(ItemNo_AssemblyHeader; "Assembly Header"."Item No.")
            {
            }
            column(VariantCode_AssemblyHeader; "Assembly Header"."Variant Code")
            {
            }
            column(InventoryPostingGroup_AssemblyHeader; "Assembly Header"."Inventory Posting Group")
            {
            }
            column(GenProdPostingGroup_AssemblyHeader; "Assembly Header"."Gen. Prod. Posting Group")
            {
            }
            column(Comment_AssemblyHeader; "Assembly Header".Comment)
            {
            }
            column(LocationCode_AssemblyHeader; "Assembly Header"."Location Code")
            {
            }
            column(ShortcutDimension1Code_AssemblyHeader; "Assembly Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_AssemblyHeader; "Assembly Header"."Shortcut Dimension 2 Code")
            {
            }
            column(PostingDate_AssemblyHeader; "Assembly Header"."Posting Date")
            {
            }
            column(DueDate_AssemblyHeader; "Assembly Header"."Due Date")
            {
            }
            column(StartingDate_AssemblyHeader; "Assembly Header"."Starting Date")
            {
            }
            column(EndingDate_AssemblyHeader; "Assembly Header"."Ending Date")
            {
            }
            column(BinCode_AssemblyHeader; "Assembly Header"."Bin Code")
            {
            }
            column(Quantity_AssemblyHeader; "Assembly Header".Quantity)
            {
            }
            column(QuantityBase_AssemblyHeader; "Assembly Header"."Quantity (Base)")
            {
            }
            column(QuantityCaliente_AssemblyHeader; VarQtyCaliente)
            {
            }
            column(PercLoss_AssemblyHeader; "Assembly Header"."Perc. Loss")
            {
            }
            column(NetAmount_AssemblyHeader; "Assembly Header"."Net Amount")
            {
            }
            column(RemainingQuantity_AssemblyHeader; "Assembly Header"."Remaining Quantity")
            {
            }
            column(RemainingQuantityBase_AssemblyHeader; "Assembly Header"."Remaining Quantity (Base)")
            {
            }
            column(AssembledQuantity_AssemblyHeader; "Assembly Header"."Assembled Quantity")
            {
            }
            column(AssembledQuantityBase_AssemblyHeader; "Assembly Header"."Assembled Quantity (Base)")
            {
            }
            column(QuantitytoAssemble_AssemblyHeader; "Assembly Header"."Quantity to Assemble")
            {
            }
            column(QuantitytoAssembleBase_AssemblyHeader; "Assembly Header"."Quantity to Assemble (Base)")
            {
            }
            column(ReservedQuantity_AssemblyHeader; "Assembly Header"."Reserved Quantity")
            {
            }
            column(ReservedQtyBase_AssemblyHeader; "Assembly Header"."Reserved Qty. (Base)")
            {
            }
            column(PlanningFlexibility_AssemblyHeader; "Assembly Header"."Planning Flexibility")
            {
            }
            column(MPSOrder_AssemblyHeader; "Assembly Header"."MPS Order")
            {
            }
            column(AssembletoOrder_AssemblyHeader; "Assembly Header"."Assemble to Order")
            {
            }
            column(PostingNo_AssemblyHeader; "Assembly Header"."Posting No.")
            {
            }
            column(UnitCost_AssemblyHeader; "Assembly Header"."Unit Cost")
            {
            }
            column(CostAmount_AssemblyHeader; "Assembly Header"."Cost Amount")
            {
            }
            column(RolledupAssemblyCost_AssemblyHeader; "Assembly Header"."Rolled-up Assembly Cost")
            {
            }
            column(IndirectCost_AssemblyHeader; "Assembly Header"."Indirect Cost %")
            {
            }
            column(OverheadRate_AssemblyHeader; "Assembly Header"."Overhead Rate")
            {
            }
            column(UnitofMeasureCode_AssemblyHeader; "Assembly Header"."Unit of Measure Code")
            {
            }
            column(QtyperUnitofMeasure_AssemblyHeader; "Assembly Header"."Qty. per Unit of Measure")
            {
            }
            column(NoSeries_AssemblyHeader; "Assembly Header"."No. Series")
            {
            }
            column(PostingNoSeries_AssemblyHeader; "Assembly Header"."Posting No. Series")
            {
            }
            column(Status_AssemblyHeader; "Assembly Header".Status)
            {
            }
            column(DimensionSetID_AssemblyHeader; "Assembly Header"."Dimension Set ID")
            {
            }
            column(AssignedUserID_AssemblyHeader; "Assembly Header"."Assigned User ID")
            {
            }
            column(NoEvento_AssemblyHeader; "Assembly Header".NoEvento)
            {
            }
            column(Autoconsumo_AssemblyHeader; "Assembly Header".Autoconsumo)
            {
            }
            column(Simulacion_AssemblyHeader; "Assembly Header".Simulacion)
            {
            }
            column(LotQuantity_AssemblyHeader; "Assembly Header"."Lot Quantity")
            {
            }
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(imagenproducto; gt_producto.Picture)
            {
            }
            column(OutputNo; OutputNo)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
            {
            }
#pragma warning disable AL0432
            column(CompanyInfoHomePage; CompanyInfo."Home Page")
            {
            }
#pragma warning restore AL0432
            column(CompanyInfoEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoFaxNo; CompanyInfo."Fax No.")
            {
            }
            column(PageCaption; PageCaptionCap)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(VATRegNoCaption; VATRegNoCaptionLbl)
            {
            }
            column(FaxNoCaption; FaxNoCaptionLbl)
            {
            }
            column(Listado_Titulo; TituloReport)
            {
            }
            column(AGRALAObservaciones; "Assembly Header".AGRALAObservaciones)
            {
            }
            column("AGRALAFechaProducción"; "Assembly Header".AGRALAFechaProduccion)
            {
            }
            dataitem("Assembly Line"; 901)
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemLinkReference = "Assembly Header";
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = CONST(Item));

                column(DocumentType_AssemblyLine; "Assembly Line"."Document Type")
                {
                }
                column(DocumentNo_AssemblyLine; "Assembly Line"."Document No.")
                {
                }
                column(LineNo_AssemblyLine; "Assembly Line"."Line No.")
                {
                }
                column(Type_AssemblyLine; "Assembly Line".Type)
                {
                }
                column(No_AssemblyLine; "Assembly Line"."No.")
                {
                }
                column(VariantCode_AssemblyLine; "Assembly Line"."Variant Code")
                {
                }
                column(Description_AssemblyLine; "Assembly Line".Description)
                {
                }
                column(Description2_AssemblyLine; "Assembly Line"."Description 2")
                {
                }
                column(LeadTimeOffset_AssemblyLine; "Assembly Line"."Lead-Time Offset")
                {
                }
                column(ResourceUsageType_AssemblyLine; "Assembly Line"."Resource Usage Type")
                {
                }
                column(LocationCode_AssemblyLine; "Assembly Line"."Location Code")
                {
                }
                column(ShortcutDimension1Code_AssemblyLine; "Assembly Line"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_AssemblyLine; "Assembly Line"."Shortcut Dimension 2 Code")
                {
                }
                column(BinCode_AssemblyLine; "Assembly Line"."Bin Code")
                {
                }
                column(Position_AssemblyLine; "Assembly Line".Position)
                {
                }
                column(Position2_AssemblyLine; "Assembly Line"."Position 2")
                {
                }
                column(Position3_AssemblyLine; "Assembly Line"."Position 3")
                {
                }
                column(AppltoItemEntry_AssemblyLine; "Assembly Line"."Appl.-to Item Entry")
                {
                }
                column(ApplfromItemEntry_AssemblyLine; "Assembly Line"."Appl.-from Item Entry")
                {
                }
                column(Quantity_AssemblyLine; "Assembly Line".Quantity)
                {
                }
                column(QuantityBase_AssemblyLine; "Assembly Line"."Quantity (Base)")
                {
                }
                column(PercLoss_AssemblyLine; "Assembly Line"."Perc. Loss")
                {
                }
                column(NetAmount_AssemblyLine; "Assembly Line"."Net Amount")
                {
                }
                column(RemainingQuantity_AssemblyLine; "Assembly Line"."Remaining Quantity")
                {
                }
                column(RemainingQuantityBase_AssemblyLine; "Assembly Line"."Remaining Quantity (Base)")
                {
                }
                column(ConsumedQuantity_AssemblyLine; "Assembly Line"."Consumed Quantity")
                {
                }
                column(ConsumedQuantityBase_AssemblyLine; "Assembly Line"."Consumed Quantity (Base)")
                {
                }
                column(QuantitytoConsume_AssemblyLine; "Assembly Line"."Quantity to Consume")
                {
                }
                column(QuantitytoConsumeBase_AssemblyLine; "Assembly Line"."Quantity to Consume (Base)")
                {
                }
                column(ReservedQuantity_AssemblyLine; "Assembly Line"."Reserved Quantity")
                {
                }
                column(ReservedQtyBase_AssemblyLine; "Assembly Line"."Reserved Qty. (Base)")
                {
                }
                column(AvailWarning_AssemblyLine; "Assembly Line"."Avail. Warning")
                {
                }
                column(SubstitutionAvailable_AssemblyLine; "Assembly Line"."Substitution Available")
                {
                }
                column(DueDate_AssemblyLine; "Assembly Line"."Due Date")
                {
                }
                column(Reserve_AssemblyLine; "Assembly Line".Reserve)
                {
                }
                column(Quantityper_AssemblyLine; "Assembly Line"."Quantity per")
                {
                }
                column(QtyperUnitofMeasure_AssemblyLine; "Assembly Line"."Qty. per Unit of Measure")
                {
                }
                column(InventoryPostingGroup_AssemblyLine; "Assembly Line"."Inventory Posting Group")
                {
                }
                column(GenProdPostingGroup_AssemblyLine; "Assembly Line"."Gen. Prod. Posting Group")
                {
                }
                column(UnitCost_AssemblyLine; "Assembly Line"."Unit Cost")
                {
                }
                column(CostAmount_AssemblyLine; "Assembly Line"."Cost Amount")
                {
                }
                column(DateFilter_AssemblyLine; "Assembly Line"."Date Filter")
                {
                }
                column(UnitofMeasureCode_AssemblyLine; "Assembly Line"."Unit of Measure Code")
                {
                }
                column(DimensionSetID_AssemblyLine; "Assembly Line"."Dimension Set ID")
                {
                }
                column(PickQty_AssemblyLine; "Assembly Line"."Pick Qty.")
                {
                }
                column(PickQtyBase_AssemblyLine; "Assembly Line"."Pick Qty. (Base)")
                {
                }
                column(QtyPicked_AssemblyLine; "Assembly Line"."Qty. Picked")
                {
                }
                column(QtyPickedBase_AssemblyLine; "Assembly Line"."Qty. Picked (Base)")
                {
                }
                column(CantidadporLote_AssemblyLine; "Assembly Line"."Cantidad por Lote")
                {
                }
                column(Sombrear; gb_Sombrear)
                {
                }
                column(comentario; "Assembly Line".Comentario)
                {
                }
                column(VarProductoLM; VarProductoLM)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    gb_Sombrear := TRUE;
                    CLEAR(VarProductoLM);
                    CASE "Assembly Line".Type OF
                        "Assembly Line".Type::Item:
                            BEGIN
                                gr_Item.RESET;
                                gr_Item.SETRANGE("No.", "Assembly Line"."No.");
                                IF gr_Item.FINDFIRST THEN BEGIN
                                    gr_Item.CALCFIELDS("Assembly BOM");
                                    gb_Sombrear := gr_Item."Item Tracking Code" = '';
                                    VarProductoLM := gr_Item."Assembly BOM";
                                END;
                            END;
                    END;
                end;

                trigger OnPreDataItem()
                var
                    lt_VATPostingSetup: Record 325;
                    GLAccount: Record 15;
                    GrupoRegIVANeg: Code[20];
                    lt_Customer: Record 18;
                    lt_CustTemplate: Record "Customer Templ.";
                begin
                    /*  IF gt_producto.GET("Assembly Header"."Item No.") THEN
                             if gt_producto.Picture.Count <> 0 then
                                 gt_producto.CALCFIELDS(Picture); */
                end;
            }
            dataitem("Assembly Line Resource"; 901)
            {
                DataItemLink = "Document Type" = FIELD("Document Type"), "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.") WHERE(Type = FILTER(<> Item));

                column(DocumentType_AssemblyLineResource; "Assembly Line Resource"."Document Type")
                {
                }
                column(DocumentNo_AssemblyLineResource; "Assembly Line Resource"."Document No.")
                {
                }
                column(LineNo_AssemblyLineResource; "Assembly Line Resource"."Line No.")
                {
                }
                column(Type_AssemblyLineResource; "Assembly Line Resource".Type)
                {
                }
                column(No_AssemblyLineResource; "Assembly Line Resource"."No.")
                {
                }
                column(VariantCode_AssemblyLineResource; "Assembly Line Resource"."Variant Code")
                {
                }
                column(Description_AssemblyLineResource; "Assembly Line Resource".Description)
                {
                }
                column(Description2_AssemblyLineResource; "Assembly Line Resource"."Description 2")
                {
                }
                column(LeadTimeOffset_AssemblyLineResource; "Assembly Line Resource"."Lead-Time Offset")
                {
                }
                column(ResourceUsageType_AssemblyLineResource; "Assembly Line Resource"."Resource Usage Type")
                {
                }
                column(LocationCode_AssemblyLineResource; "Assembly Line Resource"."Location Code")
                {
                }
                column(ShortcutDimension1Code_AssemblyLineResource; "Assembly Line Resource"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_AssemblyLineResource; "Assembly Line Resource"."Shortcut Dimension 2 Code")
                {
                }
                column(BinCode_AssemblyLineResource; "Assembly Line Resource"."Bin Code")
                {
                }
                column(Position_AssemblyLineResource; "Assembly Line Resource".Position)
                {
                }
                column(Position2_AssemblyLineResource; "Assembly Line Resource"."Position 2")
                {
                }
                column(Position3_AssemblyLineResource; "Assembly Line Resource"."Position 3")
                {
                }
                column(AppltoItemEntry_AssemblyLineResource; "Assembly Line Resource"."Appl.-to Item Entry")
                {
                }
                column(ApplfromItemEntry_AssemblyLineResource; "Assembly Line Resource"."Appl.-from Item Entry")
                {
                }
                column(Quantity_AssemblyLineResource; "Assembly Line Resource".Quantity)
                {
                }
                column(QuantityBase_AssemblyLineResource; "Assembly Line Resource"."Quantity (Base)")
                {
                }
                column(RemainingQuantity_AssemblyLineResource; "Assembly Line Resource"."Remaining Quantity")
                {
                }
                column(RemainingQuantityBase_AssemblyLineResource; "Assembly Line Resource"."Remaining Quantity (Base)")
                {
                }
                column(ConsumedQuantity_AssemblyLineResource; "Assembly Line Resource"."Consumed Quantity")
                {
                }
                column(ConsumedQuantityBase_AssemblyLineResource; "Assembly Line Resource"."Consumed Quantity (Base)")
                {
                }
                column(QuantitytoConsume_AssemblyLineResource; "Assembly Line Resource"."Quantity to Consume")
                {
                }
                column(QuantitytoConsumeBase_AssemblyLineResource; "Assembly Line Resource"."Quantity to Consume (Base)")
                {
                }
                column(ReservedQuantity_AssemblyLineResource; "Assembly Line Resource"."Reserved Quantity")
                {
                }
                column(ReservedQtyBase_AssemblyLineResource; "Assembly Line Resource"."Reserved Qty. (Base)")
                {
                }
                column(AvailWarning_AssemblyLineResource; "Assembly Line Resource"."Avail. Warning")
                {
                }
                column(SubstitutionAvailable_AssemblyLineResource; "Assembly Line Resource"."Substitution Available")
                {
                }
                column(DueDate_AssemblyLineResource; "Assembly Line Resource"."Due Date")
                {
                }
                column(Reserve_AssemblyLineResource; "Assembly Line Resource".Reserve)
                {
                }
                column(Quantityper_AssemblyLineResource; "Assembly Line Resource"."Quantity per")
                {
                }
                column(QtyperUnitofMeasure_AssemblyLineResource; "Assembly Line Resource"."Qty. per Unit of Measure")
                {
                }
                column(InventoryPostingGroup_AssemblyLineResource; "Assembly Line Resource"."Inventory Posting Group")
                {
                }
                column(GenProdPostingGroup_AssemblyLineResource; "Assembly Line Resource"."Gen. Prod. Posting Group")
                {
                }
                column(UnitCost_AssemblyLineResource; "Assembly Line Resource"."Unit Cost")
                {
                }
                column(CostAmount_AssemblyLineResource; "Assembly Line Resource"."Cost Amount")
                {
                }
                column(DateFilter_AssemblyLineResource; "Assembly Line Resource"."Date Filter")
                {
                }
                column(UnitofMeasureCode_AssemblyLineResource; "Assembly Line Resource"."Unit of Measure Code")
                {
                }
                column(DimensionSetID_AssemblyLineResource; "Assembly Line Resource"."Dimension Set ID")
                {
                }
                column(PickQty_AssemblyLineResource; "Assembly Line Resource"."Pick Qty.")
                {
                }
                column(PickQtyBase_AssemblyLineResource; "Assembly Line Resource"."Pick Qty. (Base)")
                {
                }
                column(QtyPicked_AssemblyLineResource; "Assembly Line Resource"."Qty. Picked")
                {
                }
                column(QtyPickedBase_AssemblyLineResource; "Assembly Line Resource"."Qty. Picked (Base)")
                {
                }
                column(Comentario_AssemblyLineResource; "Assembly Line Resource".Comentario)
                {
                }
                column(CantidadEscalado_AssemblyLineResource; "Assembly Line Resource".CantidadEscalado)
                {
                }
                column(CodProveedor_AssemblyLineResource; "Assembly Line Resource"."Cod Proveedor")
                {
                }
                column(NombreProveedor_AssemblyLineResource; "Assembly Line Resource"."Nombre Proveedor")
                {
                }
                column(RelatedWorkCenter_AssemblyLineResource; "Assembly Line Resource"."Related Work Center")
                {
                }
                column(PercLoss_AssemblyLineResource; "Assembly Line Resource"."Perc. Loss")
                {
                }
                column(NetAmount_AssemblyLineResource; "Assembly Line Resource"."Net Amount")
                {
                }
                column(CantidadOriginal_AssemblyLineResource; "Assembly Line Resource"."Cantidad Original")
                {
                }
                column(CantidadPorOriginal_AssemblyLineResource; "Assembly Line Resource"."Cantidad Por Original")
                {
                }
                column(Diferencia_AssemblyLineResource; "Assembly Line Resource".Diferencia)
                {
                }
                column(StandardCost_AssemblyLineResource; "Assembly Line Resource"."Standard Cost")
                {
                }
                column(CostStdAmount_AssemblyLineResource; "Assembly Line Resource"."Cost Std Amount")
                {
                }
                column(CantidadporLote_AssemblyLineResource; "Assembly Line Resource"."Cantidad por Lote")
                {
                }
                column(VarRecursoNegrita; VarRecursoNegrita)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    CLEAR(VarRecursoNegrita);
                    IF ("Assembly Line Resource".Type = "Assembly Line Resource".Type::" ") AND ("Assembly Line Resource"."Related Work Center" <> '') THEN VarRecursoNegrita := TRUE;
                end;
            }
            dataitem("Receta Comentarios"; 50009)
            {
                DataItemLink = "No." = FIELD("Item No.");
                DataItemTableView = SORTING("Table Name", "No.", "Line No.") WHERE("Table Name" = CONST(Receta));

                column(TableName_RecetaComentarios; "Receta Comentarios"."Table Name")
                {
                }
                column(No_RecetaComentarios; "Receta Comentarios"."No.")
                {
                }
                column(LineNo_RecetaComentarios; "Receta Comentarios"."Line No.")
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
            dataitem(ItemData; 27)
            {
                DataItemLink = "No." = FIELD("Item No.");
                DataItemLinkReference = "Assembly Header";

                column(Elaboration_Item; VarElaboration)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ElaborationInStream: InStream;
                begin
                    CLEAR(VarElaboration);
                    ItemData.CalcFields("Elaboration");
                    IF ItemData."Elaboration".HasValue() THEN BEGIN
                        ItemData."Elaboration".CreateInStream(ElaborationInStream, TextEncoding::UTF8);
                        ElaborationInStream.Read(VarElaboration);
                        VarElaboration := PrepareHtmlForRdlc(VarElaboration);
                    END;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                CLEAR(VarQtyCaliente);
                IF VarElaboracionCaliente THEN
                    VarQtyCaliente := "Assembly Header".Quantity + (("Assembly Header".Quantity * "Assembly Header"."Perc. Loss") / 100)
                ELSE
                    VarQtyCaliente := 0;
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

                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = All;
                        Caption = 'No. of Copies';
                        Visible = false;
                    }
                    field(gb_MostrarComentarios; gb_MostrarComentarios)
                    {
                        ApplicationArea = All;
                        Caption = 'Mostrar comentarios';
                        Visible = false;
                    }
                    field(VarMostrarRecursos; VarMostrarRecursos)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Recursos';
                    }
                    field(VarElaboracionCaliente; VarElaboracionCaliente)
                    {
                        ApplicationArea = All;
                        Caption = 'Heat creation';
                    }
                }
            }
        }
        actions
        {
        }
        trigger OnOpenPage()
        begin
            gb_MostrarComentarios := TRUE;
        end;
    }
    labels
    {
        LblReferencia = 'Marca / Referencia';
        LblDescripcion = 'Descripción';
        LblCantidad = 'Cantidad bruta';
        LblCantidadNet = 'Cantidad Neto';
        LblCantidadMadre = 'Cantidad Madre';
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
        LblElaboracion = 'ELABORACIÓN';
        LblNotas = 'NOTES';
        LblTotalCaliente = 'TOTAL PESO ELABORADO EN CALIENTE (REAL)';
        LblTotalFrio = 'TOTAL PESO ELABORADO EN FRÍO (REAL)';
        LblTotalCalienteEstimado = 'TOTAL PESO FINAL (ESTIMADO)';
        LblTotalFrioEstimado = 'TOTAL PESO FINAL (REAL)';
        LblRecursos = 'RECURSOS';
        LblRComsunidas = 'Consumidas';
        LblRNotas = 'Notas';
        LblComents = 'COMMENTARIOS';
    }
    trigger OnInitReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        VarElaboracionCaliente := TRUE;
    end;

    var
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        Text003: Label 'COPY';
        PageCaptionCap: Label 'Page %1 of %2';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        HomePageCaptionCap: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        PaymentMethod: Record 289;
        PaymentTerms: Record 3;
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text[50];
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        PmtMethodDescCaptionLbl: Label 'Payment Method';
        LineasEventoTMP: Record 50002 temporary;
        LineEventoNo: Integer;
        FaxNoCaptionLbl: Label 'Phone No.';
        TituloReport: Text[100];
        PresupuestoCaptionLbl: Label 'Presupuesto';
        PedidoCaptionLbl: Label 'Pedido';
        NoClienteCaptionLbl: Label 'Nº cliente';
        NoContactoCaptionLbl: Label 'Nº contacto';
        FechaEventoCaptionLbl: Label 'Fecha evento';
        NoEventoCaptionLbl: Label 'Nº evento';
        FechaAltaCaptionLbl: Label 'Fecha alta';
#pragma warning disable AL0432
        VATAmountLineTMP: Record 290 temporary;
#pragma warning restore AL0432
        TxtTotal: Text[200];
        TotalCaptionlbl: Label 'Total';
        SalesReceivablesSetup: Record 311;
        GLSetup: Record 98;
        gb_Pedido: Boolean;
        gb_MostrarComentarios: Boolean;
        txtComentarioEvento: Text[550];
        gr_Item: Record 27;
        gb_Sombrear: Boolean;
        gt_producto: Record 27;
        VarProductoLM: Boolean;
        VarNormal: Boolean;
        VarNegrita: Boolean;
        VarAzul: Boolean;
        VarRojo: Boolean;
        VarNormal2: Boolean;
        VarNegrita2: Boolean;
        VarAzul2: Boolean;
        VarRojo2: Boolean;
        VarMostrarRecursos: Boolean;
        VarRecursoNegrita: Boolean;
        VarElaboracionCaliente: Boolean;
        VarQtyCaliente: Decimal;
        VarElaboration: Text;

    local procedure PrepareHtmlForRdlc(HtmlText: Text): Text
    var
        Result: Text;
    begin
        Result := HtmlText;

        // Step 1: Convert <span style="color:..."> to <font color="#hex"> tags
        Result := ConvertColorSpansToFontTags(Result);

        // Step 2: Strip <span style="background-color:..."> tags
        Result := StripSpansByStylePrefix(Result, '<span style="background-color:');

        // Step 3: Convert any remaining HSL/HSLA color values to hex
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
            if SpanPos > 1 then
                Result += CopyStr(Remaining, 1, SpanPos - 1);

            Remaining := CopyStr(Remaining, SpanPos);

            TagEndPos := StrPos(Remaining, '>');
            if TagEndPos = 0 then begin
                Result += Remaining;
                exit(Result);
            end;

            OpenTag := CopyStr(Remaining, 1, TagEndPos);
            ColorValue := ExtractColorValueFromTag(OpenTag, StrLen(SearchToken));
            HexColor := ConvertColorValueToHex(ColorValue);

            Result += '<font color="' + HexColor + '">';

            if TagEndPos < StrLen(Remaining) then
                Remaining := CopyStr(Remaining, TagEndPos + 1)
            else
                Remaining := '';

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
            if SpanPos > 1 then
                Result += CopyStr(Remaining, 1, SpanPos - 1);

            Remaining := CopyStr(Remaining, SpanPos);

            TagEndPos := StrPos(Remaining, '>');
            if TagEndPos = 0 then begin
                Result += Remaining;
                exit(Result);
            end;

            if TagEndPos < StrLen(Remaining) then
                Remaining := CopyStr(Remaining, TagEndPos + 1)
            else
                Remaining := '';

            EndSpanPos := StrPos(LowerCase(Remaining), '</span>');
            if EndSpanPos > 0 then begin
                if EndSpanPos > 1 then
                    Result += CopyStr(Remaining, 1, EndSpanPos - 1);
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

    local procedure ExtractColorValueFromTag(TagText: Text; PrefixLen: Integer): Text
    var
        Content: Text;
        SemiPos: Integer;
        QuotePos: Integer;
        EndPos: Integer;
    begin
        if PrefixLen >= StrLen(TagText) then
            exit('');

        Content := CopyStr(TagText, PrefixLen + 1);

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

    local procedure ConvertColorValueToHex(ColorValue: Text): Text
    var
        LowerVal: Text;
    begin
        if ColorValue = '' then
            exit('#000000');

        LowerVal := LowerCase(ColorValue);

        if LowerVal.StartsWith('hsl') then
            exit(ParseHslToHex(ColorValue));

        if LowerVal.StartsWith('rgb') then
            exit(ParseRgbToHex(ColorValue));

        exit(ColorValue);
    end;

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
            if HslPos > 1 then
                ResultText += CopyStr(InputText, 1, HslPos - 1);

            InputText := CopyStr(InputText, HslPos);

            ClosePos := StrPos(InputText, ')');

            if ClosePos = 0 then begin
                ResultText += InputText;
                exit(ResultText);
            end;

            HslExpr := CopyStr(InputText, 1, ClosePos);
            HexColor := ParseHslToHex(HslExpr);

            if HexColor <> '' then
                ResultText += HexColor
            else
                ResultText += HslExpr;

            if ClosePos < StrLen(InputText) then
                InputText := CopyStr(InputText, ClosePos + 1)
            else
                InputText := '';

            HslPos := FindHslPattern(InputText);
        end;

        ResultText += InputText;
        exit(ResultText);
    end;

    local procedure FindHslPattern(InputText: Text): Integer
    var
        LowerInput: Text;
        Pos1: Integer;
        Pos2: Integer;
    begin
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
        LowerExpr := LowerCase(HslExpr);

        if LowerExpr.StartsWith('hsla(') then
            Content := CopyStr(HslExpr, 6)
        else
            if LowerExpr.StartsWith('hsl(') then
                Content := CopyStr(HslExpr, 5)
            else
                exit('');

        if StrLen(Content) > 0 then
            Content := CopyStr(Content, 1, StrLen(Content) - 1);
        Content := Content.Trim();

        Parts := Content.Split(',');
        if Parts.Count() < 3 then
            exit('');

        Parts.Get(1, HText);
        Parts.Get(2, SText);
        Parts.Get(3, LText);

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
        S := S / 100;
        L := L / 100;

        C := (1 - Abs(2 * L - 1)) * S;
        HPrime := H / 60;
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

        if R > 255 then R := 255;
        if R < 0 then R := 0;
        if G > 255 then G := 255;
        if G < 0 then G := 0;
        if B > 255 then B := 255;
        if B < 0 then B := 0;

        exit('#' + IntToHex2(R) + IntToHex2(G) + IntToHex2(B));
    end;

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

        if LowerExpr.StartsWith('rgba(') then
            Content := CopyStr(RgbExpr, 6)
        else
            if LowerExpr.StartsWith('rgb(') then
                Content := CopyStr(RgbExpr, 5)
            else
                exit('');

        if StrLen(Content) > 0 then
            Content := CopyStr(Content, 1, StrLen(Content) - 1);
        Content := Content.Trim();

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

        if R > 255 then R := 255;
        if R < 0 then R := 0;
        if G > 255 then G := 255;
        if G < 0 then G := 0;
        if B > 255 then B := 255;
        if B < 0 then B := 0;

        exit('#' + IntToHex2(R) + IntToHex2(G) + IntToHex2(B));
    end;

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
            if RgbPos > 1 then
                ResultText += CopyStr(InputText, 1, RgbPos - 1);

            InputText := CopyStr(InputText, RgbPos);

            ClosePos := StrPos(InputText, ')');

            if ClosePos = 0 then begin
                ResultText += InputText;
                exit(ResultText);
            end;

            RgbExpr := CopyStr(InputText, 1, ClosePos);
            HexColor := ParseRgbToHex(RgbExpr);

            if HexColor <> '' then
                ResultText += HexColor
            else
                ResultText += RgbExpr;

            if ClosePos < StrLen(InputText) then
                InputText := CopyStr(InputText, ClosePos + 1)
            else
                InputText := '';

            RgbPos := FindRgbPattern(InputText);
        end;

        ResultText += InputText;
        exit(ResultText);
    end;

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

    local procedure IntToHex2(Value: Integer): Text
    var
        HexChars: Text;
    begin
        HexChars := '0123456789ABCDEF';
        exit(CopyStr(HexChars, (Value div 16) + 1, 1) + CopyStr(HexChars, (Value mod 16) + 1, 1));
    end;
}
