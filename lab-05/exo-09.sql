-- Package declaration
create or replace package gestion_employes is
    procedure augmenter_salaire(p_empno in number, p_montant in number);
    function revenue_annuel(salaire in number, p_comm in number default 0) return number;
end gestion_employes;
/

-- Package body implementation
create or replace package body gestion_employes is
    procedure augmenter_salaire(p_empno in number, p_montant in number) is
    begin
        update EMPLOYES set SALAIRE = SALAIRE + p_montant where EMP_ID = p_empno;
        if sql%notfound then 
            dbms_output.put_line('Employe ' || p_empno || ' non trouve');
        else
            dbms_output.put_line('Salaire mis a jour pour employe ' || p_empno);
        end if;
        commit;
    end augmenter_salaire;

    function revenue_annuel(salaire in number, p_comm in number default 0) return number is
    begin
        return (salaire + nvl(p_comm, 0)) * 12;
    end revenue_annuel;
end gestion_employes;
/
