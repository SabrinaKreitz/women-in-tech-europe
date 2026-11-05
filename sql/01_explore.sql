-- Check the import
SELECT geo, TIME_PERIOD, sex, OBS_VALUE, OBS_FLAG
FROM raw_graduates
LIMIT 20;

-- Profiling: number of rows
SELECT COUNT(*)
FROM raw_graduates;

-- Profiling: sex values
SELECT DISTINCT sex
FROM raw_graduates;

-- Profiling: flags and how often
SELECT OBS_FLAG, COUNT(*)
FROM raw_graduates
GROUP BY OBS_FLAG;

-- Profiling: countries and aggregates
SELECT DISTINCT geo
FROM raw_graduates;

-- Which countries have flags?
SELECT geo, OBS_FLAG, COUNT(*)
FROM raw_graduates
WHERE OBS_FLAG IS NOT NULL
GROUP BY geo, OBS_FLAG;

-- How many values are missing?
SELECT COUNT(*)
FROM raw_graduates
WHERE OBS_VALUE IS NULL;

-- Missing years per country
SELECT geo, COUNT(*) / 3 AS missing_years
FROM raw_graduates
WHERE OBS_VALUE IS NULL
GROUP BY geo
ORDER BY missing_years DESC;

-- Ireland: female share per year, with flag
SELECT
  TIME_PERIOD,
  MAX(CASE WHEN sex = 'Females' THEN OBS_VALUE END) AS females,
  MAX(CASE WHEN sex = 'Total'   THEN OBS_VALUE END) AS total,
  ROUND(100.0 * MAX(CASE WHEN sex = 'Females' THEN OBS_VALUE END)
              / MAX(CASE WHEN sex = 'Total'   THEN OBS_VALUE END), 1) AS female_pct,
  MAX(OBS_FLAG) AS flag
FROM raw_graduates
WHERE geo = 'Ireland'
GROUP BY TIME_PERIOD
ORDER BY TIME_PERIOD;

-- Clean table: one row per country and year
CREATE TABLE ict_bachelor AS
SELECT
  geo AS country,
  CAST(TIME_PERIOD AS INTEGER) AS year,
  MAX(CASE WHEN sex = 'Females' THEN CAST(OBS_VALUE AS INTEGER) END) AS females,
  MAX(CASE WHEN sex = 'Males'   THEN CAST(OBS_VALUE AS INTEGER) END) AS males,
  MAX(CASE WHEN sex = 'Total'   THEN CAST(OBS_VALUE AS INTEGER) END) AS total,
  MAX(OBS_FLAG) AS flag,
  CASE
    WHEN geo LIKE 'European Union%' THEN 'Aggregate'
    WHEN geo IN ('Austria','Belgium','Bulgaria','Croatia','Cyprus','Czechia',
                 'Denmark','Estonia','Finland','France','Germany','Greece',
                 'Hungary','Ireland','Italy','Latvia','Lithuania','Luxembourg',
                 'Malta','Netherlands','Poland','Portugal','Romania','Slovakia',
                 'Slovenia','Spain','Sweden') THEN 'EU27'
    ELSE 'Non-EU'
  END AS country_group
FROM raw_graduates
GROUP BY geo, TIME_PERIOD;

-- Check: should be 410 rows
SELECT COUNT(*) FROM ict_bachelor;

-- Look at the clean table
SELECT * FROM ict_bachelor LIMIT 20;
