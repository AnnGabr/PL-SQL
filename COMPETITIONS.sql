DROP TABLE results;
DROP TABLE competitions;
DROP TABLE jockeys;
DROP TABLE horses;
DROP TABLE hippodrome;
DROP TABLE owners;
DROP SEQUENCE ID_SEQUENCE;

CREATE SEQUENCE ID_SEQUENCE
    INCREMENT BY 1
    START WITH 1
    NOMAXVALUE
    ORDER
    NOCYCLE;

CREATE TABLE competitions (
    comp_id          INTEGER NOT NULL,
    name             VARCHAR2(50),
    comp_date        DATE NOT NULL,
    place            VARCHAR2(50 CHAR) NOT NULL,
    number_of_runs   INTEGER NOT NULL
);

ALTER TABLE competitions ADD CONSTRAINT competitions_pk PRIMARY KEY ( comp_id );

CREATE TABLE horses (
    horse_id          INTEGER NOT NULL,
    name              VARCHAR2(20 CHAR) NOT NULL,
    gender            CHAR(1) NOT NULL,
    birth_date        DATE NOT NULL,
    owner_id          INTEGER NOT NULL
);

ALTER TABLE horses
    ADD CHECK (
        gender IN (
            'f','m'
        )
    );

ALTER TABLE horses ADD CONSTRAINT horses_pk PRIMARY KEY ( horse_id );

CREATE TABLE jockeys (
    jockey_id   INTEGER NOT NULL,
    name      	VARCHAR2(50 CHAR) NOT NULL,
    address   	VARCHAR2(70 CHAR) NOT NULL,   
    height   	FLOAT NOT NULL,
    weight    	FLOAT NOT NULL,
    birth_date  DATE NOT NULL
);

ALTER TABLE jockeys ADD CHECK (
    weight > 0
);

ALTER TABLE jockeys ADD CHECK (
    height > 0
);

ALTER TABLE jockeys ADD CONSTRAINT jockeys_pk PRIMARY KEY ( jockey_id );

CREATE TABLE owners (
    owner_id   INTEGER NOT NULL,
    name       VARCHAR2(50 CHAR) NOT NULL,
    address    VARCHAR2(70 CHAR) NOT NULL
);

ALTER TABLE owners ADD CONSTRAINT owners_pk PRIMARY KEY ( owner_id );

CREATE TABLE hippodrome (
    hip_id 	    INTEGER PRIMARY KEY,
    name 	    VARCHAR2(30 CHAR) NOT NULL,
    owner_id 	INTEGER NOT NULL
);

CREATE TABLE results (
    arrival_number      INTEGER NOT NULL,
    run_number          INTEGER NOT NULL,
    horse_id        	INTEGER NOT NULL,
    comp_id   		    INTEGER NOT NULL,
    jockey_id      	    INTEGER NOT NULL
);

ALTER TABLE results ADD CHECK (
    arrival_number   > 0
);

ALTER TABLE results ADD CHECK (
    run_number  >= 0
);

CREATE INDEX horse_arrival_number ON results(arrival_number);

ALTER TABLE results ADD CONSTRAINT results_pk PRIMARY KEY ( comp_id, horse_id );

ALTER TABLE horses
    ADD CONSTRAINT horses_owners_fk FOREIGN KEY ( owner_id )
        REFERENCES owners ( owner_id )
    ON DELETE CASCADE;

ALTER TABLE results
    ADD CONSTRAINT res_comp_fk FOREIGN KEY ( comp_id )
        REFERENCES competitions ( comp_id )
    ON DELETE CASCADE;

ALTER TABLE results
    ADD CONSTRAINT res_horses_fk FOREIGN KEY ( horse_id )
        REFERENCES horses ( horse_id )
    ON DELETE CASCADE;

ALTER TABLE results
    ADD CONSTRAINT res_jockeys_fk FOREIGN KEY ( jockey_id )
        REFERENCES jockeys ( jockey_id )
    ON DELETE CASCADE;
    
ALTER TABLE hippodrome
    ADD CONSTRAINT hip_owners_fk FOREIGN KEY ( owner_id )
        REFERENCES owners ( owner_id )
    ON DELETE CASCADE;

--populate

INSERT INTO JOCKEYS VALUES
    (1, 'Dave', '123 Mein ave, MI'      , 181, 70, to_date('01-01-1981', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (2, 'John', '45 Herz st, CH'        , 179, 75, to_date('10-01-1983', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (3, 'Jim', '78 Shmidt rd, LA'       , 182, 73, to_date('01-11-1984', 'dd-mm-yyyy'));
INSERT INTO JOCKEYS VALUES
    (4, 'Tom', '89 Hamburg strasse, NY' , 178, 68, to_date('11-11-1985', 'dd-mm-yyyy'));

INSERT INTO OWNERS VALUES
    (1, 'Mr Sammers', '23 Abbey rd, London');
INSERT INTO OWNERS VALUES
    (2, 'Mr Goldstein', 'Hyde park 75, NY');

INSERT INTO HIPPODROME VALUES
    (ID_SEQUENCE.NEXTVAL, 'Champton', 1);
INSERT INTO HIPPODROME VALUES
    (ID_SEQUENCE.NEXTVAL, 'Bringhton', 2);

INSERT INTO HORSES VALUES
    (1, 'Donald' , 'm', 	 to_date('01-01-2015', 'dd-mm-yyyy'), 1);
INSERT INTO HORSES VALUES
    (2, 'Molly', 'f',	     to_date('01-01-2016', 'dd-mm-yyyy'), 1);
INSERT INTO HORSES VALUES
    (3, 'Alan', 'm',		 to_date('01-01-2015', 'dd-mm-yyyy'), 2);
INSERT INTO HORSES VALUES
    (4, 'Smith', 'm',		 to_date('01-01-2016', 'dd-mm-yyyy'), 2);

INSERT INTO COMPETITIONS VALUES
    (1, 'Champton Gran Prx' ,  to_date('2017-03-15 09:30', 'YYYY-MM-DD HH24:MI') , 'Champton', 5);
INSERT INTO COMPETITIONS VALUES
    (2, 'Champton Gran Prx' ,  to_date('2017-05-15 09:30', 'YYYY-MM-DD HH24:MI'), 'Champton', 4);
INSERT INTO COMPETITIONS VALUES
    (3, 'Bringhton Gran Prx' , to_date('2017-01-15 09:30', 'YYYY-MM-DD HH24:MI'), 'Bringhton', 10);
INSERT INTO COMPETITIONS VALUES
    (4, 'Bringhton Gran Prx' , to_date('2017-09-15 09:30', 'YYYY-MM-DD HH24:MI'), 'Bringhton', 7);

INSERT INTO RESULTS VALUES
    (1, 2, 1, 1, 1);
INSERT INTO RESULTS VALUES
    (1, 3, 2, 2, 2);
INSERT INTO RESULTS VALUES
    (1, 10, 2, 3, 3);
INSERT INTO RESULTS VALUES
    (1, 6, 3, 4, 4);
INSERT INTO RESULTS VALUES
    (2, 2, 3, 1, 3);

--trigers

CREATE OR REPLACE TRIGGER fkntm_horses BEFORE
    UPDATE OF owner_id ON horses
BEGIN
    raise_application_error(-20225,'Non Transferable FK constraint on table HORSES is violated');
END;
