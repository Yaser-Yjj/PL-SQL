-- Views: Revenue by category and top suppliers
CREATE OR REPLACE VIEW v_ca_categorie AS
SELECT 
    cat.cat_id,
    cat.libelle        AS categorie,
    cat.rayon,
    COUNT(DISTINCT lc.cmd_id)    AS nb_commandes,
    SUM(lc.qte * lc.prix_unit)  AS ca_ht,
    ROUND(AVG(lc.prix_unit), 2) AS prix_moyen
FROM categories cat
JOIN produits p        ON p.cat_id  = cat.cat_id
JOIN lignes_commande lc ON lc.prod_id = p.prod_id
GROUP BY cat.cat_id, cat.libelle, cat.rayon
HAVING SUM(lc.qte * lc.prix_unit) > 0;

-- Utiliser la vue
SELECT * FROM v_ca_categorie ORDER BY ca_ht DESC;

-- Vue : top fournisseurs actifs
CREATE OR REPLACE VIEW v_top_fournisseurs AS
SELECT 
    f.fourn_id,
    f.nom   AS fournisseur,
    f.pays,
    COUNT(p.prod_id)           AS nb_produits,
    SUM(p.stock * p.prix_ht)   AS valeur_stock
FROM fournisseurs f 
JOIN produits p ON p.fourn_id = f.fourn_id
WHERE f.actif = 'O' 
GROUP BY f.fourn_id, f.nom, f.pays
ORDER BY valeur_stock DESC;

SELECT * FROM v_top_fournisseurs;
/
