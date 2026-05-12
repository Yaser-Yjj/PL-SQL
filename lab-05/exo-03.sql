-- SELECT INTO with exception handling
set serveroutput on;
declare 
    v_client_id clients.client_id%type := 1;
    r_client clients%rowtype;
begin
    select * into r_client from clients where client_id = v_client_id;
    dbms_output.put_line('Client Name: ' || r_client.nom);
exception 
    when no_data_found then
        dbms_output.put_line('No client found with ID ' || v_client_id);
    when too_many_rows then
        dbms_output.put_line('Multiple clients found with ID ' || v_client_id);
    when others then
        dbms_output.put_line('An error occurred: ' || sqlerrm);
end;
/
