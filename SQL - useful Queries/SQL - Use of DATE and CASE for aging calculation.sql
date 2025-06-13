SELECT 
       [OrderDate],
	   [Current Date] = CAST('07-31-2011' AS DATE),
	   [Elapsed Days] = DATEDIFF(DAY, [OrderDate], CAST('07-31-2011' AS DATE)),
	   [Aging Bucket] =
	    CASE
	    WHEN DATEDIFF(DAY, [OrderDate], CAST('07-31-2011' AS DATE)) < 10 THEN '< 10'
	    WHEN DATEDIFF(DAY, [OrderDate], CAST('07-31-2011' AS DATE)) BETWEEN 10 AND 19 THEN '10 - 19'
	    ELSE '20+'
	    END

	   
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
