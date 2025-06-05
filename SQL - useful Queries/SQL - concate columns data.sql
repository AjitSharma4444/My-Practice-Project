SELECT 
      [NationalIDNumber],
      [LENGTH] = LEN([NATIONALIDNumber]),
	  --[Padded ID] = '0000000000',
	  [Padded ID] = RIGHT('0000000000' + [NationalIDNumber], 10)
  FROM [AdventureWorks2019].[HumanResources].[Employee]
