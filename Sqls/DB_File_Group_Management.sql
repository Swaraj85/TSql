*********************************************************************************************
// Queries for database file groups
*********************************************************************************************
	-- Add file group to existing database and associate file with file group
	ALTER DATABASE <DB Name>
	ADD FILEGROUP [FG1]; -- add new filegroup [FG1]
	
	ALTER DATABASE swagTest -- associate file with filegroup [FG1]
	ADD FILE
	( NAME= FG1File,
	FILENAME= 'F:\DemoProjects\MyDbs\FG1File.ndf'
	) TO FILEGROUP [FG1];
	
*********************************************************************************************
	-- Check database file name, size and mdf/ndf location
	SELECT sdf.name AS [FileName],sdf.physical_name,
	size/128 AS [Size_in_MB],
	fg.name AS [File_Group_Name]
	FROM sys.database_files sdf
	INNER JOIN
	sys.filegroups fg
	ON sdf.data_space_id=fg.data_space_id
*********************************************************************************************