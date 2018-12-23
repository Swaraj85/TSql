*********************************************************************************************
// Queries for database backup
*********************************************************************************************
	backup database <DBName> to -- full db backup to defined path
	disk ='c:\mydb.bkp',
	disk ='c:\mydb2.bkp' 
	with init,format, stats=10;
*********************************************************************************************
	backup log <DBName> to disk ='c:\mydbLog.trn'-- backup log to defined path, .trn is the standard file extension
*********************************************************************************************
	BACKUP DATABASE MyFirstDatabase -- Take differential backup 
	TO 
	DISK ='F:\MyFirstDatabase2.bkp'
	with init, format, stats=10, DIFFERENTIAL;
*********************************************************************************************
	BACKUP DATABASE MyFirstDatabase -- backup db with specific filegroup
	FILEGROUP= 'FG1' ,
	FILEGROUP= 'FG2'
	TO 
	DISK ='F:\MyFirstDatabase.bkp'
	with init, format, stats=10;
*********************************************************************************************
	backup database master to -- master database backup
	disk ='c:\master.bkp'
	with init,format, stats=10;
	
	backup database model to -- model database backup
	disk ='c:\master.bkp'
	with init,format, stats=10;
*********************************************************************************************
	restore database <DBName> from -- restore database
	disk ='F:\MyFirstDatabase.bkp'
	with stats=10, replace;
*********************************************************************************************
	restore FILELISTONLY from -- get the FG and their location from backup file
	disk ='F:\MyFirstDatabase.bkp';
	
	restore database <DBName> from -- restore database and move the logical file group to new location
	disk ='F:\MyFirstDatabase.bkp'
	with 
	move 'MyFirstDatabase' to 'c:\mynewdb\MyFirstDatabase_Primary.mdf',
	move 'MyFirstDatabase_log' to 'c:\mynewdb\MyFirstDatabase_Primary.ldf'
	stats=10, replace;
*********************************************************************************************
	/* restore transaction logs, no recovery mode instructs the engine to not undo the
	unfinished transaction, they are present in the upcoming logs
	---> "standby" flag is used when you want read only access while restoring the DB*/
	restore database MyFirstDatabase from -- 
	disk ='F:\MyFirstDatabase.bkp'
	with stats=10, norecovery;
	
	restore log MyFirstDatabase -- restore the transaction log 1
	from disk = 'F:/MyFirstDatabaseLog1.trn'
	with stats=10, norecovery;
	
	restore log MyFirstDatabase -- restore the transaction log 2
	from disk = 'F:/MyFirstDatabaseLog2.trn'
	with stats=10, norecovery;
	
	restore database MyFirstDatabase with recovery; -- instructs the engine to check for transaction completeness
	
	restore database MyFirstDatabase from -- 
	disk ='F:\MyFirstDatabase.bkp'
	with stats=10, standby='F:\Restore.txt'; -- standby mode is used for activating read only access to DB
*********************************************************************************************