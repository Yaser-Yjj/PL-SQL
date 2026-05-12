-- Error interception with SQLCODE and SQLERRM
set serveroutput on;
declare 
    v_error_code number;
    v_error_message varchar2(4000);
begin 
    insert into clients (client_id, nom, email, solde, statut) values (10, 'rihab', 'rihab@example.com', 1000, 'active');
    commit;
    dbms_output.put_line('Client inserted successfully');
exception
    when others then
        v_error_code := sqlcode;
        v_error_message := sqlerrm;
        dbms_output.put_line('Code Oracle: ' || v_error_code|| ' Message: ' || v_error_message );
        rollback;
end;
/
