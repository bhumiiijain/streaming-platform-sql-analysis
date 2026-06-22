USE streaming_analytics;
DROP TABLE IF EXISTS titles;
CREATE TABLE titles (
    id INT,
    title VARCHAR(500) CHARACTER SET utf8mb4,
    year INT,
    age VARCHAR(10),
    rotten_tomatoes VARCHAR(10),
    netflix TINYINT,
    hulu TINYINT,
    prime_video TINYINT,
    disney_plus TINYINT,
    rt_score DECIMAL(4,1),
    platform_count INT
);

LOAD DATA LOCAL INFILE 'C:/data/correct.csv'
INTO TABLE titles
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id, title, year, age, rotten_tomatoes,
 netflix, hulu, prime_video, disney_plus,
 rt_score, platform_count);

SELECT COUNT(*) FROM titles;

SELECT title, netflix, hulu, prime_video, disney_plus, rt_score, platform_count 
FROM titles LIMIT 5;

SELECT title, netflix, rt_score, platform_count FROM titles LIMIT 5;


SELECT 'Netflix' AS platform, SUM(netflix) AS title_count FROM titles
UNION ALL SELECT 'Hulu', SUM(hulu) FROM titles
UNION ALL SELECT 'Prime Video', SUM(prime_video) FROM titles
UNION ALL SELECT 'Disney+', SUM(disney_plus) FROM titles
ORDER BY title_count DESC;

SELECT
  ROUND(AVG(CASE WHEN netflix=1 THEN rt_score END), 1) AS netflix_avg_rt,
  ROUND(AVG(CASE WHEN hulu=1 THEN rt_score END), 1) AS hulu_avg_rt,
  ROUND(AVG(CASE WHEN prime_video=1 THEN rt_score END), 1) AS prime_avg_rt,
  ROUND(AVG(CASE WHEN disney_plus=1 THEN rt_score END), 1) AS disney_avg_rt
FROM titles
WHERE rt_score IS NOT NULL;

SELECT
  ROUND(AVG(CASE WHEN netflix=1 THEN year END), 1) AS netflix_avg_year,
  ROUND(AVG(CASE WHEN hulu=1 THEN year END), 1) AS hulu_avg_year,
  ROUND(AVG(CASE WHEN prime_video=1 THEN year END), 1) AS prime_avg_year,
  ROUND(AVG(CASE WHEN disney_plus=1 THEN year END), 1) AS disney_avg_year
FROM titles;

SELECT
  ROUND(SUM(CASE WHEN netflix=1 AND hulu=0 AND prime_video=0 AND disney_plus=0 THEN 1 ELSE 0 END)*100.0/SUM(netflix),1) AS netflix_excl_pct,
  ROUND(SUM(CASE WHEN hulu=1 AND netflix=0 AND prime_video=0 AND disney_plus=0 THEN 1 ELSE 0 END)*100.0/SUM(hulu),1) AS hulu_excl_pct,
  ROUND(SUM(CASE WHEN prime_video=1 AND netflix=0 AND hulu=0 AND disney_plus=0 THEN 1 ELSE 0 END)*100.0/SUM(prime_video),1) AS prime_excl_pct,
  ROUND(SUM(CASE WHEN disney_plus=1 AND netflix=0 AND hulu=0 AND prime_video=0 THEN 1 ELSE 0 END)*100.0/SUM(disney_plus),1) AS disney_excl_pct
FROM titles;

SELECT
  CASE
    WHEN year < 1980 THEN 'Pre-1980'
    WHEN year BETWEEN 1980 AND 1989 THEN '1980s'
    WHEN year BETWEEN 1990 AND 1999 THEN '1990s'
    WHEN year BETWEEN 2000 AND 2009 THEN '2000s'
    WHEN year BETWEEN 2010 AND 2019 THEN '2010s'
    ELSE '2020s'
  END AS decade,
  SUM(netflix) AS netflix_titles,
  SUM(hulu) AS hulu_titles,
  SUM(prime_video) AS prime_titles,
  SUM(disney_plus) AS disney_titles
FROM titles
GROUP BY decade
ORDER BY MIN(year);

SELECT age,
  SUM(netflix) AS netflix_titles,
  SUM(hulu) AS hulu_titles,
  SUM(prime_video) AS prime_titles,
  SUM(disney_plus) AS disney_titles
FROM titles
WHERE age IS NOT NULL
GROUP BY age
ORDER BY age;

WITH ranked AS (
  SELECT title, year, rt_score,
    DENSE_RANK() OVER (ORDER BY rt_score DESC) AS rnk
  FROM titles WHERE netflix=1 AND rt_score IS NOT NULL
)
SELECT title, year, rt_score, rnk FROM ranked WHERE rnk <= 5;

SELECT
  ROUND(SUM(CASE WHEN netflix=1 AND rt_score>=60 THEN 1 ELSE 0 END)*100.0/SUM(CASE WHEN netflix=1 AND rt_score IS NOT NULL THEN 1 ELSE 0 END),1) AS netflix_fresh_pct,
  ROUND(SUM(CASE WHEN hulu=1 AND rt_score>=60 THEN 1 ELSE 0 END)*100.0/SUM(CASE WHEN hulu=1 AND rt_score IS NOT NULL THEN 1 ELSE 0 END),1) AS hulu_fresh_pct,
  ROUND(SUM(CASE WHEN prime_video=1 AND rt_score>=60 THEN 1 ELSE 0 END)*100.0/SUM(CASE WHEN prime_video=1 AND rt_score IS NOT NULL THEN 1 ELSE 0 END),1) AS prime_fresh_pct,
  ROUND(SUM(CASE WHEN disney_plus=1 AND rt_score>=60 THEN 1 ELSE 0 END)*100.0/SUM(CASE WHEN disney_plus=1 AND rt_score IS NOT NULL THEN 1 ELSE 0 END),1) AS disney_fresh_pct
FROM titles;

SELECT title, year, rt_score,
  CASE
    WHEN netflix=1 THEN 'Netflix'
    WHEN hulu=1 THEN 'Hulu'
    WHEN prime_video=1 THEN 'Prime Video'
    ELSE 'Disney+'
  END AS platform
FROM titles
WHERE rt_score >= 85 AND platform_count = 1
ORDER BY rt_score DESC
LIMIT 15;