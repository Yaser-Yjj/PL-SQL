-- SELECT INTO with ROWTYPE
declare 
v_emp employes%ROWTYPE;
begin 

select * into v_emp from employes where emp_id < 10;
DBMS_OUTPUT.PUT_LINE(v_emp.emp_id);
end;
/
