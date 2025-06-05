SELECT 
      [Description],
      --[Cleaned Description] = REPLACE([Description], ',','') 1st replace functioned
	  [Cleaned Description] = REPLACE(REPLACE([Description], ',',''), '.','')


  FROM [AdventureWorks2019].[Production].[ProductDescription]
