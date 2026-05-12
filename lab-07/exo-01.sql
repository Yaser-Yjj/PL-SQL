-- View with CHECK OPTION (simple updatable view)
CREATE OR REPLACE VIEW v_produits_stock AS
  SELECT prod_id, libelle, prix_ht, stock, cat_id
  FROM produits
  WHERE stock > 0
  WITH CHECK OPTION CONSTRAINT chk_stock_positif;

-- Interroger la vue
SELECT * FROM v_produits_stock ORDER BY stock DESC;

-- Modifier via la vue (vue modifiable : 1 seule table)
UPDATE v_produits_stock SET prix_ht = 8800 WHERE prod_id = 1;
COMMIT;

-- Test WITH CHECK OPTION : tenter de mettre stock à 0
-- Doit échouer car la ligne sortirait de la vue (WHERE stock > 0)
UPDATE v_produits_stock SET stock = 0 WHERE prod_id = 3;

-- Vérifier l'état de la vue
SELECT * FROM v_produits_stock WHERE prod_id IN (1,3);

-- Consulter le dictionnaire
SELECT view_name, text_length FROM user_views WHERE view_name = 'V_PRODUITS_STOCK';
/
