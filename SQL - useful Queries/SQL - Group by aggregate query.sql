SELECT 
[JobTitle],
[EmployeeCount] = COUNT(*)

FROM [HumanResources].[Employee]

GROUP BY 
[JobTitle]

SELECT COUNT(*) FROM [HumanResources].[Employee] --Aggregate Query produce same number of rows as there are unique values in the GROUP BY

SELECT DISTINCT 
[JobTitle]

FROM [HumanResources].[Employee]