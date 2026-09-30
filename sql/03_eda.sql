-- 3.1 Originación e incumplimiento por año
SELECT EXTRACT(YEAR FROM issue_date)::int AS anio,
       COUNT(*)                           AS prestamos,
       ROUND(SUM(funded_amnt) / 1000000, 1) AS prestado_millones,
       ROUND(100.0 * AVG(is_default), 2)  AS tasa_incumplimiento_pct
FROM loans
GROUP BY 1
ORDER BY 1;

-- 3.2 Incumplimiento por año y plazo (2012 en adelante)
SELECT EXTRACT(YEAR FROM issue_date)::int AS anio,
       term_months,
       COUNT(*)                          AS prestamos,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans
WHERE issue_date >= '2012-01-01'
GROUP BY 1, 2
ORDER BY 1, 2;

-- 3.3 Tasa de interés e incumplimiento por grade
SELECT grade,
       COUNT(*)                          AS prestamos,
       ROUND(AVG(int_rate), 2)           AS tasa_interes_prom,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans
GROUP BY grade
ORDER BY grade;
