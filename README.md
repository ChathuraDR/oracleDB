# oracleDB


## Standard Audit
1. `SHOW PARAMETER AUDIT`
2. `ALTER SYSTEM SET audit_trail=db SCOPE=SPFILE`

AUDIT_TRAIL = { none | os | db | db,extended | xml | xml,extended }

*	none or false - Auditing is disabled.
*	db or true - Auditing is enabled, with all audit records stored in the database audit trial (SYS.AUD$).
*	db,extended - As db, but the SQL_BIND and SQL_TEXT columns are also populated.
*	xml- Auditing is enabled, with all audit records stored as XML format OS files.
*	xml,extended - As xml, but the SQL_BIND and SQL_TEXT columns are also populated.
