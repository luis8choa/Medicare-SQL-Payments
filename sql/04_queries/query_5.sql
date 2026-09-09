-- Fix: SUM(tot_srvcs)*AVG(avg_mdcr_pymt_amt) != SUM(tot_srvcs*avg_mdcr_pymt_amt).
-- (provider_type, hcpcs_cd) agrupa a muchos NPIs distintos por grupo (hasta 62
-- filas), cada uno con su propio avg_mdcr_pymt_amt, asi que el monto se debe
-- sumar fila por fila ANTES de rankear, no sum(a)*avg(b) al final.
-- Fix: falta hcpcs_desc en el output (el enunciado pide 5 columnas).
-- Fix: ROW_NUMBER() en vez de DENSE_RANK() -- un empate en el 3er puesto con
-- DENSE_RANK devolveria mas de 3 filas para esa especialidad; ROW_NUMBER
-- garantiza exactamente top-3 siempre.
-- Quita el SELECT DISTINCT del CTE: es redundante, cada (provider_type, hcpcs_cd)
-- ya es unico por el GROUP BY.
WITH ranked AS (
  SELECT provider_type,
    hcpcs_cd,
    MAX(hcpcs_desc) AS hcpcs_desc,
    ROUND(SUM(tot_srvcs * avg_mdcr_pymt_amt), 2) AS total_paid,
    ROW_NUMBER() OVER (
      PARTITION BY provider_type
      ORDER BY SUM(tot_srvcs * avg_mdcr_pymt_amt) DESC
    ) AS ranking
  FROM medicare_provider_service
  GROUP BY provider_type, hcpcs_cd
)
SELECT provider_type, ranking, hcpcs_cd, hcpcs_desc, total_paid
FROM ranked
WHERE ranking <= 3
ORDER BY provider_type, ranking;
