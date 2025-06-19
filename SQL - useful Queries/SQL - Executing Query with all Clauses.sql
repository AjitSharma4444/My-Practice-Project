SELECT
[ProductCount] = COUNT(*),
[TotalSales] = SUM(A.[LineTotal]),
[Product] = B.[Name],
B.[Size]


FROM [AdventureWorks2019].[Sales].[SalesOrderDetail] A
JOIN [AdventureWorks2019].[Production].[Product] B
    ON A.[ProductID] = B.[ProductID]

WHERE B.[Size] IS NOT NULL

GROUP BY B.[Name], B.[Size]

HAVING SUM(A.[LineTotal]) > 10000

ORDER BY [TotalSales]