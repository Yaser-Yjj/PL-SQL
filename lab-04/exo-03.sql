DECLARE
  CURSOR c_employes IS
    SELECT emp_id, nom, poste, salaire
    FROM employes
    ORDER BY salaire DESC;

  v_emp_id employes.emp_id%TYPE;
  v_nom employes.nom%TYPE;
  v_poste employes.poste%TYPE;
  v_salaire employes.salaire%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 55, '='));
  DBMS_OUTPUT.PUT_LINE(' LISTE DES EMPLOYÉS (ordre salaire décroissant)');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 55, '='));
  DBMS_OUTPUT.PUT_LINE(RPAD('NOM', 22) || RPAD('POSTE', 18) || 'SALAIRE');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));

  OPEN c_employes;
  LOOP
    FETCH c_employes INTO v_emp_id, v_nom, v_poste, v_salaire;
    EXIT WHEN c_employes%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE(
      RPAD(v_nom, 22) || RPAD(v_poste, 18) || v_salaire || ' MAD'
    );
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(RPAD('-', 55, '-'));
  DBMS_OUTPUT.PUT_LINE('Total lignes lues : ' || c_employes%ROWCOUNT);
  CLOSE c_employes;
END;
/