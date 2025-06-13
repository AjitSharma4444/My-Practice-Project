SELECT
[First Case] = 

 CASE
 WHEN 1 = 2 THEN 'A'
 WHEN 3 > 2 THEN 'B' -- First right value will come as output
 WHEN 3 < 5 THEN 'C'
 ELSE 'D'
END
