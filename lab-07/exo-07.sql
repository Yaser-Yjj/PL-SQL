-- Sequences: Cyclic sequence with modification
CREATE SEQUENCE seq_codes_ref
    START WITH 1
    INCREMENT BY 1
    MINVALUE 1
    MAXVALUE 9999
    CYCLE
    NOCACHE;

-- Générer 5 valeurs et les formater sur 4 chiffres
BEGIN
    FOR i IN 1..5 LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Ref #' || i || ' : ' ||
            LPAD(seq_codes_ref.NEXTVAL, 4, '0')
        );
    END LOOP;
END;
/

-- Modifier la séquence : incrément de 10
ALTER SEQUENCE seq_codes_ref INCREMENT BY 10;

-- Vérifier la modification
SELECT sequence_name, increment_by, cycle_flag, min_value, max_value
FROM user_sequences
WHERE sequence_name = 'SEQ_CODES_REF';

-- Obtenir 3 nouvelles valeurs après la modification
SELECT seq_codes_ref.NEXTVAL FROM DUAL;
SELECT seq_codes_ref.NEXTVAL FROM DUAL;
SELECT seq_codes_ref.NEXTVAL FROM DUAL;
/
