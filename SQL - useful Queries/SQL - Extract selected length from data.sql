SELECT 
       [EmailAddress],
	   [Length] = LEN([EmailAddress]) - 20,
	   [User Name] = LEFT([EmailAddress], LEN([EmailAddress]) - 20)

      
  FROM [AdventureWorks2019].[Person].[EmailAddress]
