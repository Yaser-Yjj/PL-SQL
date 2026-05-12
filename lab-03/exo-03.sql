-- Exercise 3: Using ROWTYPE - Product sheet with calculations
DECLARE
   v_prod   produits%ROWTYPE;
   v_tva    NUMBER := 0.20;  -- TVA 20%
   v_ttc    NUMBER;
BEGIN
   SELECT *
     INTO v_prod
     FROM produits
    WHERE prod_id = 1;  -- Laptop HP
   v_ttc := v_prod.prix * (1 + v_tva);
   DBMS_OUTPUT.PUT_LINE('=== Fiche Produit ===');
   DBMS_OUTPUT.PUT_LINE('Libellé   : ' || v_prod.libelle);
   DBMS_OUTPUT.PUT_LINE('Catégorie : ' || v_prod.categorie);
   DBMS_OUTPUT.PUT_LINE('Prix HT   : ' || v_prod.prix || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Prix TTC  : ' || ROUND(v_ttc, 2) || ' MAD');
   DBMS_OUTPUT.PUT_LINE('Stock     : ' || v_prod.stock || ' unités');
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('Produit introuvable !');
END;
/
