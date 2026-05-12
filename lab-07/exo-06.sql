-- Sequences: Basic usage
CREATE SEQUENCE seq_commandes
  START WITH 2000
  INCREMENT BY 1
  NOCYCLE
  CACHE 5;

CREATE SEQUENCE seq_lignes
  START WITH 100
  INCREMENT BY 1
  NOCYCLE
  NOCACHE;

-- Obtenir les premières valeurs
SELECT seq_commandes.NEXTVAL AS next_cmd FROM DUAL;
SELECT seq_commandes.NEXTVAL AS next_cmd FROM DUAL;
SELECT seq_commandes.CURRVAL AS curr_cmd FROM DUAL;

-- Utiliser dans un INSERT
INSERT INTO commandes(cmd_id, client_id, statut)
VALUES(seq_commandes.NEXTVAL, 4, 'OUVERTE');

INSERT INTO lignes_commande(ligne_id, cmd_id, prod_id, qte, prix_unit)
VALUES(seq_lignes.NEXTVAL, seq_commandes.CURRVAL, 7, 2, 1800);

COMMIT;

-- Observer les valeurs
SELECT cmd_id, client_id, statut FROM commandes ORDER BY cmd_id;
SELECT ligne_id, cmd_id, prod_id FROM lignes_commande ORDER BY ligne_id;

-- Simuler un gap : ROLLBACK après NEXTVAL
DECLARE v_n NUMBER; 
BEGIN
  v_n := seq_lignes.NEXTVAL;
  DBMS_OUTPUT.PUT_LINE('Valeur consommée : ' || v_n);
  ROLLBACK;  -- la valeur est PERDUE
END;
/

SELECT seq_lignes.NEXTVAL FROM DUAL;  -- saut visible ici

-- Dictionnaire
SELECT sequence_name, min_value, max_value, increment_by, cycle_flag, cache_size, 
last_number
FROM user_sequences WHERE sequence_name LIKE 'SEQ_%';
/
