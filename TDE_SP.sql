USE [master]

go

/****** Object:  StoredProcedure [dbo].[sp_TDE]    Script Date: 11/9/2017 12:29:18 PM ******/
SET ansi_nulls ON

go

SET quoted_identifier ON

go

CREATE PROCEDURE [dbo].[Sp_tde] @client   VARCHAR(50),
                                @password NVARCHAR(50),
                                @backup   NVARCHAR(100)
AS
  BEGIN
      SET nocount ON;

      DECLARE @cmd AS NVARCHAR(max)

      SET @cmd = N'
IF NOT EXISTS (SELECT * FROM SYS.SYMMETRIC_KEYS WHERE SYMMETRIC_KEY_ID = 101)
BEGIN
USE master;
CREATE MASTER KEY 
ENCRYPTION BY PASSWORD = ''' + @password
                 + ''';
END
ELSE BEGIN
USE master;
CREATE CERTIFICATE My' + @client
                 + 'Cert
WITH SUBJECT = ''Cert used for TDE''
END;
USE master;
BACKUP CERTIFICATE My' + @client
                 + 'Cert
TO FILE = N''' + @backup + '\My' + @client
                 + 'Cert.cer'' WITH PRIVATE KEY (FILE = N'''
                 + @backup + '\My' + @client
                 + 'Cert.pvk'', ENCRYPTION BY PASSWORD = N'''
                 + @password
                 + '''); 
exec master..sp_MSForeachdb ''use [?]
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_128 ENCRYPTION BY SERVER CERTIFICATE My'
                 + @client
                 + 'Cert''
exec master..sp_MSForeachdb ''use [?]
ALTER DATABASE [?] SET ENCRYPTION ON;''';

      EXEC Sp_executesql @cmd
  END

go 
