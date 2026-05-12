-- Combined Exercise: Indexes, Views, MV, and Synonyms
-- Index sur fournisseur pour accélérer la vue
CREATE INDEX idx_prod_fourn ON produits(fourn_id);

-- Vue détaillée des produits avec fournisseur
CREATE OR REPLACE VIEW v_prod_fourn AS
  SELECT p.prod_id, p.libelle, p.prix_ht, p.stock,
         f.nom AS fournisseur, f.pays,
         cat.libelle AS categorie
  FROM produits p
  JOIN fournisseurs f ON p.fourn_id = f.fourn_id
  JOIN categories cat ON p.cat_id   = cat.cat_id
  WHERE f.actif = 'O'
  WITH READ ONLY;

-- Vue matérialisée : résumé par fournisseur actif
CREATE MATERIALIZED VIEW mv_resume_fourn
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS
  SELECT fournisseur, pays,
         COUNT(prod_id) AS nb_produits,
         SUM(stock * prix_ht) AS valeur_stock_totale
  FROM v_prod_fourn
  GROUP BY fournisseur, pays;

-- Synonyme pointant vers la vue matérialisée
CREATE SYNONYM resume_fourn FOR mv_resume_fourn;

-- Accès simplifié via le synonyme
SELECT * FROM resume_fourn ORDER BY valeur_stock_totale DESC;

-- Simuler une mise à jour : nouveau produit chez fournisseur 1
INSERT INTO produits VALUES(9, 'Écran 27 pouces', 1, 1, 4500, 12);
COMMIT;

-- La MV n'est pas encore à jour
SELECT * FROM resume_fourn;

-- Rafraîchir
EXEC DBMS_MVIEW.REFRESH('MV_RESUME_FOURN', 'C');
SELECT * FROM resume_fourn;

-- Inventaire complet des objets créés dans ce lab
SELECT object_name, object_type, status
FROM user_objects
WHERE object_type IN ('VIEW','MATERIALIZED VIEW','SEQUENCE','INDEX','SYNONYM')
ORDER BY object_type, object_name;
/
