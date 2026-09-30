import csv

SRC = "raw/accepted_2007_to_2018Q4.csv"
DST = "clean/loans_subset.csv"

KEEP_STATUS = {"Fully Paid", "Charged Off", "Default"}

COLS = [
    "id", "loan_amnt", "funded_amnt", "term", "int_rate", "installment",
    "grade", "sub_grade", "emp_length", "home_ownership", "annual_inc",
    "verification_status", "issue_d", "loan_status", "purpose", "addr_state",
    "dti", "delinq_2yrs", "earliest_cr_line", "fico_range_low",
    "fico_range_high", "inq_last_6mths", "open_acc", "revol_util",
    "total_pymnt", "total_rec_prncp", "recoveries", "collection_recovery_fee",
    "last_pymnt_d",
]

n_in = n_out = 0
with open(SRC, newline="", encoding="utf-8", errors="replace") as fin, \
     open(DST, "w", newline="", encoding="utf-8") as fout:
    r = csv.reader(fin)
    w = csv.writer(fout)
    h = next(r)
    idx = [h.index(c) for c in COLS]
    i_status = h.index("loan_status")
    w.writerow(COLS)
    for row in r:
        n_in += 1
        if len(row) > i_status and row[i_status] in KEEP_STATUS:
            w.writerow([row[i] for i in idx])
            n_out += 1

print(f"Filas leídas:     {n_in:,}")
print(f"Filas guardadas:  {n_out:,}")
print(f"Columnas:         {len(COLS)}")
