---------------------------STANDARD AUDIT---------------------------------------


select * from SYS.AUD$ WHERE USERID='JHONE';

select * from DBA_AUDIT_TRAIL WHERE OBJ_NAME='FAMILY_INCOME_IT14030918';

truncate table sys.AUD$;
--------------------------------------
AUDIT ALL;
NOAUDIT ALL;
--------------------------------------
AUDIT ALL By Jhone BY ACCESS;
AUDIT SELECT TABLE, UPDATE TABLE, INSERT TABLE,DELETE TABLE BY Jhone BY ACCESS;
AUDIT EXECUTE PROCEDURE BY Jhone BY ACCESS;
