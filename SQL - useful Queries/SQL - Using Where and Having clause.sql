SELECT
[LastName],
COUNT(*)

FROM [Person].[Person]

GROUP BY [LastName]

HAVING COUNT(*) > 1 -- HAVING clause works on aggregate group data

SELECT  
COUNT(*)
FROM [Person].[Person]


WHERE [LastName] = 'Adams' -- WHERE clause works on individual row data basis