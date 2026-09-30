import csv
import collections

c = collections.defaultdict(collections.Counter)
with open('raw/accepted_2007_to_2018Q4.csv', newline='', encoding='utf-8', errors='replace') as f:
    r = csv.reader(f)
    h = next(r)
    i = h.index('issue_d')
    j = h.index('loan_status')
    for row in r:
        if len(row) > j and row[i][-4:] in ('2014', '2015', '2016', '2017', '2018'):
            k = 'cerrado' if row[j] in ('Fully Paid', 'Charged Off', 'Default') else 'abierto'
            c[row[i][-4:]][k] += 1

for y in sorted(c):
    cl = c[y]['cerrado']
    t = cl + c[y]['abierto']
    print(y, f'{t:>9,} total', f'{cl:>9,} cerrados', f'{100*cl/t:5.1f}% cerrados')
