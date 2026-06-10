page 60010 "CP BOM Aditional Cost"
{
    ApplicationArea = All;
    Caption = 'BOM Additional Cost';
    PageType = ListPart;
    SourceTable = "BOM Aditional Cost";

    layout
    {
        area(content)
        {
            group(Information)
            {
                Caption = 'Information';

                group(FixedCost)
                {
                    Caption = 'Fixed Cost';

                    field(FixedBOMTotalCost; Item.Receta_CosteLMFijado)
                    {
                        ApplicationArea = All;
                        Caption = 'BOM Total Cost (Fixed)';
                        ToolTip = 'Specifies the fixed total cost of the bill of materials.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                    }
                    field(FixedGeneralCosts; FixedGeneralCostsValue)
                    {
                        ApplicationArea = All;
                        Caption = 'General Costs (Fixed)';
                        ToolTip = 'Specifies the fixed general costs excluding profit.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                    }
                    field(FixedExworkStdCost; AsmInfoPaneMgt.CalcAditionalFixedTotalCoste(Rec."Item No", 0) + Item.Receta_CosteLMFijado)
                    {
                        ApplicationArea = All;
                        Caption = 'EXWORK Standard (Fixed)';
                        ToolTip = 'Specifies the fixed EXWORK standard price.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        Style = Strong;
                        StyleExpr = true;
                    }
                    field(FixedProfit; FixedProfitValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Profit (Fixed)';
                        ToolTip = 'Specifies the profit calculated on the fixed cost.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                    }
                    field(FixedProfitPct; FixedProfitPctValue)
                    {
                        ApplicationArea = All;
                        Caption = '% Profit (Fixed)';
                        ToolTip = 'Specifies the profit percentage on the fixed cost.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                    }
                }

                group(ProductCost)
                {
                    Caption = 'Product Cost';

                    field(ProductBOMTotalCost; AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true))
                    {
                        ApplicationArea = All;
                        Caption = 'BOM Total Cost (Product)';
                        ToolTip = 'Specifies the total BOM cost calculated from product standard costs.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field(ProductGeneralCosts; ProductGeneralCostsValue)
                    {
                        ApplicationArea = All;
                        Caption = 'General Costs (Product)';
                        ToolTip = 'Specifies the general costs calculated from product standard costs.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field(ProductExworkStdCost; AsmInfoPaneMgt.CalcAditionalUnitTotalCosteReceta(Rec."Item No", 0, true) + AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true))
                    {
                        ApplicationArea = All;
                        Caption = 'EXWORK Standard (Product)';
                        ToolTip = 'Specifies the EXWORK standard price calculated from product standard costs.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        Style = StandardAccent;
                        StyleExpr = true;
                    }
                    field(ProductProfit; ProductProfitValue)
                    {
                        ApplicationArea = All;
                        Caption = 'Profit (Product)';
                        ToolTip = 'Specifies the profit calculated from product standard costs.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        StyleExpr = ProductProfitStyleTxt;
                    }
                    field(ProductProfitPct; ProductProfitPctValue)
                    {
                        ApplicationArea = All;
                        Caption = '% Profit (Product)';
                        ToolTip = 'Specifies the profit percentage calculated from product standard costs.';
                        Editable = false;
                        DecimalPlaces = 3 : 3;
                        StyleExpr = ProductProfitStyleTxt;
                    }
                }
            }
            repeater(Lines)
            {
                Caption = 'Lines';

                field(CostNo; Rec."No. Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Cost No.';
                    ToolTip = 'Specifies the cost number.';
                }
                field(CostDescription; Rec."Description Cost")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Description';
                    ToolTip = 'Specifies the description of the cost.';
                }
                field(CostType; Rec."Type Coste")
                {
                    ApplicationArea = All;
                    Caption = 'Cost Type';
                    ToolTip = 'Specifies the type of cost (% or EUR).';
                }
                field(CostValue; Rec.Value)
                {
                    ApplicationArea = All;
                    Caption = 'Value';
                    ToolTip = 'Specifies the cost value.';
                    DecimalPlaces = 3 : 3;
                }
                field(ApplyOnAllCost; Rec."Apply on all cost")
                {
                    ApplicationArea = All;
                    Caption = 'Apply on All Costs';
                    ToolTip = 'Specifies whether this cost applies on top of all other costs.';
                }
                field(AdditionalFixedCost; Rec."Aditional fixed cost")
                {
                    ApplicationArea = All;
                    Caption = 'General Costs (Fixed)';
                    ToolTip = 'Specifies the additional fixed cost.';
                    Editable = false;
                    DecimalPlaces = 3 : 3;
                }
                field(AdditionalProductCost; AsmInfoPaneMgt.CalcAditionalUnitCoste(Rec, true))
                {
                    ApplicationArea = All;
                    Caption = 'Additional Std. Cost (Product)';
                    ToolTip = 'Specifies the additional standard cost calculated from product costs.';
                    Editable = false;
                    DecimalPlaces = 3 : 3;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(LineProfit; AsmInfoPaneMgt.CalcBeneficioActualizado(Rec))
                {
                    ApplicationArea = All;
                    Caption = 'Profit (Product)';
                    ToolTip = 'Specifies the updated profit for this cost line.';
                    Editable = false;
                    DecimalPlaces = 3 : 3;
                    StyleExpr = LineProfitStyleTxt;
                }
                field(LineProfitPct; AsmInfoPaneMgt.CalcPerBeneficioActualizado(Rec))
                {
                    ApplicationArea = All;
                    Caption = '% Profit (Product)';
                    ToolTip = 'Specifies the updated profit percentage for this cost line.';
                    Editable = false;
                    DecimalPlaces = 3 : 3;
                    StyleExpr = LineProfitStyleTxt;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(ActionGroup)
            {
                Caption = 'Actions';

                action(AddCostFromTemplate)
                {
                    ApplicationArea = All;
                    Caption = 'Additional Cost';
                    ToolTip = 'Add additional costs from a cost template.';
                    Image = CostEntries;

                    trigger OnAction()
                    var
                        TemplateCostHeader: Record "Template Cost Header";
                        FuncionesVarias: Codeunit FuncionesVarias;
                    begin
                        TemplateCostHeader.Reset();
                        if Page.RunModal(Page::"Template Cost Header", TemplateCostHeader) = Action::LookupOK then begin
                            Clear(FuncionesVarias);
                            FuncionesVarias.CopyCostBOMfromTemplate(Rec."Item No", Rec."BOM Version", TemplateCostHeader);
                        end;
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        LoadItem();
    end;

    trigger OnAfterGetRecord()
    begin
        LoadItem();
        // Solo actualizar estilos de línea (repeater), no cabecera
        LineProfitStyleTxt := GetProfitStyle(AsmInfoPaneMgt.CalcPerBeneficioActualizado(Rec));
    end;

    trigger OnAfterGetCurrRecord()
    begin
        // Trigger correcto para actualizar campos de cabecera (fuera del repeater)
        LoadItem();
        CalculateFixedProfitValues();
        CalculateProductProfitValues();
        ProductProfitStyleTxt := GetProfitStyle(ProductProfitPctValue);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        LineProfitStyleTxt := 'Standard';
    end;

    trigger OnModifyRecord(): Boolean
    begin
        // Forzar refresco de cabecera tras modificación del usuario
        CurrPage.Update(false);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.Update(false);
    end;

    var
        Item: Record Item;
        AsmInfoPaneMgt: Codeunit AlxiaAssemblyInfoManagement;
        FixedProfitValue: Decimal;
        FixedProfitPctValue: Decimal;
        FixedGeneralCostsValue: Decimal;
        ProductProfitValue: Decimal;
        ProductProfitPctValue: Decimal;
        ProductGeneralCostsValue: Decimal;
        LineProfitStyleTxt: Text;
        ProductProfitStyleTxt: Text;

    local procedure LoadItem()
    begin
        if Rec."Item No" <> '' then begin
            if not Item.Get(Rec."Item No") then
                Clear(Item);
        end else
            if Rec.GetFilter("Item No") <> '' then
                if not Item.Get(Rec.GetFilter("Item No")) then
                    Clear(Item);
    end;

    local procedure FindBeneficioLine(var BeneficioLine: Record "BOM Aditional Cost"): Boolean
    begin
        if Item."No." = '' then
            exit(false);

        // Primero: identificar por "Apply on all cost" = TRUE (OP 1)
        BeneficioLine.Reset();
        BeneficioLine.SetRange("Item No", Item."No.");
        BeneficioLine.SetRange("BOM Version", 0);
        BeneficioLine.SetRange("Apply on all cost", true);
        if BeneficioLine.FindFirst() then
            exit(true);

        // Segundo: identificar por descripción que contenga 'Beneficio' (OP 2)
        BeneficioLine.Reset();
        BeneficioLine.SetRange("Item No", Item."No.");
        BeneficioLine.SetRange("BOM Version", 0);
        if BeneficioLine.FindSet() then
            repeat
                if StrPos(LowerCase(BeneficioLine."Description Cost"), 'beneficio') > 0 then
                    exit(true);
            until BeneficioLine.Next() = 0;

        exit(false);
    end;

    local procedure CalculateFixedProfitValues()
    var
        BeneficioLine: Record "BOM Aditional Cost";
        TotalFixedCost: Decimal;
    begin
        // Obtener total de costes fijados (incluye todas las líneas)
        TotalFixedCost := AsmInfoPaneMgt.CalcAditionalFixedTotalCoste(Item."No.", 0);

        // Separar beneficio de costes generales
        if FindBeneficioLine(BeneficioLine) then begin
            FixedProfitValue := BeneficioLine."Aditional fixed cost";
            FixedGeneralCostsValue := TotalFixedCost - FixedProfitValue;
        end else begin
            FixedProfitValue := 0;
            FixedGeneralCostsValue := TotalFixedCost;
        end;

        // Calcular % beneficio sobre (Coste LM + Costes Generales)
        if (FixedGeneralCostsValue + Item.Receta_CosteLMFijado) <> 0 then
            FixedProfitPctValue := Round((FixedProfitValue / (FixedGeneralCostsValue + Item.Receta_CosteLMFijado) * 100), 0.01)
        else
            FixedProfitPctValue := 0;
    end;

    local procedure CalculateProductProfitValues()
    var
        BeneficioLine: Record "BOM Aditional Cost";
        TotalProductCosts: Decimal;
        BOMCost: Decimal;
    begin
        BOMCost := AsmInfoPaneMgt.CalcItemCosteCalculado(Item, true);
        TotalProductCosts := AsmInfoPaneMgt.CalcAditionalUnitTotalCosteReceta(Item."No.", 0, true);

        // Separar beneficio de costes generales
        if FindBeneficioLine(BeneficioLine) then begin
            ProductProfitValue := AsmInfoPaneMgt.CalcAditionalUnitCoste(BeneficioLine, true);
            ProductGeneralCostsValue := TotalProductCosts - ProductProfitValue;
        end else begin
            ProductProfitValue := 0;
            ProductGeneralCostsValue := TotalProductCosts;
        end;

        // Calcular % beneficio sobre (Coste LM Producto + Costes Generales Producto)
        if (ProductGeneralCostsValue + BOMCost) <> 0 then
            ProductProfitPctValue := Round((ProductProfitValue / (ProductGeneralCostsValue + BOMCost) * 100), 0.01)
        else
            ProductProfitPctValue := 0;
    end;

    local procedure GetProfitStyle(ProfitPct: Decimal): Text
    begin
        if ProfitPct <= 15 then
            exit('Unfavorable');
        if ProfitPct <= 25 then
            exit('Ambiguous');
        exit('Favorable');
    end;
}
