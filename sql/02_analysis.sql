-- Female share per country and year
SELECT country, year, females, total,
       ROUND(100.0 * females / total, 1) AS female_pct,
       flag
FROM ict_bachelor
WHERE country_group = 'EU27'
ORDER BY country, year;

-- Check: females + males = total
SELECT country, year, females, males, total,
       females + males - total AS difference
FROM ict_bachelor
WHERE females + males <> total;

-- EU27 benchmark over time
SELECT year, ROUND(100.0 * females / total, 1) AS female_pct
FROM ict_bachelor
WHERE country = 'European Union - 27 countries (from 2020)'
ORDER BY year;

-- Highest and lowest countries in the latest year
SELECT country, ROUND(100.0 * females / total, 1) AS female_pct
FROM ict_bachelor
WHERE country_group = 'EU27' AND year = 2024
ORDER BY female_pct DESC;

-- Sweden over time
SELECT year, females, total,
       ROUND(100.0 * females / total, 1) AS female_pct, flag
FROM ict_bachelor
WHERE country = 'Sweden'
ORDER BY year;

-- Change in female share 2015 → 2024 per EU country
SELECT a.country,
       ROUND(100.0 * a.females / a.total, 1) AS pct_2015,
       ROUND(100.0 * b.females / b.total, 1) AS pct_2024,
       ROUND(100.0 * b.females / b.total - 100.0 * a.females / a.total, 1) AS change_pts
FROM ict_bachelor a
JOIN ict_bachelor b ON a.country = b.country
WHERE a.year = 2015 AND b.year = 2024
  AND a.country_group = 'EU27'
ORDER BY change_pts DESC;

-- Check Cyprus, Greece, Luxembourg over time
SELECT country, year, females, total,
       ROUND(100.0 * females / total, 1) AS female_pct, flag
FROM ict_bachelor
WHERE country IN ('Cyprus', 'Greece', 'Luxembourg')
ORDER BY country, year;

-- EU countries with fewer than 100 graduates in any year
SELECT country, MIN(total) AS min_total
FROM ict_bachelor
WHERE country_group = 'EU27'
GROUP BY country
HAVING MIN(total) < 100;