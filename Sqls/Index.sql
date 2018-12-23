*********************************************************************************************
// Queries for Index
*********************************************************************************************
	SELECT -- Detecting fragmentation
         object_name(object_id, database_id) AS ObjName
       , *
	FROM
			 sys.dm_db_index_physical_stats ( DB_ID('AdventureWorks2012'), NULL, NULL, NULL, NULL)
	ORDER BY
			 avg_fragmentation_in_percent desc
	;
*********************************************************************************************
	ALTER INDEX ALL ON Purchasing.ProductVendor -- reorganize all the index on Purchasing.ProductVendor table
	REBUILD -- reorg, rebuild build the whole index from scratch with Exclusive lock, reorg reshuffles the pages only
	WITH (ONLINE = ON)
*********************************************************************************************
	