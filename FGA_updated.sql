CREATE TABLE HR.Family_Income_IT14030918(
     id NUMBER,
     firstname VARCHAR2(50),
     lastname VARCHAR2(50),
     income_path VARCHAR2(50),
     income NUMBER
);

Insert into HR.FAMILY_INCOME_IT14030918 (ID,FIRSTNAME,LASTNAME,INCOME_PATH,INCOME) values (1,'Chathura','Ranathunga','aaaa',10000);
Insert into HR.FAMILY_INCOME_IT14030918 (ID,FIRSTNAME,LASTNAME,INCOME_PATH,INCOME) values (2,'Ashan','Wee','aasfag',39000);
Insert into HR.FAMILY_INCOME_IT14030918 (ID,FIRSTNAME,LASTNAME,INCOME_PATH,INCOME) values (3,'Avishka','Ransf','sadas',34532);
Insert into HR.FAMILY_INCOME_IT14030918 (ID,FIRSTNAME,LASTNAME,INCOME_PATH,INCOME) values (4,'Sajith','Prasd','asfasg',55024);

DROP TABLE Family_Income_IT14030918;
-----------------------------------user creation--------------------------------
CREATE USER Jhone IDENTIFIED BY pwd;
GRANT CONNECT, RESOURCE TO Jhone;
GRANT SELECT, INSERT, UPDATE, DELETE ON HR.Family_Income_IT14030918 TO Jhone;

----------------------------FGA(Fine Grade Audit) Policy------------------------
/*

DBMS_FGA.ADD_POLICY (
   object_schema      =>  'scott', 
   object_name        =>  'emp', 
   policy_name        =>  'mypolicy1', 
   audit_condition    =>  'sal < 100', 
   audit_column       =>  'comm,sal', 
   handler_schema     =>   NULL, 
   handler_module     =>   NULL, 
   enable             =>   TRUE, 
   statement_types    =>  'INSERT, UPDATE', 
   audit_column_opts  =>   DBMS_FGA.ANY_COLUMNS,
   policy_owner       =>  'sec_admin); 
   */
BEGIN 
    DBMS_FGA.ADD_POLICY ( 
    object_schema => 'HR', 
    object_name => 'Family_Income_IT14030918',
    policy_name => 'chk_hr_employees',
    --audit_condition => 'income < 10000',                      --"SALARY" > 50000
    audit_column    => 'income_path,income',   --ALL_COLUMNS is the default parameter.
    policy_owner => NULL, 
    enable => TRUE, 
    statement_types => 'INSERT,UPDATE,DELETE', 
    audit_trail => DBMS_FGA.DB,
    audit_column_opts => DBMS_FGA.ANY_COLUMNS); 
END;

-------------------Check the created audit policy-------------------------------

SELECT POLICY_NAME FROM  DBA_AUDIT_POLICIES; 


--------------------------Disable policy----------------------------------------
BEGIN 
DBMS_FGA.DISABLE_POLICY( object_schema => 'HR', object_name => 'Family_Income_IT14030918', policy_name => 'chk_hr_employees'); 
END;

--------------------------Enable Policy-----------------------------------------
BEGIN
DBMS_FGA.ENABLE_POLICY( object_schema => 'HR', object_name => 'Family_Income_IT14030918', policy_name => 'chk_hr_employees', enable => TRUE); 
END;


-----------------------------Drop Policy----------------------------------------
BEGIN
DBMS_FGA.DROP_POLICY( object_schema => 'HR', object_name => 'Family_Income_IT14030918', policy_name => 'chk_hr_employees'); 
END;


--------------------------FGA audit records-------------------------------------
SELECT * FROM SYS.FGA_LOG$;

DELETE FROM SYS.FGA_LOG$;
