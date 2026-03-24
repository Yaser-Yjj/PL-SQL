DECLARE
  CURSOR c_depts_riches IS
    SELECT d.nom_dept,
           COUNT(e.emp_id) AS nb_employes,
           ROUND(AVG(e.salaire),0) AS salaire_moy
    FROM departements d
    JOIN employes e ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.nom_dept
    HAVING AVG(e.salaire) > (
      SELECT AVG(salaire) FROM employes 
    )
    ORDER BY salaire_moy DESC;
    
  v_moy_globale NUMBER;
BEGIN
  SELECT ROUND(AVG(salaire), 0) INTO v_moy_globale FROM employes;
  
  DBMS_OUTPUT.PUT_LINE('Moyenne globale entreprise : ' || v_moy_globale || ' MAD');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 50, '='));
  DBMS_OUTPUT.PUT_LINE('Départements AU-DESSUS de la moyenne :');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 50, '-'));
  
  FOR d IN c_depts_riches LOOP
    DBMS_OUTPUT.PUT_LINE(
      RPAD(d.nom_dept, 18)
      || ' | Employés : ' || d.nb_employes
      || ' | Moy : ' || d.salaire_moy || ' MAD'
    );
  END LOOP;
END;
/