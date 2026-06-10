report 60004 "Event Components"
{
    ApplicationArea = All;
    Caption = 'Event Components';
    UsageCategory = Administration;
    RDLCLayout = './src/report/layout/EventComponents.rdl';

    dataset
    {
        dataitem(Evento; Evento)
        {
            RequestFilterFields = "Codigo Evento";

            column(CodigoEvento_Evento; Evento."Codigo Evento")
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
            column(EmailCaption; EmailCaptionLbl)
            {
            }
            column(FechaEvento_Evento2; Evento."Fecha Evento")
            {
            }
            column(FechaEventoCaption2; FechaEventoCaptionLbl)
            {
            }
            column(NoEventoCaption2; NoEventoCaptionLbl)
            {
            }
            column(Evento_HoraEvento2; Evento."Hora Evento")
            {
            }
            column(Evento_Description2; Evento.Descripcion)
            {
            }
            column(HoraEnventoCaptionLbl; HoraEnventoCaptionLbl)
            {
            }
            dataitem(CopyLoop; 2000000026)
            {
                DataItemTableView = SORTING(Number);

                dataitem(PageLoop; 2000000026)
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));

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
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
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
                    column(Evento_Description; Evento.Descripcion)
                    {
                    }
                    column(Evento_HoraEvento; Evento."Hora Evento")
                    {
                    }
                    column(Evento_CodCliente; Evento."Codigo Cliente")
                    {
                    }
                    column(Evento_CodContacto; Evento."Codigo Contacto")
                    {
                    }
                    column(Evento_PersonaContacto; Evento."Persona de Contacto 2")
                    {
                    }
                    column(Evento_Direccion; Evento."Direccion 2")
                    {
                    }
                    column(Evento_CodPostal; Evento."Codigo Postal 2")
                    {
                    }
                    column(Evento_Poblacion; Evento."Poblacion 2")
                    {
                    }
                    column(Evento_Provincia; Evento."Provincia 2")
                    {
                    }
                    column(Evento_CIF; Evento."CIF/NIF")
                    {
                    }
                    column(Evento_Telefono; Evento."Telefono 2")
                    {
                    }
                    column(Evento_Email2; Evento."E-Mail 2")
                    {
                    }
                    column(Listado_Titulo; TituloReport)
                    {
                    }
                    column(Evento_Senalizado; Evento.Senalizado)
                    {
                    }
                    column(Evento_ImpSenal; Evento."Imp Senal")
                    {
                    }
                    column(TotalCaption; TxtTotal)
                    {
                    }
                    column(NoClienteCaption; NoClienteCaptionLbl)
                    {
                    }
                    column(NoContactoCaption; NoContactoCaptionLbl)
                    {
                    }
                    column(FechaEvento_Evento; Evento."Fecha Evento")
                    {
                    }
                    column(FechaAlta_Evento; Evento.FechaAlta)
                    {
                    }
                    column(FechaEventoCaption; FechaEventoCaptionLbl)
                    {
                    }
                    column(NoEventoCaption; NoEventoCaptionLbl)
                    {
                    }
                    column(FechaAltaCaption; FechaAltaCaptionLbl)
                    {
                    }
                    column(Evento_Comentario; txtComentarioEvento)
                    {
                    }
                    column(Evento_Pedido; gb_Pedido)
                    {
                    }
                }
                dataitem("Lineas Evento"; "Lineas Evento")
                {
                    DataItemLink = "Codigo Evento" = FIELD("Codigo Evento");
                    DataItemLinkReference = Evento;
                    DataItemTableView = SORTING("Codigo Evento", Linea) ORDER(Ascending) WHERE(Imprime = CONST(true));

                    column(Descripcion_LineasEvento; "Lineas Evento".Descripcion)
                    {
                    }
                    column(Linea_LineasEvento; "Lineas Evento".Linea)
                    {
                    }
                    column(Cantidad_LineasEvento; "Lineas Evento".Cantidad)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        //intContador := 0;
                        intNumLinea := 0;
                        //Inserto la línea del evento con "Nº línea = 0" para que sean las principales
                        RecComponentesTemp.INIT;
                        RecComponentesTemp."Codigo Evento" := "Lineas Evento"."Codigo Evento";
                        RecComponentesTemp."Linea Evento" := "Lineas Evento".Linea;
                        RecComponentesTemp.Description := "Lineas Evento".Descripcion;
                        RecComponentesTemp."Cantidad por Lote" := "Lineas Evento".Cantidad;
                        RecComponentesTemp."Line No." := intNumLinea;
                        RecComponentesTemp."Parent Item No." := "Lineas Evento"."No.";
                        RecComponentesTemp."No." := '';
                        RecComponentesTemp."Related Work Center" := "Lineas Evento"."No.";
                        RecComponentesTemp."Installed in Line No." := "Lineas Evento".Linea;
                        RecComponentesTemp."Importancia en Coste" := 0;
                        RecComponentesTemp.INSERT;
                        intRegistrosTemporal := RecComponentesTemp.COUNT;
                        codPadrePrincipal := "Lineas Evento"."No.";
                        intLinPadrePrincipal := "Lineas Evento".Linea;
                        decNivel := 0;
                        //Filtro los componentes de la línea que sean de tipo "Producto"
                        RecComponentes.RESET;
                        RecComponentes.SETCURRENTKEY("Codigo Evento", "Linea Evento", "Parent Item No.", "Line No.");
                        RecComponentes.SETRANGE(RecComponentes."Codigo Evento", "Lineas Evento"."Codigo Evento");
                        RecComponentes.SETRANGE(RecComponentes."Linea Evento", "Lineas Evento".Linea);
                        RecComponentes.SETRANGE(RecComponentes."Parent Item No.", "Lineas Evento"."No.");
                        IF bolMostrarRecursos THEN
                            RecComponentes.SETFILTER(RecComponentes.Type, '%1|%2', RecComponentes.Type::Item, RecComponentes.Type::Resource)
                        ELSE
                            RecComponentes.SETRANGE(RecComponentes.Type, RecComponentes.Type::Item);
                        IF RecComponentes.FINDSET THEN
                            REPEAT
                                intNumLinea += 10000;
                                IF decNivel <> 1 THEN decNivel := 1;
                                InsertarEnTemporal(RecComponentesTemp, RecComponentes, intNumLinea, RecComponentes."Parent Item No.", decNivel);
                                IF optMostrarNiveles = optMostrarNiveles::Todos THEN BEGIN
                                    RecComponentes.CALCFIELDS(RecComponentes."Assembly BOM");
                                    IF RecComponentes."Assembly BOM" THEN BuscarHijos(RecComponentes);
                                END;
                            //END;
                            UNTIL RecComponentes.NEXT = 0;
                    end;
                }
                dataitem("Productos Evento"; "Productos Evento")
                {
                    DataItemLink = "Codigo Evento" = FIELD("Codigo Evento");
                    DataItemLinkReference = Evento;
                    DataItemTableView = SORTING("Codigo Evento", Tipo, Linea) ORDER(Ascending) WHERE(Imprime = CONST(true));

                    column(Linea_ProdEventos; "Productos Evento".Linea)
                    {
                    }
                    column(Descripcion_ProdEventos; "Productos Evento".Descripcion)
                    {
                    }
                    column(Cantidad_ProdEventos; "Productos Evento".Cantidad)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        intNumLinea := 0;
                        intLinPadrePrincipal += 10000;
                        //Inserto la línea del evento con "Nº línea = 0" para que sean las principales
                        RecComponentesTemp.INIT;
                        RecComponentesTemp."Codigo Evento" := "Productos Evento"."Codigo Evento";
                        //RecComponentesTemp."Linea Evento" :=  "Productos Evento".Linea * 100;
                        CASE "Productos Evento".Tipo OF
                            "Productos Evento".Tipo::Menaje:
                                BEGIN
                                    RecComponentesTemp."Linea Evento" := "Productos Evento".Linea * 100;
                                END;
                            "Productos Evento".Tipo::Suplementos:
                                BEGIN
                                    RecComponentesTemp."Linea Evento" := "Productos Evento".Linea * 200;
                                END;
                            "Productos Evento".Tipo::Pan:
                                BEGIN
                                    RecComponentesTemp."Linea Evento" := "Productos Evento".Linea * 300;
                                END;
                        END;
                        RecComponentesTemp.Description := "Productos Evento".Descripcion;
                        RecComponentesTemp."Cantidad por Lote" := "Productos Evento".Cantidad;
                        RecComponentesTemp."Line No." := intNumLinea;
                        RecComponentesTemp."Parent Item No." := "Productos Evento".Producto;
                        RecComponentesTemp."No." := '';
                        RecComponentesTemp."Related Work Center" := "Productos Evento".Producto;
                        RecComponentesTemp."Installed in Line No." := "Productos Evento".Linea;
                        RecComponentesTemp."Importancia en Coste" := 0;
                        RecComponentesTemp.INSERT;
                        intRegistrosTemporal := RecComponentesTemp.COUNT;
                        codPadrePrincipal := "Productos Evento".Producto;
                        //intLinPadrePrincipal := "Productos Evento".Linea * 100;
                        intLinPadrePrincipal := RecComponentesTemp."Linea Evento";
                        decNivel := 0;
                        RecComponentes.RESET;
                        RecComponentes.SETCURRENTKEY("Codigo Evento", "Linea Evento", "Parent Item No.", "Line No.");
                        RecComponentes.SETRANGE(RecComponentes."Codigo Evento", "Productos Evento"."Codigo Evento");
                        RecComponentes.SETRANGE(RecComponentes."Linea Evento", "Productos Evento".Linea);
                        RecComponentes.SETRANGE(RecComponentes."Parent Item No.", "Productos Evento".Producto);
                        IF RecComponentes.FINDSET THEN
                            REPEAT
                                intNumLinea += 10000;
                                IF decNivel <> 1 THEN decNivel := 1;
                                InsertarEnTemporalProductos(RecComponentesTemp, RecComponentes, intNumLinea, RecComponentes."Parent Item No.", decNivel, intLinPadrePrincipal);
                                IF optMostrarNiveles = optMostrarNiveles::Todos THEN BEGIN
                                    RecComponentes.CALCFIELDS(RecComponentes."Assembly BOM");
                                    IF RecComponentes."Assembly BOM" THEN BuscarHijosProductos(RecComponentes);
                                END;
                            //END;
                            UNTIL RecComponentes.NEXT = 0;
                    end;
                }
                dataitem("Temp Componentes Evento"; 2000000026)
                {
                    DataItemTableView = SORTING(Number) ORDER(Ascending);

                    column(CodEvento_Temporal; RecComponentesTemp."Codigo Evento")
                    {
                    }
                    column(LinEvento_Temporal; RecComponentesTemp."Linea Evento")
                    {
                    }
                    column(ParentItem_Temporal; RecComponentesTemp."Parent Item No.")
                    {
                    }
                    column(LineNo_Temporal; RecComponentesTemp."Line No.")
                    {
                    }
                    column(No_Temporal; RecComponentesTemp."No.")
                    {
                    }
                    column(Descripcion_Temporal; RecComponentesTemp.Description)
                    {
                    }
                    column(UOM_Temporal; RecComponentesTemp."Unit of Measure Code")
                    {
                    }
                    column(Comentario_Temporal; RecComponentesTemp.Comentario)
                    {
                    }
                    column(Cantidad_Temporal; RecComponentesTemp."Cantidad por Lote")
                    {
                    }
                    column(codPadrePrincipal; codPadrePrincipal)
                    {
                    }
                    column(Related_Temporal; RecComponentesTemp."Related Work Center")
                    {
                    }
                    column(LineaPrincipal_Temporal; RecComponentesTemp."Installed in Line No.")
                    {
                    }
                    column(NivelIndentacion_Temporal; RecComponentesTemp."Importancia en Coste")
                    {
                    }
                    column(txtEspacios; txtEspacios)
                    {
                    }
                    column(Sombrear; gb_Sombrear)
                    {
                    }
                    column(txtColorFondo; txtColorFondo)
                    {
                    }
                    column(esPadre; esPadre)
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        IF "Temp Componentes Evento".Number = 1 THEN
                            RecComponentesTemp.FINDFIRST
                        ELSE
                            RecComponentesTemp.NEXT;
                        //RecComponentesTemp.CALCFIELDS("Assembly BOM");
                        //IF RecComponentesTemp."Assembly BOM" THEN BEGIN
                        CASE RecComponentesTemp."Importancia en Coste" OF
                            1:
                                txtColorFondo := '#FFC8A2';
                            2:
                                txtColorFondo := '#FFFFB5';
                            3:
                                txtColorFondo := '#D4F0F0';
                            4:
                                txtColorFondo := '#B6CFB6';
                            5:
                                txtColorFondo := '#CEDBDA';
                            ELSE
                                txtColorFondo := '#FFFFFF';
                        END;
                        //END ELSE
                        //  txtColorFondo := '#FB811C';
                        esPadre := FALSE;
                        RecComponentesTemp.CALCFIELDS(RecComponentesTemp."Assembly BOM");
                        IF RecComponentesTemp."Assembly BOM" THEN esPadre := TRUE;
                        txtEspacios := PADSTR(txtEspacios, RecComponentesTemp."Importancia en Coste" * 2, ' ');
                        gb_Sombrear := TRUE;
                        gr_Item.RESET;
                        gr_Item.SETRANGE("No.", RecComponentesTemp."No.");
                        IF gr_Item.FINDFIRST THEN gb_Sombrear := gr_Item."Item Tracking Code" = '';
                    end;

                    trigger OnPreDataItem()
                    begin
                        RecComponentesTemp.RESET;
                        "Temp Componentes Evento".SETRANGE("Temp Componentes Evento".Number, 1, RecComponentesTemp.COUNT);
                        intRegistrosTemporal := 0;
                        txtEspacios := '';
                        RecComponentesTemp.SETCURRENTKEY("Codigo Evento", "Linea Evento", "Parent Item No.", "Line No.");
                    end;
                }
                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN BEGIN
                        CopyText := Text003;
                        OutputNo += 1;
                    END;
                    //CurrReport.PAGENO := 1;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    IF NoOfLoops <= 0 THEN NoOfLoops := 1;
                    CopyText := '';
                    SETRANGE(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }
            trigger OnAfterGetRecord()
            begin
                GLSetup.GET;
                SalesReceivablesSetup.GET;
                IF Evento."Concepto Generico Facturacion" = '' THEN SalesReceivablesSetup.TESTFIELD("Cuenta Eventos");
                FormatAddr.Company(CompanyAddr, CompanyInfo);
                IF "Cod Teminos Pago" = '' THEN
                    PaymentTerms.INIT
                ELSE
                    PaymentTerms.GET("Cod Teminos Pago");
                IF "Cod Forma Pago" = '' THEN
                    PaymentMethod.INIT
                ELSE
                    PaymentMethod.GET("Cod Forma Pago");
                LineEventoNo := 0;
                IF gb_MostrarComentarios = FALSE THEN Comentario := '';
                IF Evento.Estado IN [Evento.Estado::Realizado, Evento.Estado::Aceptado] THEN BEGIN
                    TituloReport := PedidoCaptionLbl;
                    TxtTotal := TotalCaptionlbl + ' ' + PedidoCaptionLbl;
                    gb_Pedido := TRUE;
                END
                ELSE BEGIN
                    TituloReport := PresupuestoCaptionLbl;
                    TxtTotal := TotalCaptionlbl + ' ' + PresupuestoCaptionLbl;
                END;
                CLEAR(txtComentarioEvento);
                txtComentarioEvento := Evento.Comentario;
                IF Evento.Comentario2 <> '' THEN txtComentarioEvento := txtComentarioEvento + ' ' + Evento.Comentario2;
                IF RecComponentesTemp.ISTEMPORARY THEN RecComponentesTemp.DELETEALL;
            end;

            trigger OnPreDataItem()
            begin
                // Inicio ADV001
                IF filtroeento <> '' THEN Evento.SETRANGE(Evento."Codigo Evento", filtroeento);
                // Fin ADV001
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
                    }
                    field(optMostrarNiveles; optMostrarNiveles)
                    {
                        ApplicationArea = All;
                        Caption = 'Niveles a mostrar';
                    }
                    field(bolMostrarRecursos; bolMostrarRecursos)
                    {
                        ApplicationArea = All;
                        Caption = 'Mostrar recursos';
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
            optMostrarNiveles := optMostrarNiveles::"Receta Madre";
        end;
    }
    labels
    {
        LblReferencia = 'Marca / Referencia';
        LblDescripcion = 'Descripción';
        LblCantidad = 'Cantidad';
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
    }
    var
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        OutputNo: Integer;
        PaymentMethod: Record 289;
        PaymentTerms: Record 3;
        CompanyInfo: Record 79;
        FormatAddr: Codeunit 365;
        CompanyAddr: array[8] of Text[50];
        LineasEventoTMP: Record 50002 temporary;
        LineEventoNo: Integer;
        TituloReport: Text[100];
        VATAmountLineTMP: Record 290 temporary;
        TxtTotal: Text[200];
        SalesReceivablesSetup: Record 311;
        GLSetup: Record 98;
        gb_Pedido: Boolean;
        gb_MostrarComentarios: Boolean;
        txtComentarioEvento: Text[550];
        gr_Item: Record 27;
        gb_Sombrear: Boolean;
        gn_platos: Decimal;
        gt_lineasevento: Record 50002;
        filtroeento: Code[20];
        filtrolinea: Integer;
        gt_productosevento: Record 50016;
        gtxt_DescripcionProducto: Text[50];
        Text003: Label 'COPY';
        PageCaptionCap: Label 'Página %1 de %2';
        PhoneNoCaptionLbl: Label 'Phone No.';
        VATRegNoCaptionLbl: Label 'VAT Registration No.';
        HomePageCaptionCap: Label 'Home Page';
        EmailCaptionLbl: Label 'E-Mail';
        PmtTermsDescCaptionLbl: Label 'Payment Terms';
        PmtMethodDescCaptionLbl: Label 'Payment Method';
        FaxNoCaptionLbl: Label 'Phone No.';
        PresupuestoCaptionLbl: Label 'Presupuesto';
        PedidoCaptionLbl: Label 'Pedido';
        NoClienteCaptionLbl: Label 'Nº cliente';
        NoContactoCaptionLbl: Label 'Nº contacto';
        FechaEventoCaptionLbl: Label 'FECHA EVENTO';
        NoEventoCaptionLbl: Label 'Nº EVENTO';
        FechaAltaCaptionLbl: Label 'Fecha alta';
        TotalCaptionlbl: Label 'Total';
        HoraEnventoCaptionLbl: Label 'Hora Evento';
        RecComponentes: Record 50014;
        RecComponentesTemp: Record 50014 temporary;
        decNivel: Decimal;
        intRegistrosTemporal: Integer;
        codPadrePrincipal: Code[20];
        intLinPadrePrincipal: Integer;
        txtEspacios: Text;
        optMostrarNiveles: Option Todos,"Receta Madre";
        bolMostrarRecursos: Boolean;
        txtColorFondo: Text[7];
        intNumLinea: Integer;
        esPadre: Boolean;

    local procedure BuscarHijos(RecComponente: Record 50014)
    var
        RecComponenteHijo: Record 50014;
    begin
        //Filtro los subcomponetes del componente
        decNivel += 1;
        RecComponenteHijo.RESET;
        RecComponenteHijo.SETCURRENTKEY("Codigo Evento", "Linea Evento", "Parent Item No.", "Line No.");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Codigo Evento", RecComponente."Codigo Evento");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Linea Evento", RecComponente."Linea Evento");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Parent Item No.", RecComponente."No.");
        IF bolMostrarRecursos THEN
            RecComponenteHijo.SETFILTER(RecComponenteHijo.Type, '%1|%2', RecComponenteHijo.Type::Item, RecComponenteHijo.Type::Resource)
        ELSE
            RecComponenteHijo.SETRANGE(RecComponenteHijo.Type, RecComponenteHijo.Type::Item);
        IF RecComponenteHijo.FINDSET THEN
            REPEAT
                intNumLinea += 10000;
                InsertarEnTemporal(RecComponentesTemp, RecComponenteHijo, intNumLinea, RecComponente."No.", decNivel);
                RecComponenteHijo.CALCFIELDS(RecComponenteHijo."Assembly BOM");
                IF RecComponenteHijo."Assembly BOM" THEN BEGIN
                    BuscarHijos(RecComponenteHijo);
                    decNivel -= 1;
                END;
            UNTIL RecComponenteHijo.NEXT = 0;
    end;

    local procedure InsertarEnTemporal(var RecComponentesTEMP: Record 50014; var RecComponenteHijo: Record 50014; intNumLinea: Integer; codNoComponente: Code[20]; decNivel: Decimal)
    begin
        RecComponentesTEMP.INIT;
        RecComponentesTEMP."Codigo Evento" := RecComponenteHijo."Codigo Evento";
        RecComponentesTEMP."Linea Evento" := RecComponenteHijo."Linea Evento";
        RecComponentesTEMP."Line No." := intNumLinea;
        RecComponentesTEMP."Parent Item No." := codNoComponente;
        RecComponentesTEMP."No." := RecComponenteHijo."No.";
        RecComponentesTEMP.Description := RecComponenteHijo.Description;
        RecComponentesTEMP."Unit of Measure Code" := RecComponenteHijo."Unit of Measure Code";
        RecComponentesTEMP."Cantidad por Lote" := RecComponenteHijo."Cantidad por Lote";
        RecComponentesTEMP."Related Work Center" := codPadrePrincipal;
        RecComponentesTEMP."Installed in Line No." := intLinPadrePrincipal;
        RecComponentesTEMP."Importancia en Coste" := decNivel;
        RecComponenteHijo.CALCFIELDS("Assembly BOM");
        RecComponentesTEMP."Assembly BOM" := RecComponenteHijo."Assembly BOM";
        RecComponentesTEMP.INSERT;
        intRegistrosTemporal := RecComponentesTEMP.COUNT;
    end;

    local procedure InsertarEnTemporalProductos(var RecComponentesTEMP: Record 50014; var RecComponenteHijo: Record 50014; intNumLinea: Integer; codNoComponente: Code[20]; decNivel: Decimal; intLLineaPadre: Integer)
    begin
        RecComponentesTEMP.INIT;
        RecComponentesTEMP."Codigo Evento" := RecComponenteHijo."Codigo Evento";
        RecComponentesTEMP."Linea Evento" := intLLineaPadre;
        RecComponentesTEMP."Line No." := intNumLinea;
        RecComponentesTEMP."Parent Item No." := codNoComponente;
        RecComponentesTEMP."No." := RecComponenteHijo."No.";
        RecComponentesTEMP.Description := RecComponenteHijo.Description;
        RecComponentesTEMP."Unit of Measure Code" := RecComponenteHijo."Unit of Measure Code";
        RecComponentesTEMP."Cantidad por Lote" := RecComponenteHijo."Cantidad por Lote";
        RecComponentesTEMP."Related Work Center" := codPadrePrincipal;
        RecComponentesTEMP."Installed in Line No." := RecComponenteHijo."Line No.";
        RecComponentesTEMP."Importancia en Coste" := decNivel;
        RecComponenteHijo.CALCFIELDS("Assembly BOM");
        RecComponentesTEMP."Assembly BOM" := RecComponenteHijo."Assembly BOM";
        RecComponentesTEMP.INSERT;
        intRegistrosTemporal := RecComponentesTEMP.COUNT;
    end;

    local procedure BuscarHijosProductos(RecComponente: Record 50014)
    var
        RecComponenteHijo: Record 50014;
    begin
        //Filtro los subcomponetes del componente
        decNivel += 1;
        RecComponenteHijo.RESET;
        RecComponenteHijo.SETCURRENTKEY("Codigo Evento", "Linea Evento", "Parent Item No.", "Line No.");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Codigo Evento", RecComponente."Codigo Evento");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Linea Evento", RecComponente."Linea Evento");
        RecComponenteHijo.SETRANGE(RecComponenteHijo."Parent Item No.", RecComponente."No.");
        IF bolMostrarRecursos THEN
            RecComponenteHijo.SETFILTER(RecComponenteHijo.Type, '%1|%2', RecComponenteHijo.Type::Item, RecComponenteHijo.Type::Resource)
        ELSE
            RecComponenteHijo.SETRANGE(RecComponenteHijo.Type, RecComponenteHijo.Type::Item);
        IF RecComponenteHijo.FINDSET THEN
            REPEAT
                intNumLinea += 10000;
                InsertarEnTemporalProductos(RecComponentesTemp, RecComponenteHijo, intNumLinea, RecComponente."No.", decNivel, intLinPadrePrincipal);
                RecComponenteHijo.CALCFIELDS(RecComponenteHijo."Assembly BOM");
                IF RecComponenteHijo."Assembly BOM" THEN BEGIN
                    BuscarHijos(RecComponenteHijo);
                    decNivel -= 1;
                END;
            UNTIL RecComponenteHijo.NEXT = 0;
    end;

    procedure fijafiltros(_evento: Code[20]; _linea: Integer)
    begin
        // Inicio ADV001
        filtroeento := _evento;
        filtrolinea := _linea;
        // Fin ADV001
    end;
}
