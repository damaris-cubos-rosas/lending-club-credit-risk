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


-- 3.4 Incumplimiento por estatus de verificación (cohortes vencidas)
SELECT verification_status,
       COUNT(*)                          AS prestamos,
       ROUND(AVG(int_rate), 2)           AS tasa_interes_prom,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans_mature
GROUP BY verification_status
ORDER BY 4;

-- 3.5 Incumplimiento por banda de FICO (cohortes vencidas)
SELECT CASE WHEN fico_low < 680 THEN '1) menos de 680'
            WHEN fico_low < 700 THEN '2) 680-699'
            WHEN fico_low < 720 THEN '3) 700-719'
            WHEN fico_low < 740 THEN '4) 720-739'
            WHEN fico_low < 780 THEN '5) 740-779'
            ELSE '6) 780 o más' END       AS banda_fico,
       COUNT(*)                          AS prestamos,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans_mature
GROUP BY 1
ORDER BY 1;

-- 3.6 Verificación dentro de cada grade (separa el efecto del grade)
SELECT grade,
       verification_status,
       COUNT(*)                          AS prestamos,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans_mature
GROUP BY grade, verification_status
ORDER BY grade, verification_status;


-- 3.7 Perfil promedio por estatus de verificación
SELECT verification_status,
       ROUND(AVG(funded_amnt))           AS monto_prom,
       ROUND(AVG(dti), 1)                AS dti_prom,
       ROUND(AVG(fico_low))              AS fico_prom
FROM loans_mature
GROUP BY verification_status
ORDER BY 1;

-- 3.8 Incumplimiento por banda de monto
SELECT CASE WHEN funded_amnt < 5000  THEN '1) menos de 5,000'
            WHEN funded_amnt < 10000 THEN '2) 5,000-9,999'
            WHEN funded_amnt < 20000 THEN '3) 10,000-19,999'
            WHEN funded_amnt < 30000 THEN '4) 20,000-29,999'
            ELSE '5) 30,000 o más' END    AS banda_monto,
       COUNT(*)                          AS prestamos,
       ROUND(100.0 * AVG(is_default), 2) AS tasa_incumplimiento_pct
FROM loans_mature
GROUP BY 1
ORDER BY 1;
