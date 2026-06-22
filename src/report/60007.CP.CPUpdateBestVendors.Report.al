report 60007 "CP Update Best Vendors"
{
    Caption = 'Update Best Vendors';
    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(PriceListLine; "Price List Line")
        {
            DataItemTableView = where("Price Type" = const(Purchase),
                                      "Source Type" = const(Vendor),
                                      "Asset Type" = const(Item),
                                      "Best Vendor" = const(true),
                                      Status = const(Active));

            trigger OnPreDataItem()
            begin
                ProcessedItems := 0;
                UpdatedItems := 0;
                ErrorItems := 0;
                ProgressWindow.Open(ProcessingMsg);
            end;

            trigger OnAfterGetRecord()
            var
                Item: Record Item;
            begin
                ProcessedItems += 1;
                ProgressWindow.Update(1, PriceListLine."Asset No.");
                ProgressWindow.Update(2, ProcessedItems);

                if PriceListLine."Asset No." = '' then
                    exit;

                if PriceListLine."Source No." = '' then
                    exit;

                if not Item.Get(PriceListLine."Asset No.") then begin
                    ErrorItems += 1;
                    LogError(PriceListLine."Asset No.", ItemNotFoundErr);
                    exit;
                end;

                if Item."Vendor No." <> PriceListLine."Source No." then
                    if not TryUpdateItemVendor(Item, PriceListLine."Source No.") then begin
                        ErrorItems += 1;
                        LogError(Item."No.", GetLastErrorText());
                    end else
                        UpdatedItems += 1;
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.Close();
                Message(CompletedMsg, UpdatedItems, ProcessedItems, ErrorItems);

                if ErrorLog <> '' then
                    Message(ErrorLogMsg, ErrorLog);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(ShowErrors; ShowErrorDetails)
                    {
                        ApplicationArea = All;
                        Caption = 'Show Error Details';
                        ToolTip = 'Show detailed error messages if any item update fails.';
                    }
                }
                group(Information)
                {
                    Caption = 'Information';

                    field(InfoText; InfoTextLbl)
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ShowCaption = false;
                        MultiLine = true;
                        Style = StrongAccent;
                        StyleExpr = true;
                    }
                }
            }
        }
    }

    [TryFunction]
    local procedure TryUpdateItemVendor(var Item: Record Item; VendorNo: Code[20])
    begin
        Item.Validate("Vendor No.", VendorNo);
        Item.Modify(true);
    end;

    local procedure LogError(ItemNo: Code[20]; ErrorText: Text)
    begin
        if ShowErrorDetails then begin
            if ErrorLog <> '' then
                ErrorLog += '\';
            ErrorLog += StrSubstNo(ErrorItemLbl, ItemNo, ErrorText);
        end;
    end;

    var
        ProgressWindow: Dialog;
        ErrorLog: Text;
        ShowErrorDetails: Boolean;
        ProcessedItems: Integer;
        UpdatedItems: Integer;
        ErrorItems: Integer;
        ProcessingMsg: Label 'Processing items...\Item No.: #1################\Processed: #2######', Comment = '#1 = Item No., #2 = Processed count';
        CompletedMsg: Label 'Process completed.\Updated items: %1\Processed items: %2\Errors: %3', Comment = '%1 = Updated items, %2 = Processed items, %3 = Errors';
        ErrorLogMsg: Label 'Errors occurred during processing:\%1', Comment = '%1 = Error log';
        ErrorItemLbl: Label 'Item %1: %2', Comment = '%1 = Item No., %2 = Error text';
        ItemNotFoundErr: Label 'Item not found';
        InfoTextLbl: Label 'This process will update the Vendor No. field in the Item table for all items that have a Best Vendor defined in active purchase price lists.\Only items where the current Vendor No. differs from the Best Vendor will be updated.';
}
