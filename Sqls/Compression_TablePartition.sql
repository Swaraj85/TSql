*********************************************************************************************
// Set of useful queries for compression + Table partitioning related 

*********************************************************************************************
	--check compression ratio of table and estimate of reduced table
	-- you can use index names in place of <table name>

	sp_estimate_data_compression_savings '<schema>','<table name>',null,null,'ROW' -- row compression
	sp_estimate_data_compression_savings '<schema>','<table name>',null,null,'PAGE' -- page compression
	
*********************************************************************************************
	SELECT * FROM sys.partitions WHERE object_name([object_id])='<table name>' -- check which partition the table belongs to
*********************************************************************************************