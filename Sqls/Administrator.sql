SELECT * FROM sys.server_principals WHERE type_desc='SQL_LOGIN';

CREATE LOGIN DoNotDoThis WITH PASSWORD ='password'

CREATE LOGIN [SWAGLAP\nobody] FROM WINDOWS

-----------------------------

SELECT * FROM sys.database_principals;

SELECT * FROM model.sys.database_principals;

CREATE USER [SWAGLAP\nobody]

--0x010500000000000515000000354B99C17A8F0C91C1F4AE5432040000
--0x010500000000000515000000354B99C17A8F0C91C1F4AE5432040000
--0x010500000000000515000000354B99C17A8F0C91C1F4AE5432040000
ALTER USER [swaglap\nobody] WITH NAME=noone

SELECT * FROM sys.server_principals WHERE sid=0x010500000000000515000000354B99C17A8F0C91C1F4AE5432040000

CREATE USER whoami WITHOUT LOGIN

DROP USER whoami

************************************** Permissions *************************************

SELECT * FROM sys.server_permissions
SELECT * FROM sys.database_permissions


************************************** Schemas *************************************

SELECT s.schema_id, s.name, dp.type_desc, dp.name
from sys.schemas as s INNER JOIN sys.database_principals as dp 
	ON s.principal_id= dp.principal_id;
	
select * from sys.schemas; -- select all the schemas in database
select * from sys.tables; -- selects all the tables in db
select * from sys.objects; -- all the objects in db


SELECT user; -- select the current user
	
SELECT * FROM sys.fn_my_permissions('securityII','database'); -- get the current permission for user in securityII database
SELECT * FROM sys.fn_my_permissions('saucer','schema'); -- get the current permission on saucer schema
SELECT * FROM sys.fn_my_permissions('tests','object'); -- check the permission for table "tests"


SELECT * FROM sys.objects AS o -- get the schema details for saucer schema
INNER JOIN sys.schemas AS s ON o.schema_id=s.schema_id
WHERE s.name='saucer';

EXECUTE AS USER ='gorty' -- execute as user 'gorty', setuser 'gorty' is deperecated
revert -- to get back to the original state

GRANT SELECT ON saucer.planets TO gorty -- grant select permisison to gorty on planet table

************************************** ROLES *************************************
/* server roles*/
 sp_helpsrvrole -- to see all the server roles

 sp_srvrolepermission 'sysadmin' -- all the permissions that sysadmin has 
 
 sp_helpsrvrolemember 'sysadmin' -- to see the users who are sysadmin role in sql server
 
 sp_addsrvrolemember 'swaglap\workerbee' , 'sysadmin' -- add windows user workerbee in sysadmin role
 
 sp_dropsrvrolemember 'swaglap\workerbee' , 'sysadmin' -- drop user workerbee from sysadmin
 
 /* database roles*/
 
 sp_helpdbfixedrole -- to see the db roles
 
 deny select on schema::saucer to [swaglap\workerbee] -- deny select on saucer schema for workerbee
 
 
 sp_addrolemember 'db_datareader' , 'swaglap\workerbee' -- add workerbee to datareader role
 
 create role saucer_reader; -- Create custom database role
 grant select on schema::saucer to saucer_reader; -- grant select rights on saucer schema to saucer_reader role
 
 
 select pri.name as role, pri2.name as principal from sys.database_role_members as rm -- get the roles and associated principals
join sys.database_principals as pri
on pri.principal_id = rm.role_principal_id
join sys.database_principals as pri2
on pri2.principal_id = rm.member_principal_id
where pri2.name = 'swaglap\raygun'
 
 ************************************** Execution Context *************************************
 execute as login = 'swaglap\gort' -- impersonlization, OBO (on behalf of) server principal
 runas /profile /user:swaglap\workerbee "C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\Ssms.exe"

 ************************************** Locks *************************************
 
 SELECT -- use * to explore other available attributes
request_session_id AS spid,
resource_type AS restype,
resource_database_id AS dbid,
DB_NAME(resource_database_id) AS dbname,
resource_description AS res,
resource_associated_entity_id AS resid,
request_mode AS mode,
request_status AS status
FROM sys.dm_tran_locks;

SELECT -- use * to explore
session_id AS spid,
connect_time,
last_read,
last_write,
most_recent_sql_handle
FROM sys.dm_exec_connections
WHERE session_id IN(63, 66);

SELECT session_id, text
FROM sys.dm_exec_connections
CROSS APPLY sys.dm_exec_sql_text(most_recent_sql_handle) AS ST
WHERE session_id IN(63, 66);

SELECT -- use * to explore
session_id AS spid,
login_time,
host_name,
program_name,
login_name,
nt_user_name,
last_request_start_time,
last_request_end_time
FROM sys.dm_exec_sessions
WHERE session_id IN(63,66);

SELECT -- use * to explore
session_id AS spid,
blocking_session_id,
command,
sql_handle,
database_id,
wait_type,
wait_time,
wait_resource
FROM sys.dm_exec_requests
WHERE blocking_session_id > 0;