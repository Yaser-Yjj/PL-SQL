-- Exercise 2: SELECT INTO with multiple columns - Product info
DECLARE
   v_libelle  produits.libelle%TYPE;
   v_prix     produits.prix%TYPE;
   v_stock    produits.stock%TYPE;
BEGIN
   SELECT libelle, prix, stock 
     INTO v_libelle, v_prix, v_stock 
     FROM produits 
    WHERE prod_id = 1;
   DBMS_OUTPUT.PUT_LINE('Produit : ' || v_libelle || ' | Prix : ' || v_prix || ' MAD' || ' | Stock : ' || v_stock || ' unités');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Produit introuvable !');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/
