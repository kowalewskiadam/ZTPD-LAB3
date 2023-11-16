--zad 1
CREATE TABLE DOKUMENTY(
    ID NUMBER(12) PRIMARY KEY,
    DOKUMENT CLOB
)

--zad 2
DECLARE
    text CLOB:= '';
BEGIN
    FOR i IN 1..10000 LOOP
        text := CONCAT(text, 'Oto tekst. ');
    END LOOP;
    INSERT INTO DOKUMENTY values(1, text);
END;

--zad 3
select * from dokumenty;
select UPPER(dokument) from dokumenty;
select LENGTH(dokument) from dokumenty;
select dbms_lob.getlength(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--zad 4
INSERT INTO dokumenty values(2, EMPTY_CLOB());

--zad 5
INSERT INTO dokumenty values(3, NULL);
COMMIT;

--zad 6
select * from dokumenty;
select UPPER(dokument) from dokumenty;
select LENGTH(dokument) from dokumenty;
select dbms_lob.getlength(dokument) from dokumenty;
select substr(dokument, 5, 1000) from dokumenty;
select dbms_lob.substr(dokument, 1000, 5) from dokumenty;

--zad 7

DECLARE
    clob_text CLOB;
    fils BFILE := BFILENAME('TPD_DIR','dokument.txt');
    doffset integer := 1;
    soffset integer := 1;
    langctx integer := 0;
    warn integer := null;
BEGIN
    SELECT dokument INTO clob_text
    FROM dokumenty
    where id=2
    FOR UPDATE;
    
    DBMS_LOB.fileopen(fils, DBMS_LOB.file_readonly);
    DBMS_LOB.LOADCLOBFROMFILE(clob_text, fils, DBMS_LOB.LOBMAXSIZE, doffset, soffset, 0, langctx, warn);
    DBMS_LOB.FILECLOSE(fils);
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Status operacji: '||warn);
END;

--zad 8
UPDATE DOKUMENTY SET
    dokument = TO_CLOB(BFILENAME('TPD_DIR','dokument.txt'))
WHERE id=3;

--zad 9
select * from dokumenty;

--zad 10
select length(dokument) from dokumenty;

--zad 11
DROP TABLE DOKUMENTY;

--zad 12
CREATE OR REPLACE PROCEDURE CLOB_CENSOR(clob_text CLOB, replace_text VARCHAR2)
IS 
    idx number := 1;
    replaced_clob clob := clob_text;
    dots varchar2(100) := '';
BEGIN
    SELECT RPAD('.', length(replace_text), '.') INTO dots from dual;
    WHILE INSTR(replaced_clob, replace_text, idx) != 0 LOOP
        idx := INSTR(replaced_clob, replace_text, idx);
        DBMS_LOB.write(replaced_clob, length(replace_text), idx, dots);
    END LOOP;
END;

--zad 13

create table biographies as select * from ztpd.biographies;

DECLARE
 clob_text CLOB;
BEGIN
    SELECT BIO INTO clob_text FROM BIOGRAPHIES WHERE id=1 FOR UPDATE;
    CLOB_CENSOR(clob_text, 'Cimrman');
END;

--zad 14
DROP TABLE biographies;
