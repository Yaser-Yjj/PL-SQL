-- Exercise 6: INSERT with stock verification and UPDATE
DECLARE
   v_client_id   NUMBER := 1;
   v_prod_id     NUMBER := 2;   -- Souris sans fil
   v_quantite    NUMBER := 3;
   v_stock       NUMBER;
   v_prix        NUMBER;
BEGIN
   -- Vérifier le stock disponible
   SELECT stock, prix
     INTO v_stock, v_prix
     FROM produits
    WHERE prod_id = v_prod_id;
   IF v_stock >= v_quantite THEN
      -- Insérer la commande
      INSERT INTO commandes (client_id, prod_id, quantite, statut)
      VALUES (v_client_id, v_prod_id, v_quantite, 'CONFIRMÉE');
      -- Mettre à jour le stock
      UPDATE produits
         SET stock = stock - v_quantite
       WHERE prod_id = v_prod_id;
      DBMS_OUTPUT.PUT_LINE('Commande créée. Total : '
         || (v_quantite * v_prix) || ' MAD');
      COMMIT;
   ELSE
      DBMS_OUTPUT.PUT_LINE('Stock insuffisant ! Disponible : ' || v_stock);
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/
