DROP TABLE IF EXISTS loans;

CREATE TABLE loans AS
SELECT
    id::bigint                                   AS loan_id,
    loan_amnt::numeric                           AS loan_amnt,
    funded_amnt::numeric                         AS funded_amnt,
    TRIM(REPLACE(term, 'months', ''))::int       AS term_months,
    int_rate::numeric                            AS int_rate,
    installment::numeric                         AS installment,
    grade,
    sub_grade,
    COALESCE(NULLIF(TRIM(emp_length), ''), 'Unknown') AS emp_length,
    CASE WHEN home_ownership IN ('ANY','OTHER','NONE')
         THEN 'OTHER' ELSE home_ownership END    AS home_ownership,
    NULLIF(annual_inc::numeric, 0)               AS annual_inc,
    verification_status,
    TO_DATE(issue_d, 'Mon-YYYY')                 AS issue_date,
    loan_status,
    CASE WHEN loan_status = 'Fully Paid' THEN 0 ELSE 1 END AS is_default,
    purpose,
    addr_state,
    CASE WHEN dti::numeric < 0 OR dti::numeric >= 100
         THEN NULL ELSE dti::numeric END         AS dti,
    delinq_2yrs::numeric::int                    AS delinq_2yrs,
    TO_DATE(earliest_cr_line, 'Mon-YYYY')        AS earliest_cr_line,
    fico_range_low::numeric::int                 AS fico_low,
    fico_range_high::numeric::int                AS fico_high,
    inq_last_6mths::numeric::int                 AS inq_last_6mths,
    open_acc::numeric::int                       AS open_acc,
    revol_util::numeric                          AS revol_util,
    total_pymnt::numeric                         AS total_pymnt,
    total_rec_prncp::numeric                     AS total_rec_prncp,
    recoveries::numeric                          AS recoveries,
    collection_recovery_fee::numeric             AS collection_recovery_fee,
    TO_DATE(last_pymnt_d, 'Mon-YYYY')            AS last_pymnt_date
FROM loans_raw;

ALTER TABLE loans ADD PRIMARY KEY (loan_id);
