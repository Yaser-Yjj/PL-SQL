-- Function creation and invocation
create or replace function revenue_annuel(salaire in number, p_comm in number default 0) return number is
begin
    return (salaire + nvl(p_comm, 0)) * 12;
end revenue_annuel;
/

-- Query using the function
select emp_id, salaire, revenue_annuel(salaire) as revenu_annuel from employes;

-- Invocation in PL/SQL block
declare v_total number;
begin
    v_total := revenue_annuel(3000, 500);
    dbms_output.put_line('Revenu annuel: ' || v_total);
end;
/
