-- 1) Create a contained SQL user with its own password
CREATE USER [app_user] WITH PASSWORD = '';
GO

-- 2) Grant basic app permissions
ALTER ROLE db_datareader ADD MEMBER [app_user];
ALTER ROLE db_datawriter ADD MEMBER [app_user];
GO
