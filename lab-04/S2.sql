DECLARE
  CURSOR c_produits_cat (p_categorie VARCHAR2) IS
    SELECT prod_id, libelle, prix, stock
    FROM produits
    WHERE categorie = p_categorie
    FOR UPDATE OF prix NOWAIT;
    
  v_taux NUMBER;
  v_nouveau NUMBER;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Revalorisation INFORMATIQUE');
  
  FOR p IN c_produits_cat('INFORMATIQUE') LOOP
    
    IF p.stock < 10 THEN
      v_taux := 1.15; 
    ELSE
      v_taux := 1.05; 
    END IF;
    
    v_nouveau := ROUND(p.prix * v_taux, 2);

    UPDATE produits
    SET prix = v_nouveau
    WHERE CURRENT OF c_produits_cat;

    DBMS_OUTPUT.PUT_LINE(
      p.libelle || ' (Stock: ' || p.stock || ') : ' || p.prix 
      || ' → ' || v_nouveau || ' MAD'
    );
  END LOOP;
  
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Mise à jour terminée avec succès.');
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/