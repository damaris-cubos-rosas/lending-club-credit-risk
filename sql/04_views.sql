-- Préstamos cuyo plazo ya venció al cierre de los datos (supuesto: 2018-12-31).
-- Solo estos tienen una tasa de incumplimiento comparable entre cohortes.
CREATE OR REPLACE VIEW loans_mature AS
SELECT *
FROM loans
WHERE issue_date + make_interval(months => term_months) <= DATE '2018-12-31';
