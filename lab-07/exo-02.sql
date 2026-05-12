-- Complex view with multiple tables (non-modifiable - WITH READ ONLY)
CREATE OR REPLACE VIEW v_detail_commandes AS
 SELECT
    c.cmd_id,
    cl.nom            AS client,
    cl.segment,
    c.date_cmd,
    c.statut,
    p.libelle         AS produit,
    cat.libelle       AS categorie,
    lc.qte,
    lc.prix_unit,
    ROUND(lc.qte * lc.prix_unit, 2) AS montant_ligne
  FROM commandes c
  JOIN clients cl          ON c.client_id  = cl.client_id
  JOIN lignes_commande lc  ON lc.cmd_id    = c.cmd_id
  JOIN produits p          ON lc.prod_id   = p.prod_id
  JOIN categories cat      ON p.cat_id     = cat.cat_id
  WITH READ ONLY;

-- Utiliser la vue comme une table
SELECT * FROM v_detail_commandes ORDER BY cmd_id, produit;

-- Calculer le total par commande via la vue
SELECT cmd_id, client, SUM(montant_ligne) AS total_cmd
FROM v_detail_commandes
GROUP BY cmd_id, client
ORDER BY total_cmd DESC;

-- Tenter un UPDATE => doit échouer (WITH READ ONLY)
UPDATE v_detail_commandes SET qte = 10 WHERE cmd_id = 1001;
/
