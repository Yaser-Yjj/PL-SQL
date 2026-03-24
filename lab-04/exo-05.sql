DECLARE
  CURSOR c_clients IS
    SELECT client_id, nom, solde
    FROM clients
    WHERE statut = 'ACTIF'
    ORDER BY solde DESC;

  v_id clients.client_id%TYPE;
  v_nom clients.nom%TYPE;
  v_solde clients.solde%TYPE;
BEGIN

  IF NOT c_clients%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Curseur fermé → on l ouvre.');
    OPEN c_clients;
  END IF;

  IF c_clients%ISOPEN THEN
    DBMS_OUTPUT.PUT_LINE('Curseur ouvert : OUI');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Curseur ouvert : NON');
  END IF;

  LOOP
    FETCH c_clients INTO v_id, v_nom, v_solde;
    EXIT WHEN c_clients%NOTFOUND OR c_clients%ROWCOUNT > 3;
    
    DBMS_OUTPUT.PUT_LINE(
      'Rang ' || c_clients%ROWCOUNT || ' : '
      || v_nom || ' — ' || v_solde || ' MAD'
    );
  END LOOP;

  DBMS_OUTPUT.PUT_LINE('Lignes lues : ' || (c_clients%ROWCOUNT - 1));
  CLOSE c_clients;
 
  DBMS_OUTPUT.PUT_LINE('Curseur ouvert après CLOSE : ' || (CASE WHEN c_clients%ISOPEN = true THEN 'OUI' ELSE 'NON' END));


EXCEPTION
  WHEN OTHERS THEN
    IF c_clients%ISOPEN THEN
      CLOSE c_clients;
      DBMS_OUTPUT.PUT_LINE('Curseur fermé dans EXCEPTION.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/