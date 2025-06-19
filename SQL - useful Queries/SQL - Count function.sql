--SELECT COUNT([SalesOrderID]) FROM [Sales].[SalesOrderHeader]
--SELECT COUNT(*) FROM [Sales].[SalesOrderHeader] -- Gives count of rows
--WHERE [TotalDue] > 10000
SELECT COUNT([CurrencyRateID]) FROM [Sales].[SalesOrderHeader] -- ignores NULL data
