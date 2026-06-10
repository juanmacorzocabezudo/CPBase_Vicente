codeunit 60006 "CP Price List Filter Helper"
{
    SingleInstance = true;

    var
        PendingItemFilter: Text;
        HasPendingFilter: Boolean;

    procedure SetPendingItemFilter(ItemFilter: Text)
    begin
        PendingItemFilter := ItemFilter;
        HasPendingFilter := true;
    end;

    procedure GetAndClearPendingItemFilter(var ItemFilter: Text): Boolean
    begin
        if HasPendingFilter then begin
            ItemFilter := PendingItemFilter;
            PendingItemFilter := '';
            HasPendingFilter := false;
            exit(true);
        end;
        exit(false);
    end;
}
