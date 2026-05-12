-- Internal exception definition (pragma)
set serveroutput on;
declare e_dept_avec_emp exception;
pragma exception_init(e_dept_avec_emp, -2292);
v_dept_id departements.dept_id%type := 10;
begin
    dbms_output.put_line('Attempting to delete department with ID ' || v_dept_id);
    delete from departements where dept_id = v_dept_id;
    dbms_output.put_line('Department deleted successfully');
exception
    when e_dept_avec_emp then
        dbms_output.put_line('Cannot delete department with ID ' || v_dept_id || ' because it has employees.');
    when others then
        dbms_output.put_line('An error occurred: ' || sqlerrm);
end;
/
