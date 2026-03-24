DECLARE
  CURSOR c_emp10 IS
    SELECT emp_id, nom, salaire
    FROM employes
    WHERE dept_id = 10
    FOR UPDATE OF salaire NOWAIT;
    
  v_taux NUMBER;
  v_nb_8pct NUMBER := 0;
  v_nb_5pct NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Augmentation Dept Informatique');
  
  FOR emp IN c_emp10 LOOP
    IF emp.salaire < 8000 THEN
      v_taux := 1.08;
      v_nb_8pct := v_nb_8pct + 1;
    ELSE
      v_taux := 1.05;
      v_nb_5pct := v_nb_5pct + 1;
    END IF;

    UPDATE employes
    SET salaire = ROUND(emp.salaire * v_taux, 2)
    WHERE CURRENT OF c_emp10;

    DBMS_OUTPUT.PUT_LINE(
      emp.nom || ' : ' || emp.salaire || ' → '
      || ROUND(emp.salaire * v_taux, 2)
      || ' MAD (' || ROUND((v_taux-1)*100) || '% )'
    );
  END LOOP;
  COMMIT;

  DBMS_OUTPUT.PUT_LINE('---------------------------');
  DBMS_OUTPUT.PUT_LINE('Nbr d’employés Augmentés à +8% : ' || v_nb_8pct);
  DBMS_OUTPUT.PUT_LINE('Nbr d’employé Augmentés à +5% : ' || v_nb_5pct);

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erreur (ligne verrouillée ?) : ' || SQLERRM);
END;
/