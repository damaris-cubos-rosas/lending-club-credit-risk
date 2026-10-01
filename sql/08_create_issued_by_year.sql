DROP TABLE IF EXISTS issued_by_year;

CREATE TABLE issued_by_year (
    issue_year             INT PRIMARY KEY,
    loans_issued           INT,
    funded_issued_millions NUMERIC,
    loans_closed           INT,
    pct_closed             NUMERIC
);
