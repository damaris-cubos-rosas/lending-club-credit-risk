# LendingClub · Credit Risk & Collections Analysis (2007–2018)

**Author:** Dámaris Cubos Rosas · **Tools:** PostgreSQL · SQL · Python (data preparation) · Git & GitHub · Tableau Public
**Data:** LendingClub, approved loans 2007–2018 (Kaggle, published by a third party) · 1,345,350 closed loans · figures in US dollars (USD)

---

## 🎯 Key message

> **In every grade, LendingClub collected more interest than it lost. But the riskier the grade, the fewer times interest covers the loss (from 4.1 in grade A to about 1.7 in grades D to G), and when a loan fails only about 13% of the unpaid principal is recovered, whatever the grade.**

---

## 1. Context

LendingClub is a US personal lending platform: it connects people who need money with investors who fund the loans. Each loan receives a risk rating (*grade*, from A, the safest, to G, the riskiest) and an interest rate to match.

The analysis was framed as a **simulated business case**. I defined the questions myself, based on the available data:

1. How much is lent, and how is it evolving?
2. What share of loans is not repaid?
3. Which customer profiles and loan types are riskiest?
4. How much of the unpaid amount is recovered?

**How to read the figures.** A loan can only be judged once it has ended, so the analysis uses loans with a final outcome (fully paid or defaulted). To compare risk and return across grades, it also uses only loans **whose term has already ended** at the data cutoff (673,553 loans, from 2007 to 2015). Throughout this document, each figure states which base it uses.

---

## 2. Key findings

### 📈 How much is lent
- Annual issuance grew from **5 million** dollars in 2007 to **7,936 million** in 2018.
- It stayed about the same between 2015 and 2017 (6,418, 6,401 and 6,585 million) and rose again in 2018.
- Recent years are **incomplete**: of what was issued in 2018, only 11.4% has closed. Their default rates are not comparable with earlier years.

### ⚠️ Who defaults (loans with an ended term)
- **14.81%** of loans ended in default (19.96% if all closed loans are counted).
- **By grade:** default rises from 5.5% in grade A (the safest) to 37.5% in grade G (the riskiest), about 6.8 times higher. The average interest rate also rises, from 7.2% to 24.9%, but only about 3.4 times higher: risk grows faster than price.
- **By FICO score:** customers with lower scores default more. FICO (from 300 to 850) summarizes how well a person has repaid past debts. 19.1% of customers with under 680 points defaulted, versus only 4.7% of those with 780 or more.
- **By debt-to-income ratio (DTI):** customers with more debt relative to their income default more. DTI measures what share of a person's monthly income already goes to debt payments: someone who earns 4,000 dollars a month and pays 800 in debts has a DTI of 20%. 11.5% of customers with a DTI under 10% defaulted, versus 20.6% of those with a DTI of 30% to 39.9%.
- **By purpose:** small-business loans default more (24.4%) and car loans less (11.8%).
- **By term** (all closed loans): 60-month loans default more than 36-month loans in all seven grades, between 1.05 and 1.79 times more. Part of the overall difference exists because the riskier grades use longer terms.
- **Income verification:** verified customers default more (17.8% versus 11.7%). The most likely explanation is that the platform verifies more of the customers who already look risky, not that verification causes default. It is an explanation consistent with the data, not a proof.

### 💰 Profit, loss and collections (loans with an ended term)

| Grade | Interest and fees collected | Net loss | Return | Times interest covers the loss |
|---|---|---|---|---|
| A | 9.7% | 2.3% | 7.3% | 4.1 |
| B | 14.8% | 5.4% | 9.4% | 2.7 |
| C | 19.8% | 9.6% | 10.3% | 2.1 |
| D | 23.8% | 13.8% | 10.1% | 1.7 |
| E | 31.1% | 18.2% | 12.9% | 1.7 |
| F | 38.5% | 22.6% | 16.0% | 1.7 |
| G | 41.0% | 24.2% | 16.8% | 1.7 |

*All as a percentage of the amount lent. Return = interest and fees − net loss; for example, a return of 7.3% means that for every 100 dollars lent, 107.3 were collected. These are cumulative figures over the whole life of the loan, not annual.*

- **Every grade was profitable.** The riskiest grades earned more profit, but with a thinner cushion. The cushion is how many times losses would have to grow to wipe out the profit: 4.1 times in grade A and only 1.7 times in grade G. With a thin cushion, a worse-than-expected streak eats the profit more easily.
- **Collections yield little, and about the same everywhere.** Of roughly 797 million dollars in unpaid principal, about 102 million were recovered (close to **13%**), and the percentage is almost the same in every grade (12.5% to 13.5%). A likely explanation is that these loans are unsecured.
- **Total net loss** was about 696 million, 7.9% of the amount lent.
- **Customers with more debt relative to their income earned less profit.** Loans to customers with a DTI under 10% returned 9.75%: for every 100 dollars lent, 109.75 were collected. With a DTI of 30% to 39.9%, the return was 8.39% (108.39 per 100). These customers did pay a somewhat higher rate (13.9%, versus 11.8% for those with a DTI under 10%), but it was not enough to offset the fact that they default more.

