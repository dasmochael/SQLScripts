DECLARE @sql VARCHAR(max),@i INT,@name VARCHAR(max),@did INT,@lname VARCHAR(MAX)
DECLARE @tab_1 TABLE (id INT,name VARCHAR(max),dbid int)
INSERT INTO @tab_1
SELECT ROW_NUMBER() OVER(ORDER BY name),name,dbid FROM SYS.SYSDATABASES WHERE name NOT IN('master','model','tempdb','msdb') ORDER BY 1
--select * from @tab_1
SET @i=1
WHILE(@i<=(SELECT COUNT(*) FROM @tab_1))
BEGIN
SELECT @name=name,@did=dbid FROM @tab_1 WHERE id=@i
SELECT @lname=name FROM sys.master_files WHERE database_id=@did AND type_desc='LOG'
SET @sql='/*'+@name+'*/
ALTER DATABASE ['+@name+'] SET RECOVERY SIMPLE WITH NO_WAIT
USE ['+@name+']
DBCC SHRINKFILE (N'''+@lname+''',0,TRUNCATEONLY)
ALTER DATABASE ['+@name+'] SET RECOVERY FULL WITH NO_WAIT'
--print (@sql)
EXEC (@sql)
SET @i=@i+1
END
