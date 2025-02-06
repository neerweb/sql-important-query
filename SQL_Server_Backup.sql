......SQL Server Script for Full Backup of All Databases.........

  DECLARE @BackupPath NVARCHAR(255) = 'D:\SQL_Backups\'  -- Change this to your desired backup folder
DECLARE @DatabaseName NVARCHAR(255)
DECLARE @BackupFile NVARCHAR(500)
DECLARE @SQL NVARCHAR(MAX)

DECLARE db_cursor CURSOR FOR
SELECT name 
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')  -- Exclude system databases if not needed

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @DatabaseName  

WHILE @@FETCH_STATUS = 0  
BEGIN  
    SET @BackupFile = @BackupPath + @DatabaseName + '_Backup_' + CONVERT(NVARCHAR(20), GETDATE(), 112) + '.bak'
    SET @SQL = 'BACKUP DATABASE [' + @DatabaseName + '] TO DISK = ''' + @BackupFile + ''' WITH FORMAT, INIT, COMPRESSION, STATS = 10'

    PRINT @SQL  -- Prints the command for debugging
    EXEC sp_executesql @SQL  -- Execute the backup command

    FETCH NEXT FROM db_cursor INTO @DatabaseName  
END  

CLOSE db_cursor  
DEALLOCATE db_cursor


