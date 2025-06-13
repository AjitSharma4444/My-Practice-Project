SELECT 
       B.FirstName
	  ,B.LastName
	  ,B.PersonType
      ,A.[TerritoryID]
      ,A.[SalesQuota]
      ,A.[Bonus]
      ,A.[CommissionPct]
      ,A.[SalesYTD]
      ,A.[SalesLastYear]
	  ,C.[Group]

  FROM [AdventureWorks2019].[Sales].[SalesPerson] A -- Alias Table with A
  JOIN [AdventureWorks2019].[Person].[Person] B -- Alias Table with B
  ON A.BusinessEntityID = B.BusinessEntityID
  JOIN [AdventureWorks2019].[Sales].[SalesTerritory] C -- Alias Table with C
  ON A.TerritoryID = C.TerritoryID

  WHERE C.[Group] = 'Europe'