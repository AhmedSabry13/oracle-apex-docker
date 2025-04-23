-- setup.sql
CREATE TABLE hello_apex (
  id NUMBER GENERATED ALWAYS AS IDENTITY,
  message VARCHAR2(100)
);

INSERT INTO hello_apex (message) VALUES ('Hello from Docker!');
COMMIT;
