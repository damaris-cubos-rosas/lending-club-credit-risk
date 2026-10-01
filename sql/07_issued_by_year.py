import csv
import collections

SRC = "raw/accepted_2007_to_2018Q4.csv"
DST = "clean/issued_by_year.csv"
CLOSED = {"Fully Paid", "Charged Off", "Default"}

issued = collections.Counter()
funded = collections.Counter()
closed = collections.Counter()

with open(SRC, newline="", encoding="utf-8", errors="replace") as f:
    r = csv.reader(f)
    h = next(r)
    i_date = h.index("issue_d")
    i_stat = h.index("loan_status")
    i_fund = h.index("funded_amnt")
    for row in r:
        if len(row) <= max(i_date, i_stat, i_fund) or not row[i_date]:
            continue
        year = row[i_date][-4:]
        issued[year] += 1
        funded[year] += float(row[i_fund] or 0)
        if row[i_stat] in CLOSED:
            closed[year] += 1

with open(DST, "w", newline="", encoding="utf-8") as out:
    w = csv.writer(out)
    w.writerow(["issue_year", "loans_issued", "funded_issued_millions", "loans_closed", "pct_closed"])
    for y in sorted(issued):
        w.writerow([y, issued[y], round(funded[y] / 1_000_000, 1),
                    closed[y], round(100 * closed[y] / issued[y], 1)])

print("Archivo creado:", DST)
