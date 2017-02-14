ALTER LOGIN sa ENABLE;
ALTER LOGIN sa WITH PASSWORD = '123456';

CREATE LOGIN appUser
WITH PASSWORD = '12345';

ALTER SERVER ROLE diskadmin ADD MEMBER appUser;

USE NORTHWND;

CREATE USER appUser FROM LOGIN appUser;

USE NORTHWND;
SELECT * FROM Categories;

USE NORTHWND;
ALTER ROLE db_datareader ADD MEMBER appUser;

USE NORTHWND;
SELECT * FROM Categories;

USE NORTHWND;
INSERT INTO Categories 
VALUES ('Prueba','Categoria de prueba',NULL);

USE NORTHWND;
GRANT INSERT ON dbo.Categories TO appUser;

USE NORTHWND;
INSERT INTO Categories 
VALUES ('Prueba','Categoria de prueba',NULL);

SELECT
a.name as Name
, a.type_desc AS LoginType
, ISNULL(SUSER_NAME(b.role_principal_id),'public')
 AS AssociatedServerRole
FROM sys.server_principals a
JOIN sys.server_role_members b
ON a.principal_id=b.member_principal_id
WHERE a.name NOT LIKE 'NT%'
ORDER BY LoginType, Name;



SELECT
pr.name AS UserName
, pr.type_desc AS LoginType
, USER_NAME(me.role_principal_id) AS AssociatedDatabaseRole
, DB_NAME() AS 'Database'
FROM sys.database_principals pr
LEFT OUTER JOIN sys.database_role_members me
ON pr.principal_id=me.member_principal_id
WHERE me.role_principal_id IS NOT NULL
ORDER BY LoginType, UserName;

SELECT
pr.type_desc AS LoginType
, pr.name as Name
, pe.permission_name AS 'Action',pe.state_desc AS 'Permission'
, CASE class
WHEN 0 THEN 'Database::' + DB_NAME()
WHEN 1 THEN OBJECT_NAME(major_id)
WHEN 3 THEN 'Schema::' + SCHEMA_NAME(major_id)
END AS 'Securable'
FROM sys.database_principals AS pr
JOIN sys.database_permissions AS pe
ON pe.grantee_principal_id = pr.principal_id
WHERE pr.name <> 'guest' AND pr.name <> 'public'
ORDER BY LoginType, Name;
