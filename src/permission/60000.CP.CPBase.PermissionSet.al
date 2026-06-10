permissionset 60000 "CP Base"
{
    Assignable = true;
    Caption = 'Comidas Populares Base';

    Permissions =
        table "CP Recipe Price Fluctuation" = X,
        table "CP Recipe Fluctuation Setup" = X,
        table "Fluctuation Recipient" = X,
        tabledata "CP Recipe Price Fluctuation" = RIMD,
        tabledata "CP Recipe Fluctuation Setup" = RIMD,
        tabledata "Fluctuation Recipient" = RIMD,
        codeunit "Table Events" = X,
        codeunit "Item Management" = X,
        codeunit "CP Price List Filter Helper" = X,
        codeunit "CP Recipe Fluctuation Mgt" = X,
        codeunit "CP Recipe Fluctuation Install" = X,
        codeunit "Assembly Elaboration Events" = X,
        page "Event Type List" = X,
        page "Event Type Card" = X,
        page "WS Purchase Prices" = X,
        page "WS Products" = X,
        page "WS Item Ledger Entries" = X,
        page "CP BOM Aditional Cost" = X,
        page "CP Recipe Price Fluctuation L." = X,
        page "CP Recipe Fluctuation Setup" = X,
        page "Fluctuation Recipients" = X,
        report "Receip Part" = X,
        report "Event Components" = X,
        report "Event Budget" = X,
        report "CP Production Part" = X;
}
