SELECT DISTINCT
      [JobTitle],
      
	  [Job Category] = 
	  CASE
	  WHEN [JobTitle] LIKE '%Production%' THEN 'Production'
	  WHEN [JobTitle] LIKE '%Manager%' THEN 'Management'
	  WHEN [JobTitle] LIKE '%President%' THEN 'Management'
	  ELSE 'Other'
	  END
  FROM [AdventureWorks2019].[HumanResources].[Employee]
