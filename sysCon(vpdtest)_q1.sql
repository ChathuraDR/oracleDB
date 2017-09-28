-- All employees must be able to view only his or her record except HR users and manager.
-----------------------------------------------------------------------------------------------
CREATE OR REPLACE CONTEXT test_AUTH_details USING test_AUTH_context_pkg;
---------------------------------------------------------------------------------
create or replace PACKAGE test_AUTH_context_pkg IS
	PROCEDURE test_AUTH_context_pro;
END;

create or replace PACKAGE BODY test_AUTH_context_pkg IS 
	PROCEDURE test_AUTH_context_pro AS
		emp_no NUMBER;
        sess_id VARCHAR2(25);
        job_id VARCHAR2(25);
		BEGIN
		SELECT "EMPLOYEE_ID" INTO emp_no FROM  "HR"."EMPLOYEES" WHERE lower("FIRST_NAME") = lower(SYS_CONTEXT('USERENV', 'SESSION_USER'));
		DBMS_SESSION.SET_CONTEXT('test_AUTH_details', 'emp_no', emp_no);
        
        SELECT "JOB_ID" INTO job_id FROM  "HR"."EMPLOYEES" WHERE "EMPLOYEE_ID" = emp_no;
        DBMS_SESSION.SET_CONTEXT('test_AUTH_details', 'job_id', job_id);
				
		EXCEPTION
			WHEN NO_DATA_FOUND THEN NULL;
	END test_AUTH_context_pro;
END test_AUTH_context_pkg;


drop package HR_AUTH_context_pkg;
---------------------------------------------------------------------------------

CREATE or replace TRIGGER test_AUTH_emp_ctx_trig AFTER LOGON ON DATABASE
BEGIN
    test_AUTH_CONTEXT_PKG.test_AUTH_context_pro;
END;

DROP TRIGGER test_AUTH_emp_ctx_trig;    
--------------------------------------------------------------------------------
    
create or replace FUNCTION test_auth_user_privs(schema_p IN VARCHAR2,table_p IN VARCHAR2) RETURN VARCHAR2
AS
  auth_pred VARCHAR2 (400);
  job_id VARCHAR2(25);
BEGIN
    job_id := SYS_CONTEXT('test_AUTH_details', 'job_id');
    IF (job_id ='HR_REP' OR job_id='FI_MGR' OR job_id='AC_MGR' OR job_id ='SA_MAN' OR job_id='PU_MAN' OR job_id='ST_MAN' OR job_id='MK_MAN')
    THEN
        auth_pred := '';        
    ELSE
        auth_pred := '"EMPLOYEE_ID" = SYS_CONTEXT(''test_AUTH_details'', ''emp_no'')';
    END IF;
RETURN auth_pred;
END;

------------------------------------------------------------------------------------
BEGIN 
DBMS_RLS.DROP_POLICY('hr', 'EMPLOYEES', 'TEST_AUTH_POLICY');
END;

BEGIN
DBMS_RLS.ADD_POLICY (
object_schema => '"HR"',
object_name => '"EMPLOYEES"',
policy_name => 'TEST_AUTH_POLICY',
function_schema => 'sys',
policy_function => 'test_auth_user_privs',
statement_types => 'select');
END;
---------------------------------------------------------------------------------
DROP USER susan;
create user susan identified by pwd;
GRANT CONNECT,RESOURCE TO susan;
GRANT SELECT ON "HR"."EMPLOYEES" TO susan;

create user Donald identified by pwd;
GRANT CONNECT,RESOURCE TO Donald;
GRANT SELECT ON "HR"."EMPLOYEES" TO Donald;

