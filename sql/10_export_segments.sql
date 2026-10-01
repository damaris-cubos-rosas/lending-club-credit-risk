-- Segmentos de riesgo para Tableau (cohortes con plazo vencido), formato largo.
CREATE OR REPLACE VIEW export_segments AS
WITH seg AS (
    SELECT 'FICO band' AS dimension,
           CASE WHEN fico_low < 680 THEN '1) <680'
                WHEN fico_low < 700 THEN '2) 680-699'
                WHEN fico_low < 720 THEN '3) 700-719'
                WHEN fico_low < 740 THEN '4) 720-739'
                WHEN fico_low < 780 THEN '5) 740-779'
                ELSE '6) 780+' END AS segment, *
    FROM loans_mature
    UNION ALL
    SELECT 'DTI band',
           CASE WHEN dti IS NULL THEN '0) no data'
                WHEN dti < 10 THEN '1) <10'
                WHEN dti < 20 THEN '2) 10-19.9'
                WHEN dti < 30 THEN '3) 20-29.9'
                WHEN dti < 40 THEN '4) 30-39.9'
                ELSE '5) 40+' END, *
    FROM loans_mature
    UNION ALL
    SELECT 'Purpose', purpose, * FROM loans_mature
    UNION ALL
    SELECT 'Income verification', verification_status, * FROM loans_mature
    UNION ALL
    SELECT 'Term (months)', term_months::text, * FROM loans_mature
    UNION ALL
    SELECT 'Home ownership', home_ownership, * FROM loans_mature
)
SELECT dimension,
       segment,
       COUNT(*)                                          AS loans,
       ROUND(AVG(int_rate), 2)                           AS avg_interest_rate_pct,
       ROUND(100.0 * AVG(is_default), 2)                 AS default_rate_pct,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(funded_amnt))
             / SUM(funded_amnt), 2)                      AS gross_return_pct
FROM seg
GROUP BY dimension, segment;
