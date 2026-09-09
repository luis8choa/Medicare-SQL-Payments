SELECT state_abbr,
COUNT(*) AS total_services,
SUM(CASE WHEN place_of_srvc = 'F' THEN 1 ELSE 0 END) AS facility_services,
SUM(CASE WHEN place_of_srvc = 'O' THEN 1 ELSE 0 END) AS non_facility_services,
ROUND(SUM(CASE WHEN place_of_srvc = 'F' THEN 1 ELSE 0 END)*100.00/NULLIF(COUNT(*),0),2) AS facility_ratio
FROM medicare_provider_service
WHERE place_of_srvc IS NOT NULL
GROUP BY state_abbr
HAVING COUNT(*) > 200
ORDER BY 5 DESC;