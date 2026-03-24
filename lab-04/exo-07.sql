DECLARE
  CURSOR c_filtrer (p_dept_id NUMBER, p_poste VARCHAR2) IS
    SELECT e.nom, e.salaire, d.nom_dept
    FROM employes e
    JOIN departements d ON e.dept_id = d.dept_id
    WHERE e.dept_id = p_dept_id
      AND (p_poste IS NULL OR e.poste = p_poste)
    ORDER BY e.salaire DESC;
  v_nb NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE(' Développeurs — Dept Informatique ');
  v_nb := 0;
  FOR rec IN c_filtrer(10, 'Développeur') LOOP
    DBMS_OUTPUT.PUT_LINE(' ' || rec.nom || ' : ' || rec.salaire || ' MAD');
    v_nb := v_nb + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' Total : ' || v_nb || ' développeur(s)');
  DBMS_OUTPUT.PUT_LINE('');

  DBMS_OUTPUT.PUT_LINE(' Tous les employés — Dept Ventes ');
  v_nb := 0;
  FOR rec IN c_filtrer(30, NULL) LOOP
    DBMS_OUTPUT.PUT_LINE(' ' || rec.nom || ' : ' || rec.salaire || ' MAD');
    v_nb := v_nb + 1;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(' Total : ' || v_nb || ' employé(s)');
END;
/