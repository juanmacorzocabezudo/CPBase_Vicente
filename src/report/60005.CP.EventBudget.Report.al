/// <summary>
/// Report "CP Event Budget" (ID 60005).
/// Prints the event budget/order document.
/// Main dataitem is Evento (50004).
/// </summary>
report 60005 "Event Budget"
{
    Caption = 'Event Budget';
    Description = 'Prints the event budget/order document.';
    ApplicationArea = Basic, Suite;
    UsageCategory = ReportsAndAnalysis;
    AdditionalSearchTerms = 'Event, Budget, Presupuesto, Pedido';
    DefaultRenderingLayout = EventBudgetRDLC;

    dataset
    {
        dataitem(Evento; Evento)
        {
            DataItemTableView = sorting("Codigo Evento");
            RequestFilterFields = "Codigo Evento", Estado, "Tipo Evento", "Fecha Evento";

            #region "Event Header"
            column(EventNo; "Codigo Evento") { }
            column(TipoImpresion; "Tipo de Impresión") { }
            column(TipoImpresionOrdinal; TipoImpresionOrdinal) { }
            // Datos de Facturación
            column(EventoPersonadeContacto; "Persona de Contacto") { }
            column(EventoCIFNIF; "CIF/NIF") { }
            column(EventoDireccion; Direccion) { }
            column(EventoTelefono; Telefono) { }
            column(EVentoPoblacion; Poblacion) { }
            column(EventoCodigoPostal; "Codigo Postal") { }
            column(EventoProvincia; Provincia) { }
            column(EventoEMail; "E-Mail") { }
            // Bases del presupuesto
            column(EventDescription; Descripcion) { }
            column(EventoFecha; "Fecha Evento") { }
            column(EventoHora; "Hora Evento") { }
            column(EventoPoblacion2; "Poblacion 2") { }
            column(EventoCodigoPostal2; "Codigo Postal 2") { }
            column(EventoProvincia2; "Provincia 2") { }
            column(EventoCodTeminosPago; "Cod Teminos Pago") { }
            column(EventoCodFormaPago; "Cod Forma Pago") { }
            column(EventoIBAN; EventoIBAN) { }
            column(EventoLugarEvento2; "Lugar Evento 2") { }
            column(EventoDireccion2; "Direccion 2") { }
            column(EventoTotalAdultos; "Total Adultos") { }
            column(EventoPersonaDeContacto2; "Persona de Contacto 2") { }
            column(EventoTelefono2; "Telefono 2") { }
            column(EventoEMail2; "E-Mail 2") { }
            column(EventoImpSenal; "Imp Senal") { }
            column(EventoComentario; Comentario) { }
            column(GreetingText; GreetingText) { }
            column(ObservationsText; ObservationsText) { }
            column(ObservationsText2; ObservationsText2) { }
            column(FormOfContractText; FormOfContractText) { }
            column(ShowBillingData; ShowBillingData) { }
            column(ShowComments; ShowComments) { }
            column(ShowObservations; ShowObservations) { }
            column(ShowObservations2; ShowObservations2) { }
            column(ShowFormOfContract; ShowFormOfContract) { }
            column(ShowGreetingText; ShowGreetingText) { }
            // Totals
            column(ExtrasPricePerPerson; ExtrasPricePerPerson) { DecimalPlaces = 2 : 2; }
            column(OfertaMesSinIVA; "Oferta Mes Sin IVA") { }
            column(IvasTotal; IvaTotal) { }
            column(IvasImportePendiente; ImportePendiente) { }
            column(IvasEsSenalizado; Senalizado) { }
            #endregion

            #region "Event Lines"
            dataitem(LineasEvento; "Lineas Evento")
            {
                DataItemLinkReference = Evento;
                DataItemLink = "Codigo Evento" = field("Codigo Evento");
                DataItemTableView = sorting("Codigo Evento", Linea);

                column(LineasEvento_Linea; Linea) { }
                column(LineasEvento_ImprCapitulo; ImprCapitulo) { }
                column(LineasEvento_No; "No.") { }
                column(LineasEvento_Descripcion; Descripcion) { }
                column(LineasEvento_DescripCapitulo; DescripCapitulo) { }
                column(LineasEvento_Cantidad; Cantidad) { }
                column(LineasEvento_PrecioReal; "Precio Real") { DecimalPlaces = 2 : 3; }
                column(LineasEvento_Importe; Importe) { }
                column(LineasEvento_Comentarios; Comentarios) { }
                column(LineasEvento_CantidadComensales; CantidadComensales) { }
                column(LineasEvento_PctIVA; "% IVA") { }
            }
            #endregion

            #region "Event Products"
            dataitem(ProductosEvento; "Productos Evento")
            {
                DataItemLinkReference = Evento;
                DataItemLink = "Codigo Evento" = field("Codigo Evento");
                DataItemTableView = sorting("Codigo Evento", Tipo, Linea);

                column(ProductosEvento_Tipo; Tipo) { }
                column(ProductosEvento_ImprCapitulo; ImprCapitulo) { }
                column(ProductosEvento_Producto; Producto) { }
                column(ProductosEvento_Descripcion; Descripcion) { }
                column(ProductosEvento_Cantidad; Cantidad) { }
                column(ProductosEvento_PrecioReal; "Precio Real") { DecimalPlaces = 2 : 3; }
                column(ProductosEvento_Importe; Importe) { }
                column(ProductosEvento_Comentarios; Comentarios) { }
                column(ProductosEvento_Linea; Linea) { }
            }
            #endregion

            #region "Event Resources"
            dataitem(RecursosEvento; "Recursos Evento")
            {
                DataItemLinkReference = Evento;
                DataItemLink = "Codigo Evento" = field("Codigo Evento");
                DataItemTableView = sorting("Codigo Evento", Tipo, Linea);

                column(RecursosEvento_Tipo; Tipo) { }
                column(RecursosEvento_ImprCapitulo; ImprCapitulo) { }
                column(RecursosEvento_CodigoRecurso; "Codigo Recurso") { }
                column(RecursosEvento_Descripcion; Descripcion) { }
                column(RecursosEvento_Cantidad; Cantidad) { }
                column(RecursosEvento_PrecioReal; "Precio Real") { DecimalPlaces = 2 : 3; }
                column(RecursosEvento_Importe; Importe) { }
                column(RecursosEvento_Comentarios; Comentarios) { }
                column(RecursosEvento_Linea; Linea) { }
            }
            #endregion

            #region "VAT Breakdown"
            dataitem(Ivas; "Lineas Evento")
            {
                DataItemLinkReference = Evento;
                DataItemLink = "Codigo Evento" = field("Codigo Evento");
                DataItemTableView = sorting("Codigo Evento", Linea);

                column(Ivas_Iva; "% IVA") { }
                column(Ivas_Base; IvaBase) { }
                column(Ivas_Importe; IvaImporte) { }
                column(Ivas_Subtotal; IvaSubTotal) { }

                trigger OnAfterGetRecord()
                begin
                    CalculateVATBreakdown("Codigo Evento", "% IVA");
                end;
            }
            #endregion

            #region "Company Inf."
            column(CompanyName; CompanyInfor.Name) { }
            column(CompanyAddress; CompanyInfor.Address) { }
            column(CompanyAddress2; CompanyInfor."Address 2") { }
            column(CompanyCity; CompanyInfor.City) { }
            column(CompanyCounty; CompanyInfor.County) { }
            column(CompanyPostCode; CompanyInfor."Post Code") { }
            column(CompanyVATRegNo; CompanyInfor."VAT Registration No.") { }
            column(CompanyPhoneNo; CompanyInfor."Phone No.") { }
            column(CompanyEmail; CompanyInfor."E-Mail") { }
            column(CompanyPicture; CompanyInfor.Picture) { }
            #endregion

            #region "Observations"
            dataitem(Observaciones_1; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                column(Observaciones1_Grupo; Number) { }
            }
            #endregion

            trigger OnAfterGetRecord()
            begin
                TipoImpresionOrdinal := "Tipo de Impresión".AsInteger();
                GreetingText := LoadTextRichData(60000);  // Greeting Text
                ObservationsText := LoadTextRichData(60001);  // Observations Text 1
                ObservationsText2 := LoadTextRichData(60002);  // Observations Text 2
                FormOfContractText := LoadTextRichData(60003);  // Form of Contract and Payment
                EventoIBAN := GetBankIBAN("Codigo Cliente");
                ExtrasPricePerPerson := CalculateExtrasPricePerPerson("Codigo Evento");
                CalculateTotalVAT("Codigo Evento");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ShowGreetingTextField; ShowGreetingText)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Greeting Text';
                        ToolTip = 'Specifies whether the greeting text section is shown in the report.';
                    }
                    field(ShowBillingDataField; ShowBillingData)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Billing Data';
                        ToolTip = 'Specifies whether billing data is included in the report.';
                    }
                    field(ShowCommentsField; ShowComments)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Comments';
                        ToolTip = 'Specifies whether comments are included in the report.';
                    }
                    field(ShowObservationsField; ShowObservations)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Observations';
                        ToolTip = 'Specifies whether the first observations section is shown in the report.';
                    }
                    field(ShowObservations2Field; ShowObservations2)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Observations 2';
                        ToolTip = 'Specifies whether the second observations section is shown in the report.';
                    }
                    field(ShowFormOfContractField; ShowFormOfContract)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Form of Contract';
                        ToolTip = 'Specifies whether the form of contract and payment section is shown in the report.';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            if not OptionsSet then begin
                ShowComments := true;
                ShowBillingData := true;
                ShowObservations := true;
                ShowObservations2 := true;
                ShowFormOfContract := true;
                ShowGreetingText := true;
            end;
        end;
    }

    rendering
    {
        layout(EventBudgetRDLC)
        {
            Type = RDLC;
            Caption = 'Event Budget';
            LayoutFile = './src/report/layout/EventBudget.rdl';
        }
    }

    labels
    {
        BudgetLbl = 'Budget', Locked = false, Comment = 'Presupuesto';
        BillingDataLbl = 'Billing Data', Locked = false, Comment = 'Datos de facturación';
        CustomerLbl = 'Customer', Locked = false, Comment = 'Cliente';
        VATRegistrationNoLbl = 'VAT Registration No.', Locked = false, Comment = 'CIF / NIF';
        AddressLbl = 'Address', Locked = false, Comment = 'Direccion';
        PhoneMobileLbl = 'Phone / Mobile', Locked = false, Comment = 'Teléfono / Móvil';
        CityLbl = 'City', Locked = false, Comment = 'Localidad';
        PostCodeLbl = 'Post Code', Locked = false, Comment = 'Código postal';
        CountyLbl = 'County', Locked = false, Comment = 'Provincia';
        EmailLbl = 'E-Mail', Locked = false, Comment = 'E-Mail';
        BudgetBasesLbl = 'Budget Bases', Locked = false, Comment = 'Bases del presupuesto';
        SubjectLbl = 'Description', Locked = false, Comment = 'Descripción';
        DateLbl = 'Date', Locked = false, Comment = 'Fecha';
        TimeLbl = 'Time', Locked = false, Comment = 'Hora';
        LocationLbl = 'Location', Locked = false, Comment = 'Lugar';
        PostalCodeLbl = 'Postal Code', Locked = false, Comment = 'Código postal';
        ProvinceLbl = 'Province', Locked = false, Comment = 'Provincia';
        PaymentFormLbl = 'Payment Terms', Locked = false, Comment = 'Forma de pago';
        AccountNoLbl = 'Account No.', Locked = false, Comment = 'Número de cuenta';
        EventLocationLbl = 'Event Location', Locked = false, Comment = 'Lugar del evento';
        NoofGuestsLbl = 'No. of Guests', Locked = false, Comment = 'Número de comensales';
        ContactsLbl = 'Contact(s)', Locked = false, Comment = 'Persona(s) de contacto';
        PhonesLbl = 'Phone(s)', Locked = false, Comment = 'Teléfono(s)';
        EMailsLbl = 'E-Mail(s)', Locked = false, Comment = 'E-Mail(s)';
        DownPaymentLbl = 'Down Payment', Locked = false, Comment = 'Importe de señal';
        TotalMenuLbl = 'Total Menu', Locked = false, Comment = 'Total Menu';
        TaxBasesLbl = 'Tax Base', Locked = false, Comment = 'Base Imponible';
        VATLbl = 'VAT %', Locked = false, Comment = '% IVA';
        VatAmountLbl = 'VAT Amount', Locked = false, Comment = 'Importe IVA';
        SubtotalLbl = 'Subtotal', Locked = false, Comment = 'Subtotal';
        TotalBudgetLbl = 'Total Budget', Locked = false, Comment = 'Total presupuesto';
        CommentsLbl = 'Comments', Locked = false, Comment = 'Observaciones';
        CustomerSatisfactionLbl = 'Customer Satisfaction', Locked = false, Comment = 'Satisfacción del cliente';
        FirstNameAndLastNameLbl = 'First Name and Last Name', Locked = false, Comment = 'Nombre y Apellidos';
        DNILbl = 'DNI', Locked = false, Comment = 'DNI';
        InTheCapacityOfLbl = 'In the capacity of', Locked = false, Comment = 'En calidad de';
        SignatureLbl = 'Signature', Locked = false, Comment = 'Firma';
        FormOfContractAndPaymentLbl = 'Form of contract and payment', Locked = false, Comment = 'Forma de contratación y pago';
        pageLbl = 'Page', Locked = false, Comment = 'Página';
        // Detail columns
        ReferenceLbl = 'Brand / Reference', Locked = false, Comment = 'Marca / Referencia';
        DescriptionLbl = 'Description', Locked = false, Comment = 'Descripción';
        QuantityLbl = 'Quantity', Locked = false, Comment = 'Cantidad';
        PriceLbl = 'Price', Locked = false, Comment = 'Precio';
        AmountLbl = 'Amount', Locked = false, Comment = 'Importe';
        PendingAmountLbl = 'Pending Amount', Locked = false, Comment = 'Importe Pendiente';
        TotalLbl = 'Total', Locked = false, Comment = 'Total';
    }

    trigger OnPreReport()
    begin
        CompanyInfor.Get();
        CompanyInfor.CalcFields(Picture);
    end;

    var
        CompanyInfor: Record "Company Information";
        ShowComments: Boolean;
        ShowBillingData: Boolean;
        ShowObservations: Boolean;
        ShowObservations2: Boolean;
        ShowFormOfContract: Boolean;
        ShowGreetingText: Boolean;
        GreetingText: Text;
        ObservationsText: Text;
        ObservationsText2: Text;
        FormOfContractText: Text;
        EventoIBAN: Text[50];
        ExtrasPricePerPerson: Decimal;
        IvaBase: Decimal;
        IvaImporte: Decimal;
        IvaSubTotal: Decimal;
        IvaTotal: Decimal;
        ImportePendiente: Decimal;
        TipoImpresionOrdinal: Integer;
        OptionsSet: Boolean;

    /// <summary>
    /// Sets the default values for the request page options.
    /// Call this before Run() or RunModal() to pre-configure the report.
    /// The user can still modify the options on the request page.
    /// </summary>
    procedure SetOptions(NewShowGreetingText: Boolean; NewShowBillingData: Boolean; NewShowComments: Boolean; NewShowObservations: Boolean; NewShowObservations2: Boolean; NewShowFormOfContract: Boolean)
    begin
        ShowGreetingText := NewShowGreetingText;
        ShowBillingData := NewShowBillingData;
        ShowComments := NewShowComments;
        ShowObservations := NewShowObservations;
        ShowObservations2 := NewShowObservations2;
        ShowFormOfContract := NewShowFormOfContract;
        OptionsSet := true;
    end;

    local procedure GetBankIBAN(CustomerNo: Code[20]): Text[50]
    var
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
    begin
        if Customer.Get(CustomerNo) then
            if BankAccount.Get(Customer.CodBancoEmpresa) then
                exit(BankAccount.IBAN);
        exit('');
    end;

    local procedure CalculateExtrasPricePerPerson(EventCode: Code[20]): Decimal
    var
        EventLine: Record "Lineas Evento";
        ProductLine: Record "Productos Evento";
        ResourceLine: Record "Recursos Evento";
        TotalDiners: Integer;
        TotalExtras: Decimal;
        PreviousChapter: Code[20];
    begin
        PreviousChapter := '';
        // Count total diners across chapters (one per chapter to avoid double-counting)
        EventLine.SetRange("Codigo Evento", EventCode);
        if EventLine.FindSet() then
            repeat
                if PreviousChapter <> EventLine.ImprCapitulo then begin
                    TotalDiners += EventLine.CantidadComensales;
                    PreviousChapter := EventLine.ImprCapitulo;
                end;
            until EventLine.Next() = 0;

        // Sum all products and resources amounts
        ProductLine.SetRange("Codigo Evento", EventCode);
        ProductLine.CalcSums(Importe);

        ResourceLine.SetRange("Codigo Evento", EventCode);
        ResourceLine.CalcSums(Importe);

        TotalExtras := ProductLine.Importe + ResourceLine.Importe;

        if TotalDiners > 0 then begin
            if TotalExtras > 0 then
                exit(TotalExtras / TotalDiners);
            exit(0);
        end;
        exit(TotalExtras);
    end;

    local procedure CalculateVATBreakdown(EventCode: Code[20]; VATRate: Decimal)
    var
        EventLine: Record "Lineas Evento";
        ProductLine: Record "Productos Evento";
        ResourceLine: Record "Recursos Evento";
    begin
        IvaBase := 0;
        IvaImporte := 0;
        IvaSubTotal := 0;

        EventLine.SetRange("Codigo Evento", EventCode);
        EventLine.SetRange("% IVA", VATRate);
        EventLine.CalcSums(Importe, "Importe IVA Incl.");

        ProductLine.SetRange("Codigo Evento", EventCode);
        ProductLine.SetRange("% IVA", VATRate);
        ProductLine.CalcSums(Importe, "Importe IVA Incl.");

        ResourceLine.SetRange("Codigo Evento", EventCode);
        ResourceLine.SetRange("% IVA", VATRate);
        ResourceLine.CalcSums(Importe, "Importe IVA Incl.");

        IvaBase := EventLine.Importe + ProductLine.Importe + ResourceLine.Importe;
        IvaSubTotal := EventLine."Importe IVA Incl." + ProductLine."Importe IVA Incl." + ResourceLine."Importe IVA Incl.";
        IvaImporte := IvaSubTotal - IvaBase;
    end;

    local procedure CalculateTotalVAT(EventCode: Code[20])
    var
        EventLine: Record "Lineas Evento";
        ProductLine: Record "Productos Evento";
        ResourceLine: Record "Recursos Evento";
    begin
        EventLine.SetRange("Codigo Evento", EventCode);
        EventLine.CalcSums("Importe IVA Incl.");

        ProductLine.SetRange("Codigo Evento", EventCode);
        ProductLine.CalcSums("Importe IVA Incl.");

        ResourceLine.SetRange("Codigo Evento", EventCode);
        ResourceLine.CalcSums("Importe IVA Incl.");

        IvaTotal := EventLine."Importe IVA Incl." + ProductLine."Importe IVA Incl." + ResourceLine."Importe IVA Incl.";
        ImportePendiente := IvaTotal - Evento."Imp Senal";
    end;

    local procedure LoadTextRichData(FieldNo: Integer): Text
    var
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        FldRef: FieldRef;
        InStr: InStream;
        Result: Text;
    begin
        RecRef.GetTable(Evento);
        FldRef := RecRef.Field(FieldNo);
        FldRef.CalcField();
        TempBlob.FromRecordRef(RecRef, FieldNo);
        if not TempBlob.HasValue() then
            exit('');
        TempBlob.CreateInStream(InStr, TextEncoding::UTF8);
        InStr.Read(Result);
        exit(Result);
    end;
}
