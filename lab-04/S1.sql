DECLARE
  v_nb_actif NUMBER := 0;
  v_nb_premium NUMBER := 0;
  v_nb_inactif NUMBER := 0;
  v_commentaire VARCHAR2(30);
BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));
  DBMS_OUTPUT.PUT_LINE(' RAPPORT CLIENTS');
  DBMS_OUTPUT.PUT_LINE(RPAD('=', 60, '='));

  FOR c IN (SELECT nom, statut, solde FROM clients ORDER BY statut, nom) LOOP
    
    v_commentaire := CASE c.statut
      WHEN 'PREMIUM' THEN ' Client VIP' 
      WHEN 'ACTIF'   THEN ' Client normal' 
      WHEN 'INACTIF' THEN ' Compte inactif' 
      ELSE '? Inconnu'
    END;

    DBMS_OUTPUT.PUT_LINE(
      RPAD(c.nom, 20) || ' | ' || RPAD(c.statut, 10) || ' | ' 
      || LPAD(c.solde, 6) || ' MAD | ' || v_commentaire
    );

    IF c.statut = 'PREMIUM' THEN 
      v_nb_premium := v_nb_premium + 1;
    ELSIF c.statut = 'ACTIF' THEN 
      v_nb_actif := v_nb_actif + 1;
    ELSIF c.statut = 'INACTIF' THEN 
      v_nb_inactif := v_nb_inactif + 1;
    END IF;
    
  END LOOP;

  DBMS_OUTPUT.PUT_LINE(RPAD('-', 60, '-'));
  DBMS_OUTPUT.PUT_LINE('PREMIUM : ' || v_nb_premium
    || ' ACTIF : ' || v_nb_actif
    || ' INACTIF : ' || v_nb_inactif);
END;
/