1. SELECT ss.name AS SchemaName, -- Get the schema and table names from database
	TableName = st.name,
	st.object_id ObjectId
	FROM sys.schemas AS ss
	JOIN sys.tables st
	ON ss.schema_id = st.schema_id
	ORDER BY SchemaName, TableName;
	
2.  select * from sys.schemas; -- select all the schemas in database
	select * from sys.tables; -- selects all the tables in db
	select * from sys.objects; -- all the objects in db