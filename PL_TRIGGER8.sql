CREATE OR REPLACE TRIGGER horse_less_10
  BEFORE INSERT ON results
  FOR EACH ROW
DECLARE
  birth_d horses.birth_date%TYPE;
  comp_d competitions.comp_date%TYPE;
  horse_age NUMBER;
BEGIN
  SELECT birth_date INTO birth_d FROM horses WHERE horse_id = :NEW.horse_id;
  SELECT comp_date INTO comp_d FROM competitions WHERE comp_id = :NEW.comp_id;
  horse_age := ABS(MONTHS_BETWEEN(comp_d, birth_d)) / 12;
  IF  horse_age < 10  THEN
    RAISE_APPLICATION_ERROR(-20222, 'ERROR: Horse is too young.');
  END IF;
END horse_less_10;

INSERT INTO results (arrival_number, run_number, horse_id, comp_id, jockey_id ) values (1, 6, 4, 4, 3);
