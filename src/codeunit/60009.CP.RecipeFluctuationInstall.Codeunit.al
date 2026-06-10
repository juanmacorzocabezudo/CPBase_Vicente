codeunit 60009 "CP Recipe Fluctuation Install"
{
    Subtype = Install;

    trigger OnInstallAppPerCompany()
    var
        Setup: Record "CP Recipe Fluctuation Setup";
        RecipeFluctuationMgt: Codeunit "CP Recipe Fluctuation Mgt";
    begin
        // Crear configuración con valores por defecto
        if not Setup.Get() then begin
            Setup.Init();
            Setup."PT Email Recipients" := 'produccion@comidaspopulares.com;administracion@comidaspopulares.com';
            Setup."CA Email Recipients" := 'info@comidaspopulares.com;gestion@comidaspopulares.com';
            Setup.Insert();
        end;

        // Migrate old text fields to new recipient table
        MigrateRecipientsFromSetup();

        // Crear entradas iniciales para todas las recetas no bloqueadas
        RecipeFluctuationMgt.CreateInitialEntries();
    end;

    local procedure MigrateRecipientsFromSetup()
    var
        Setup: Record "CP Recipe Fluctuation Setup";
        Recipient: Record "Fluctuation Recipient";
    begin
        // Only migrate if no recipients exist yet (first install or upgrade)
        if not Recipient.IsEmpty() then
            exit;

        if not Setup.Get() then
            exit;

        // Migrate PT recipients
        if Setup."PT Email Recipients" <> '' then
            CreateRecipientsFromText(Setup."PT Email Recipients", "Fluctuation Recipient Type"::PT);

        // Migrate CA recipients
        if Setup."CA Email Recipients" <> '' then
            CreateRecipientsFromText(Setup."CA Email Recipients", "Fluctuation Recipient Type"::CA);

        // Migrate Error recipients
        if Setup."Error Email Recipients" <> '' then
            CreateRecipientsFromText(Setup."Error Email Recipients", "Fluctuation Recipient Type"::Error);
    end;

    local procedure CreateRecipientsFromText(EmailText: Text; RecipientType: Enum "Fluctuation Recipient Type")
    var
        Recipient: Record "Fluctuation Recipient";
        EmailList: List of [Text];
        EmailAddress: Text;
    begin
        EmailList := EmailText.Split(';');
        foreach EmailAddress in EmailList do begin
            EmailAddress := EmailAddress.Trim();
            if EmailAddress <> '' then begin
                Recipient.Init();
                Recipient."Entry No." := 0;
                Recipient."Email Address" := CopyStr(EmailAddress, 1, MaxStrLen(Recipient."Email Address"));
                Recipient."Recipient Type" := RecipientType;
                Recipient."Include Costs" := true;
                Recipient.Insert(true);
            end;
        end;
    end;
}
