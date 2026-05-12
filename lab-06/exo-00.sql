-- Setup Lab 6 - Tables and initial data
DROP TABLE factures CASCADE CONSTRAINTS;
DROP TABLE projets CASCADE CONSTRAINTS;
DROP TABLE consultants CASCADE CONSTRAINTS;
DROP TABLE clients CASCADE CONSTRAINTS;
DROP TABLE grille_tarifaire CASCADE CONSTRAINTS;
DROP TABLE logs_erreurs CASCADE CONSTRAINTS;

-- CLIENTS
CREATE TABLE clients (
 client_id NUMBER(6) PRIMARY KEY,
 nom VARCHAR2(60) NOT NULL,
 secteur VARCHAR2(30),
 solde NUMBER(12,2) DEFAULT 0
);

-- CONSULTANTS
CREATE TABLE consultants (
 cons_id NUMBER(6) PRIMARY KEY,
 nom VARCHAR2(60) NOT NULL,
 specialite VARCHAR2(40),
 tarif_jour NUMBER(8,2) NOT NULL,
 disponible CHAR(1) DEFAULT 'O' CHECK(disponible IN ('O','N'))
);

-- PROJETS
CREATE TABLE projets (
 proj_id NUMBER(6) PRIMARY KEY,
 client_id NUMBER(6) REFERENCES clients(client_id),
 cons_id NUMBER(6) REFERENCES consultants(cons_id),
 titre VARCHAR2(100) NOT NULL,
 date_debut DATE DEFAULT SYSDATE,
 nb_jours NUMBER(4) NOT NULL,
 statut VARCHAR2(20) DEFAULT 'EN_COURS'
);

-- FACTURES (alimentées par procédures)
CREATE TABLE factures (
 fact_id NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 proj_id NUMBER(6) REFERENCES projets(proj_id),
 montant_ht NUMBER(12,2),
 tva NUMBER(5,2) DEFAULT 0.20,
 montant_ttc NUMBER(12,2),
 date_fact DATE DEFAULT SYSDATE
);

-- GRILLE TARIFAIRE
CREATE TABLE grille_tarifaire (
 niveau VARCHAR2(20) PRIMARY KEY,
 tarif_min NUMBER(8,2),
 tarif_max NUMBER(8,2)
);

-- LOGS ERREURS (alimenté par les blocs EXCEPTION)
CREATE TABLE logs_erreurs (
 log_id NUMBER(8) GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
 code_err NUMBER,
 message_err VARCHAR2(300),
 contexte VARCHAR2(100),
 log_date DATE DEFAULT SYSDATE
);

-- Données initiales
INSERT INTO clients VALUES (1, 'Maroc Telecom', 'Télécom', 0);
INSERT INTO clients VALUES (2, 'OCP Group', 'Industrie', 0);
INSERT INTO clients VALUES (3, 'Attijariwafa Bank', 'Finance', 0);

INSERT INTO consultants VALUES (1, 'Karim Alaoui', 'Oracle DBA', 1800, 'O');
INSERT INTO consultants VALUES (2, 'Sara Idrissi', 'Java EE', 1500, 'O');
INSERT INTO consultants VALUES (3, 'Omar Tazi', 'BI & Analytics', 2000, 'N');
INSERT INTO consultants VALUES (4, 'Nadia Haddad', 'DevOps', 1600, 'O');

INSERT INTO projets VALUES (1, 1, 1, 'Migration Oracle 19c', SYSDATE, 15, 'EN_COURS');
INSERT INTO projets VALUES (2, 2, 2, 'Refonte SI RH', SYSDATE, 30, 'EN_COURS');
INSERT INTO projets VALUES (3, 3, 4, 'Pipeline CI/CD', SYSDATE, 10, 'TERMINE');

INSERT INTO grille_tarifaire VALUES ('JUNIOR', 800, 1299);
INSERT INTO grille_tarifaire VALUES ('CONFIRME', 1300, 1799);
INSERT INTO grille_tarifaire VALUES ('SENIOR', 1800, 2500);

COMMIT;
DBMS_OUTPUT.PUT_LINE('==> Tables créées avec succès.');
/
