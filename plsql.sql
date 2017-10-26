ALTER TABLE Events
    ADD (Competition_ID NUMBER(10) NOT NULL REFERENCES Competitions(Competition_ID));
