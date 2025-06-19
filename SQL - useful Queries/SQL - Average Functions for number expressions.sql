SELECT * INTO #avg_demo FROM
(
SELECT [NUM] = 1 UNION
SELECT [NUM] = 2
) X

SELECT * FROM #avg_demo


SELECT AVG([NUM] * 1.0) FROM #avg_demo -- Average of number expression