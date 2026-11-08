CREATE TABLE test_table (
    name         VARCHAR2(100),
    created_date DATE
);

INSERT INTO test_table
VALUES ('Ansible Oracle', SYSDATE);

COMMIT;

