-- Resumen por grade para Tableau (cohortes con plazo vencido)
CREATE OR REPLACE VIEW export_grade_summary AS
SELECT grade,
       COUNT(*)                                                   AS loans,
       ROUND(SUM(funded_amnt) / 1000000, 1)                       AS funded_millions,
       ROUND(AVG(int_rate), 2)                                    AS avg_interest_rate_pct,
       ROUND(100.0 * AVG(is_default), 2)                          AS default_rate_count_pct,
       ROUND(100.0 * SUM(funded_amnt * is_default)
             / SUM(funded_amnt), 2)                               AS default_rate_amount_pct,
       ROUND(100.0 * SUM(CASE WHEN is_default = 1 THEN recoveries ELSE 0 END)
             / NULLIF(SUM(CASE WHEN is_default = 1
                               THEN funded_amnt - total_rec_prncp ELSE 0 END), 0), 2) AS recovery_rate_pct,
       ROUND(100.0 * SUM(total_pymnt - total_rec_prncp - recoveries)
             / SUM(funded_amnt), 2)                               AS interest_and_fees_pct,
       ROUND(100.0 * SUM(CASE WHEN is_default = 1
                              THEN funded_amnt - total_rec_prncp - recoveries ELSE 0 END)
             / SUM(funded_amnt), 2)                               AS net_loss_pct,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(funded_amnt))
             / SUM(funded_amnt), 2)                               AS gross_return_pct,
       ROUND(100.0 * (SUM(total_pymnt) - SUM(collection_recovery_fee) - SUM(funded_amnt))
             / SUM(funded_amnt), 2)                               AS net_return_pct
FROM loans_mature
GROUP BY grade;
