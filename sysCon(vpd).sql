
------------------------------context---------------------------------------
CREATE OR REPLACE CONTEXT hr_AUTH_details USING hr_AUTH_context_pkg;

------------------------------package---------------------------------------
--header
create or replace PACKAGE hr_AUTH_context_pkg IS
    PROCEDURE hr_AUTH_context_pro; 
END;
--body
create or replace PACKAGE BODY hr_AUTH_context_pkg IS 
    PROCEDURE hr_AUTH_context_pro 	AS 
    emp_id NUMBER;	-- you can decalre any number of variables between AS and BEGIN			
    BEGIN
    --Get emoployee_id and job_id
    SELECT EMPID INTO emp_id FROM  HR_TEST.EMPLOYEES WHERE ENAME = lower(SYS_CONTEXT('USERENV', 'SESSION_USER'));
    --set context values, you can set any number of context values for context,like in session variables seting in php
    DBMS_SESSION.SET_CONTEXT('hr_AUTH_details', 'emp_no', emp_id);
				
    EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
    END hr_AUTH_context_pro;
END hr_AUTH_context_pkg;
        
-------------------------------Trigger-----------------------------------------
CREATE or replace TRIGGER set_AUTH_emp_ctx_trig AFTER LOGON ON DATABASE
BEGIN
    HR_AUTH_CONTEXT_PKG.hr_AUTH_context_pro  ;  
END;
DROP TRIGGER set_AUTH_emp_ctx_trig;
------------------------------function-----------------------------------------
create or replace FUNCTION set_auth_user_privs( schema_p IN VARCHAR2,table_p IN VARCHAR2) RETURN VARCHAR2
AS auth_pred VARCHAR2 (400);
BEGIN
    --or u can declare a variable here with the same type as defined after return clausse, and return that varibale insted of using AS clause.t
    --the way of already defined in the function is simpler way to doing it.
  auth_pred := 'EMPID = SYS_CONTEXT(''hr_AUTH_details'', ''emp_no'')';
RETURN auth_pred;
END;

------------------------------policy-----------------------------------------
/*
BEGIN
DBMS_RLS.ADD_POLICY (              --under DBMS_RLS package there's a function call ADD_POLICY, an parameters are passing for that function is given below
    object_schema => 'hr_test',        --to which user you're creating this policy
    object_name => 'hr.employees',      --table name
    policy_name => 'USER_AUTH_POLICY', 
    function_schema => 'system',       --where you going to create this function
    policy_function => 'set_auth_user_privs',
    statement_types => 'select',       --if you're going to use multiple statements,you can use them like 'select,insert,delete'
    sec_relevant_cols => 'AUTH_SYSTEMS',-- which colums are sencitive, these two lines needs to Adding a Column Masking to an Oracle Virtual Private Database Policy, 
    sec_relevant_cols_opt => dbms_rls.ALL_ROWS
    );
END;
*/
BEGIN
DBMS_RLS.DROP_POLICY('hr_test', 'employees','USER_AUTH_POLICY');   --drop policy
END;


BEGIN
DBMS_RLS.ADD_POLICY (
    object_schema => 'hr_test',
    object_name => 'employees',
    policy_name => 'USER_AUTH_POLICY', 
    function_schema => 'sys',
    policy_function => 'set_auth_user_privs',
    statement_types => 'select',
    sec_relevant_cols => 'salary',
    sec_relevant_cols_opt => DBMS_RLS.ALL_ROWS
    );
END;

----------------------------------------------------------------------------------

create user amila identified by pwd;

GRANT Connect,Resource to amila;

GRANT SELECT ON HR_TEST.EMPLOYEES to amila;

DROP USER amila;


----------------------------------NEED------------------------------------------

SELECT * FROM HR_TEST.EMPLOYEES;

SELECT EMPID FROM  HR_TEST.EMPLOYEES WHERE LOWER(ENAME) = 'kasun';
SELECT EMPID FROM  HR_TEST.EMPLOYEES WHERE EMPID = SYS_CONTEXT('test_AUTH_details', 'emp_no');

SELECT lower(SYS_CONTEXT('USERENV', 'SESSION_USER')) FROM DUAL;

----------------------------------NEED------------------------------------------
