WITH cte1
     AS (SELECT c.obj_id                            AS obj_id,
                a.created                           AS creation_date,
                Datediff(DAY, a.created, Getdate()) AS day_cnt
         FROM   [HIST].[dbo].[History] a
                JOIN [HIST].[dbo].[HistorySummary] b
                  ON a.rowid = b.rowid
                JOIN [HIST].[dbo].[ObjectNames] c
                  ON c.obj_name = b.obj_name),
     cte2
     AS (SELECT cte1.obj_id AS obj_id,
                CASE
                  WHEN cte1.day_cnt <= 30 THEN 1
                  ELSE 0
                END         AS d0,
                CASE
                  WHEN ( cte1.day_cnt > 30 )
                       AND ( cte1.day_cnt <= 60 ) THEN 1
                  ELSE 0
                END         AS d1,
                CASE
                  WHEN ( cte1.day_cnt > 60 )
                       AND ( cte1.day_cnt <= 90 ) THEN 1
                  ELSE 0
                END         AS d2,
                CASE
                  WHEN ( cte1.day_cnt > 90 ) THEN 1
                  ELSE 0
                END         AS d3
         FROM   cte1)
SELECT obj_id,
       SUM(d0) AS OneMonth,
       SUM(d1) AS TwoMonths,
       SUM(d2) AS ThreeMonths,
       SUM(d3) AS Overdue
FROM   cte2
GROUP  BY obj_id