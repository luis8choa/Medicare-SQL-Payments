SELECT provider_type, COUNT(*) AS n_records
FROM medicare_provider_service
GROUP BY provider_type
ORDER BY COUNT(*) DESC
LIMIT 15;