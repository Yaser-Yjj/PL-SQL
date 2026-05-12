-- Exercise 5: INSERT with SQL%ROWCOUNT
BEGIN
   INSERT INTO clients (nom, email, solde, statut)
   VALUES ('Karim Mansouri', 'karim@mail.ma', 800, 'ACTIF');
   DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' ligne(s) insérée(s).');
   COMMIT;
END;
/