---

## 3. Recommendations

These are ideas to **evaluate or test**, not final conclusions: the data cannot guarantee that an action will produce the estimated effect.

| # | Recommendation | Why (evidence) | KPI and target | Estimated impact* |
|---|---|---|---|---|
| 1 | **Evaluate whether the interest rate should take DTI into account more** (the share of monthly income the customer already spends on debt payments), or restrict, as an experiment, loans to customers with a DTI of 30% or more. | With a DTI of 30% to 39.9%, 20.6% of customers default (11.5% with a DTI under 10%), but the rate only rises from 11.8% to 13.9%. That is why the return drops from 9.75% to 8.39%. | Return on loans to customers with a DTI of 30% to 39.9%: **from 8.39% to 9.07%** (the return of customers with a DTI of 20% to 29.9%). That means collecting 109.07 instead of 108.39 per 100 lent. It would be measured on the new loans of a 12-month trial | ≈ **4.1 million** dollars on 608 million lent in that band (up to ≈ 9.8 million if it matched the best band) |
| 2 | **Test earlier collections, differentiated by segment**, in a pilot. | Recovery is almost the same in every grade (12.5% to 13.5%), which suggests each risk level is not treated differently. About 797 million remain unpaid. | Recovery rate (the share of unpaid principal that is collected): **from 12.8% to 14%** in the pilot | ≈ **9.6 million** dollars on the historical unpaid principal |

\* *Rough estimates on historical cohorts with an ended term (2007–2015), in cumulative rather than annual return. Calculated as the difference the action would make, not the segment total. They do not subtract the cost of running the action or of additional collection efforts.*

### For follow-up

- **Watch grades D to G.** Interest covers the loss only 1.7 times: a thin cushion. Grade G has only 1,866 loans in these cohorts, so its performance is less reliable.
- **Always report risk by cohort**, showing what percentage of each year has already closed. Without that, recent years look riskier or safer than they are.

---

## 4. Assumptions and limitations

### Decisions I made and why

| Decision | Why | What it limits |
|---|---|---|
| Not using the rejected-applications file | My questions are about what happens to a loan after it is approved: whether it is repaid, how much is lost and how much is recovered. A rejected application never became a loan, so it has no payments, loss or recovery. That file would answer a different question: whether the approval policy was sound. | Only customers who already passed LendingClub's filter are visible. It is not possible to evaluate who was rejected or whether that was a good decision. |
| Excluding current, late or grace-period loans (≈ 912 thousand) | They have no final outcome yet: it is unknown whether they will be repaid. Counting them as paid would understate risk, and counting them as defaulted would overstate it. | Recent cohorts and 60-month loans are incomplete. The data show it: loans whose term has not yet ended have higher default, because loans that fail tend to close earlier than loans that are repaid in full. That is why risk and return comparisons use only loans with an ended term. |
| Excluding loans from an old credit policy (2,749) | They are few (0.2% of the total) and come from different credit rules; mixing them in would complicate comparisons without adding value. | I decided this based on size; I did not analyze whether they behave differently. |
| Excluding 33 loans with no status | Without a status there is no outcome to analyze. | Almost none: 33 out of more than 2.2 million. |
| Using December 31, 2018 as the data cutoff | The files do not state the exact cutoff date. The file name indicates it runs to the fourth quarter of 2018 and the last loan issued is from December 2018, so I used the last day of that year. That date decides whether a loan has completed its term (issue date plus term). | It is an assumption. If the real cutoff was earlier, some loans would have been treated as ended when they were not. I could not verify it. |
| Not fully separating the effect of DTI and term from the effect of grade | LendingClub assigns the grade with its own model that uses the FICO score and other variables, and it likely already includes part of the risk that DTI and term measure. For term, I did compare within each grade and the difference held in all seven. For DTI, I have not done it yet. And even when comparing within a grade, it is a coarse grouping of customers, and LendingClub uses information I do not have. | What I found about DTI and term are associations, not proven effects. That is why the recommendations are framed as tests. |

### Other limitations

- **Returns are cumulative, not annual**, and they do not include operating costs or the platform's fees. They are not comparable with the annualized rates a bank reports.
- **`total_pymnt` already includes recoveries.** I verified this on the 184,684 charged-off loans with a recovery, so as not to count them twice. The collection fee is subtracted separately for the net return; that is my own deduction, which I could not confirm in the data dictionary.
- **Small samples:** grade G (1,866 loans), the DTI band of 40 or more (29) and the `educational` purpose (326) are not reliable.
- **Impossible values:** `annual_inc` equal to 0 and `dti` negative or 100 or more were converted to blanks, without deleting the loans, so as not to lose their repayment outcome. The threshold of 100 is my own assumption. Every cleaning decision is in `docs/data_quality_log.md`.
- **Source:** the Kaggle dataset is published by a third party, not by LendingClub.

---

## 5. Suggested next steps

1. Separate the effect of DTI from the effect of grade, by comparing within each grade.
2. Annualize the return, using the date of each payment.
3. Estimate at what age loans usually fail (cohort curve), to know how much the default rate of recent cohorts will rise once they close.
4. Include operating and collection costs.
