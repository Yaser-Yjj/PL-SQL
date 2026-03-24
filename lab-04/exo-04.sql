DECLARE
  CURSOR c_ventes IS
    SELECT e.emp_id, e.nom, e.salaire, d.nom_dept
    FROM employes e
    JOIN departements d ON e.dept_id = d.dept_id
    WHERE e.dept_id = 30
    ORDER BY e.nom;

  TYPE t_ligne IS RECORD (
    emp_id employes.emp_id%TYPE,
    nom employes.nom%TYPE,
    salaire employes.salaire%TYPE,
    nom_dept departements.nom_dept%TYPE
  );

  v_ligne t_ligne;
  v_prime NUMBER;
  v_total_primes NUMBER := 0;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Prime Equipe Vente (15%)');
  
  OPEN c_ventes;
  LOOP
    FETCH c_ventes INTO v_ligne;
    EXIT WHEN c_ventes%NOTFOUND;
    
    v_prime := ROUND(v_ligne.salaire * 0.15, 2);
    v_total_primes := v_total_primes + v_prime;
    
    DBMS_OUTPUT.PUT_LINE(
      v_ligne.nom || ' | Salaire : ' || v_ligne.salaire
      || ' | Prime : ' || v_prime || ' MAD'
    );
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Nb employes traite : ' || c_ventes%ROWCOUNT);
  DBMS_OUTPUT.PUT_LINE('Total primes : ' || v_total_primes || ' MAD');
  CLOSE c_ventes;
END;
/