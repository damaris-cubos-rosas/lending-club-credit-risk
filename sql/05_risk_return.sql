-- 5.1 Retorno por grade (cohortes vencidas)
SELECT grade,
       COUNT(*)                                        AS prestamos,
       ROUND(SUM(funded_amnt) / 1000000, 1)            AS prestado_millones,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(funded_amnt))
             / SUM(funded_amnt), 2)                    AS retorno_bruto_pct,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(collection_recovery_fee) - SUM(funded_amnt))
             / SUM(funded_amnt), 2)                    AS retorno_neto_pct
FROM loans_mature
GROUP BY grade
ORDER BY grade;

-- 5.2 Pérdida y recuperación por grade
SELECT grade,
       ROUND(100.0 * SUM(funded_amnt * is_default) / SUM(funded_amnt), 2) AS incumplimiento_por_monto_pct,
       ROUND(SUM(CASE WHEN is_default = 1 THEN funded_amnt - total_rec_prncp ELSE 0 END) / 1000000, 1) AS capital_no_pagado_millones,
       ROUND(SUM(CASE WHEN is_default = 1 THEN recoveries ELSE 0 END) / 1000000, 1) AS recuperaciones_millones,
       ROUND(100.0 * SUM(CASE WHEN is_default = 1 THEN recoveries ELSE 0 END)
             / NULLIF(SUM(CASE WHEN is_default = 1 THEN funded_amnt - total_rec_prncp ELSE 0 END), 0), 2) AS tasa_recuperacion_pct
FROM loans_mature
GROUP BY grade
ORDER BY grade;

-- 5.3 Descomposición del retorno: intereses menos pérdida
SELECT grade,
       ROUND(100.0 * SUM(total_pymnt - total_rec_prncp - recoveries) / SUM(funded_amnt), 2) AS intereses_y_cargos_pct,
       ROUND(100.0 * SUM(CASE WHEN is_default = 1 THEN funded_amnt - total_rec_prncp - recoveries ELSE 0 END)
             / SUM(funded_amnt), 2)                                                          AS perdida_neta_pct,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(funded_amnt)) / SUM(funded_amnt), 2)            AS retorno_bruto_pct
FROM loans_mature
GROUP BY grade
ORDER BY grade;
