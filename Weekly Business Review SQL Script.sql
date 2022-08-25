
--  Weekly Business Review SQL Queries


--  1. Table to report number of Reviews, False Positives (FP) and False Negatives (FN) by Language

WITH
  Start_date AS (SELECT DATE 'YYYY-MM-DD'),
  End_date AS (SELECT DATE 'YYYY-MM-DD'),
  Reviews AS (
  SELECT 
  LANGUAGE AS Language, COUNT(id) AS Reviews
  FROM {TABLE NAME}
  WHERE
    date
    >= (SELECT * FROM Start_date)
  AND
    date
    <= (SELECT * FROM End_date)
   GROUP BY LANGUAGE),
Language_FP_FN AS (
  SELECT
  LANGUAGE AS LangFPFN, SUM(post_fp_l0_l1) AS FP, SUM(post_fn_l0_l1) AS FN,
  FROM {TABLE NAME}
  WHERE
    date
    >= (SELECT * FROM Start_date)
  AND
    date
    <= (SELECT * FROM End_date)
    GROUP BY LANGUAGE),
Join_Reviews_Language_FP_FN AS (
  SELECT * 
  FROM Language_Reviews 
  JOIN Language_FP_FN ON Reviews.LANGUAGE = Language_FP_FN.LangFPFN)
SELECT Language, Reviews, FP, FN
FROM Join_Reviews_Language_FP_FN
ORDER BY(FP + FN) DESC, 2 DESC, 1

--  2. Table to report number of False Positives (FP) and False Negatives (FN) by Site location (Krakow, Dublin and Lisbon)

SELECT
  CONCAT(RIGHT (location_site, 3), ':') AS Site,
  CONCAT(CAST (SUM(post_fp_l0_l1) AS STRING), ' FP,') AS FP,
  CONCAT(CAST (SUM(post_fn_l0_l1) AS STRING), ' FN') AS FN,
FROM {TABLE NAME}
WHERE
  decision_date
  >= 'YYYY-MM-DD'
AND
  decision_date
  <= 'YYYY-MM-DD'
GROUP BY Site
ORDER BY SUM(post_fp_l0_l1 + post_fn_l0_l1) DESC

--  3. Table to report number of False Positives (FP) and False Negatives (FN) by Language and Topic of the violation

SELECT
  LANGUAGE AS __LANGUAGE__1,
  topic AS __topic__1,
  SUM(post_fp_l0_l1) AS __post_fp_l0_l1__1,
  SUM(post_fn_l0_l1) AS __post_fn_l0_l1__1
FROM {TABLE NAME}
WHERE
  decision_date
  >= 'YYYY-MM-DD'
AND
  decision_date
  <= 'YYYY-MM-DD'
GROUP BY __LANGUAGE__1, __topic__1
HAVING SUM (post_fp_l0_l1 + post_fn_l0_l1) !=0
ORDER BY SUM (post_fp_l0_l1 + post_fn_l0_l1) DESC

--  4. Table to report number of False Positives (FP) and False Negatives (FN) by Topic of the violation

SELECT
  Topic,
  SUM(post_fp_l0_l1) AS __post_fp_l0_l1__1,
  SUM(post_fn_l0_l1) AS __post_fn_l0_l1__1
FROM {TABLE NAME}
WHERE
  decision_date
  >= 'YYYY-MM-DD'
AND
  decision_date
  <= 'YYYY-MM-DD'
GROUP BY Topic
HAVING SUM(post_fp_l0_l1 + post_fn_l0_l1) !=0
ORDER BY SUM(post_fp_l0_l1 + post_fn_l0_l1) DESC

--  5. Table to report number of False Positives (FP) and False Negatives (FN) by Reviewer

SELECT
  l0_reviewer AS __l0_reviewer__1,
  SUM(post_fp_l0_l1) AS __post_fp_l0_l1__1,
  SUM(post_fn_l0_l1) AS __post_fn_l0_l1__1,
FROM {TABLE NAME}
WHERE
  decision_date
  >= 'YYYY-MM-DD'
AND
  decision_date
  <= 'YYYY-MM-DD'
GROUP BY __l0_reviewer__1
HAVING SUM(post_fp_l0_l1 + post_fn_l0_l1) !=0
ORDER BY SUM(post_fp_l0_l1 + post_fn_l0_l1) DESC

