-- Fix: el enunciado pide 3 columnas usando el metodo (A) AVG(allowed/submitted),
-- no las 4 columnas con metodo (A) y (B) mezcladas (y mal etiquetadas: el original
-- llamaba "compression_ratio" al metodo B SUM/SUM). (A) promedia el ratio por
-- proveedor; (B) es la razon de las sumas -- responden preguntas distintas.
-- Fix: HAVING COUNT(*) > 100 -> >= 100, "al menos 100" incluye el borde.
SELECT provider_type,
  COUNT(*) AS provider_count,
  ROUND(AVG(avg_mdcr_alowd_amt / NULLIF(avg_sbmtd_chrg,0)) * 100.00, 2) AS compression_ratio
FROM medicare_provider_service
WHERE avg_sbmtd_chrg > 0
GROUP BY provider_type
HAVING COUNT(*) >= 100
ORDER BY compression_ratio ASC;
