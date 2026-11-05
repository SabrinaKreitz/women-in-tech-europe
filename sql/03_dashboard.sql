-- Analysis table for the dashboard
CREATE TABLE ict_dashboard AS
SELECT country, year, country_group, females, males, total,
       ROUND(100.0 * females / total, 1) AS female_pct,
       flag,
       CASE WHEN total < 100 THEN 'yes' ELSE 'no' END AS small_sample
FROM ict_bachelor
WHERE total IS NOT NULL;

-- check
SELECT COUNT(*) FROM ict_dashboard;