-- Procedure creation and invocation
create or replace procedure augmenter_salaire(p_empno in number, p_montant in number) is
begin
    update EMPLOYES set SALAIRE = SALAIRE + p_montant where EMP_ID = p_empno;
    if sql%notfound then 
        dbms_output.put_line('Employe ' || p_empno || ' non trouve');
    else
        dbms_output.put_line('Salaire mis a jour pour employe ' || p_empno);
    end if;
    commit;
end;
/

begin 
    augmenter_salaire(7902, 150);
    -- augmenter_salaire(p_montant => 150, p_empno => 7902);
end;
/
