-- Synonyms: Create and use
CREATE SYNONYM prod  FOR produits;
CREATE SYNONYM cmd   FOR commandes;
CREATE SYNONYM lc    FOR lignes_commande;
CREATE SYNONYM cli   FOR clients;
CREATE SYNONYM cat   FOR categories;
CREATE SYNONYM mv_ca FOR mv_ventes_cat;

-- Utiliser les synonymes exactement comme les tables
SELECT prod_id, libelle, prix_ht FROM prod WHERE cat_id = 1;

-- Jointure avec synonymes
SELECT cli.nom AS client, cmd.cmd_id, cmd.statut
FROM cli
JOIN cmd ON cmd.client_id = cli.client_id
ORDER BY cli.nom;

-- Synonyme sur la vue matérialisée
SELECT * FROM mv_ca ORDER BY ca_total DESC;

-- Synonyme sur la séquence
CREATE SYNONYM s_cmd FOR seq_commandes;
SELECT s_cmd.NEXTVAL FROM DUAL;

-- Voir les synonymes dans le dictionnaire
SELECT synonym_name, table_name, table_owner
FROM user_synonyms
ORDER BY synonym_name;

-- Supprimer un synonyme (l'objet original reste intact)
DROP SYNONYM s_cmd;
SELECT seq_commandes.CURRVAL FROM DUAL;  -- fonctionne encore
/
