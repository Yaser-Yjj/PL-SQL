-- RAISE_APPLICATION_ERROR
set serveroutput on;
declare 
    v_date_embauche date := to_date('2026-04-12', 'yyyy-mm-dd');
begin 
    if to_char( v_date_embauche, 'D') in ('6', '7') then
        raise_application_error(-20001, 'La date d''embauche ne peut pas être un samedi ou un dimanche.');
    end if;
    dbms_output.put_line('Date d''embauche valide: ' || to_char(v_date_embauche, 'yyyy-mm-dd'));
end;
/
