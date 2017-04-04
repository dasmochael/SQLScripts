DECLARE @SPID INT,
                @SQL NVARCHAR(MAX);
DECLARE CUR CURSOR LOCAL FAST_FORWARD FOR
SELECT
        s.session_id
FROM
        sys.dm_exec_sessions s
LEFT JOIN
        sys.dm_exec_requests r
                ON s.session_id = r.session_id
WHERE
        r.session_id IS NULL
        AND program_name LIKE '%Microsoft SQL Server Management Studio%'
        AND last_request_start_time < DATEADD(HOUR, -24, GETDATE());
OPEN CUR;
FETCH CUR INTO @SPID;
WHILE @@FETCH_STATUS = 0
BEGIN
        SET @SQL = N'KILL ' + CAST(@SPID AS VARCHAR(5));
BEGIN TRY
                EXEC sp_executesql @SQL;
                PRINT 'SUCCESS: ' + @SQL;
        END TRY
        BEGIN CATCH
                PRINT 'ERROR: ' + @SQL;
        END CATCH;
FETCH CUR INTO @SPID;
END;
CLOSE CUR;

DEALLOCATE CUR;