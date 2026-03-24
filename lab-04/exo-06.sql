DECLARE
  CURSOR c_depts IS
    SELECT dept_id, nom_dept FROM departements ORDER BY dept_id;
  v_moy_sal NUMBER;
  v_nb_emp NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));
  DBMS_OUTPUT.PUT_LINE(' RAPPORT PAR DÉPARTEMENT');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));

  FOR d IN c_depts LOOP
    SELECT COUNT(*), NVL(AVG(salaire), 0)
    INTO v_nb_emp, v_moy_sal
    FROM employes
    WHERE dept_id = d.dept_id;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Departement :' || d.nom_dept || ' (ID: ' || d.dept_id || ')');
    DBMS_OUTPUT.PUT_LINE(' Employés : ' || v_nb_emp
      || ' | Salaire moyen : ' || ROUND(v_moy_sal, 0) || ' MAD');
    DBMS_OUTPUT.PUT_LINE(' ' || RPAD('-', 40, '-'));

    FOR e IN (SELECT nom, poste, salaire FROM employes
              WHERE dept_id = d.dept_id ORDER BY salaire DESC) LOOP
      DBMS_OUTPUT.PUT_LINE(
        '   ' || RPAD(e.nom, 22) || RPAD(e.poste, 15) || e.salaire || ' MAD'
      );
    END LOOP;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));
END;
/