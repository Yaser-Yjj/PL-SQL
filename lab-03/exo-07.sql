-- Exercise 7: INSERT with SQL%ROWCOUNT check
DECLARE
BEGIN
   INSERT INTO clients (nom, email, solde, statut)
   VALUES ('Youssef El Amrani', 'youssef@mail.ma', 1200, 'ACTIF');

   IF SQL%ROWCOUNT > 0 THEN
      DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' ligne(s) insérée(s) avec succès.');
   ELSE
      DBMS_OUTPUT.PUT_LINE('Aucune insertion effectuée.');
   END IF;

   COMMIT;

EXCEPTION
   WHEN OTHERS THEN
      ROLLBACK;
      DBMS_OUTPUT.PUT_LINE('Erreur : ' || SQLERRM);
END;
/
