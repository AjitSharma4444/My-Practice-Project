SELECT 
[JobTitle],
[Gender],
[VacationTime] = SUM([VacationHours]), -- total sum output
COUNT(*) -- Gives the output grouping Male and Female differently with job same job title


FROM [HumanResources].[Employee]

GROUP BY 
[JobTitle],
[Gender]

SELECT DISTINCT
[JobTitle],
[Gender]

FROM [HumanResources].[Employee]
