-- Fix: "servicios totales" = SUM(tot_srvcs), no COUNT(*) (COUNT(*) contaba filas
-- proveedor+codigo, no servicios prestados). Umbral corregido a >5,000.
-- Fix: GROUP BY solo hcpcs_cd (no + hcpcs_desc) para no arriesgar filas duplicadas
-- por variantes de descripcion; MAX(hcpcs_desc) trae una descripcion representativa.
SELECT hcpcs_cd, MAX(hcpcs_desc) AS hcpcs_desc, SUM(tot_srvcs) AS total_services
FROM medicare_provider_service
GROUP BY hcpcs_cd
HAVING SUM(tot_srvcs) > 5000
ORDER BY total_services DESC;
