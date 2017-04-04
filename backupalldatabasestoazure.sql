DECLARE @SQL NVARCHAR(MAX)
SET @SQL=
'SELECT
   ''BACKUP DATABASE [''+T.name+''] TO  URL = N''https://azbhbackups.blob.core.windows.net/backups/''+T.name+''_''+CAST(CAST(Getdate() as date)as varchar(30))+''.bak'' WITH  CREDENTIAL = N''AzureCredential'' , NOFORMAT, NOINIT,  NAME = N''''+T.name+''-Full Database Backup'', NOSKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10''
FROM 
    SYS.sysdatabases T
WHERE T.name not in (''model'',''master'',''tempdb'',''msdb'',''mirthdb'',''AppFabricMonitoring'',''AppFabricPersistence'',''PGStage'',''PGStage2'')'






DIFF

DECLARE @SQL NVARCHAR(MAX)
SET @SQL=
'SELECT
   ''BACKUP DATABASE [''+T.name+''] TO  URL = N''https://azbhbackups.blob.core.windows.net/backups/''+T.name+''_DIFF_''+CAST(CAST(Getdate() as date)as varchar(30))+''.bak'' WITH  CREDENTIAL = N''AzureCredential'' , DIFFERENTIAL, NOFORMAT, NOINIT,  NAME = N''''+T.name+''-Full Database Backup'', NOSKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10''
FROM 
    SYS.sysdatabases T
WHERE T.name not in (''model'',''master'',''tempdb'',''msdb'',''mirthdb'',''AppFabricMonitoring'',''AppFabricPersistence'',''PGStage'',''PGStage2'')'



LOG


DECLARE @SQL NVARCHAR(MAX)
SET @SQL=
'SELECT
   ''BACKUP LOG [''+T.name+''] TO  URL = N''https://azbhbackups.blob.core.windows.net/backups/''+T.name+''_LOG_''+CAST(CAST(Getdate() as date)as varchar(30))+''.trn'' WITH  CREDENTIAL = N''AzureCredential'' , NOFORMAT, NOINIT,  NAME = N''''+T.name+''-Full Database Backup'', NOSKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10''
FROM 
    SYS.sysdatabases T
WHERE T.name not in (''model'',''master'',''tempdb'',''msdb'',''mirthdb'',''AppFabricMonitoring'',''AppFabricPersistence'',''PGStage'',''PGStage2'')'
