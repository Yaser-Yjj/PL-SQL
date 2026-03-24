DECLARE
  v_dept_id NUMBER := 10;
  v_taux NUMBER := 1.10; -- +10%
BEGIN
  UPDATE employes
  SET salaire = salaire * v_taux
  WHERE dept_id = v_dept_id;

  IF SQL%NOTFOUND THEN
    DBMS_OUTPUT.PUT_LINE('Aucun employé trouvé dans le département ' || v_dept_id);
  ELSE
    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' employé(s) du département ' || v_dept_id || ' augmenté(s) de 10%.');
  END IF;

  COMMIT;
END;
/