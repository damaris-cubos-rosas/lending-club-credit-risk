-- Cohortes por año de emisión para Tableau.
-- Volumen: todos los préstamos emitidos. Incumplimiento: solo los cerrados.
CREATE OR REPLACE VIEW export_cohorts AS
SELECT i.issue_year,
       i.loans_issued,
       i.funded_issued_millions,
       i.loans_closed,
       i.pct_closed,
       ROUND(100.0 * AVG(l.is_default), 2) AS default_rate_closed_pct
FROM issued_by_year i
JOIN loans l
  ON EXTRACT(YEAR FROM l.issue_date) = i.issue_year
GROUP BY i.issue_year, i.loans_issued, i.funded_issued_millions,
         i.loans_closed, i.pct_closed;
