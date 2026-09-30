# Data Quality Log · LendingClub

| # | Hallazgo | Filas | Decisión |
|---|---|---|---|
| 1 | Préstamos sin resultado final (Current, Late, Grace Period) | ≈ 912,000 | Excluidos: sin desenlace |
| 2 | Política de crédito antigua ("Does not meet the credit policy") | 2,749 | Excluidos |
| 3 | `loan_status` vacío | 33 | Excluidos |
| 4 | `term` con espacio inicial y texto | todas | Convertido a entero (`term_months`) |
| 5 | Fechas en formato `Mon-YYYY` | todas | `TO_DATE`, día 1 por defecto |
| 6 | `emp_length` vacío | 78,516 | Conservado como `Unknown` |
| 7 | `home_ownership` ANY/OTHER/NONE | 478 | Agrupado en `OTHER` |
| 8 | `last_pymnt_d` vacío (todos Charged Off, con pagos hasta 31,584) | 2,313 | Conservado como `NULL`; no usar para saber si pagó |
| 9 | `annual_inc` = 0 | 361 | `NULL` |
| 10 | `dti` < 0 o >= 100 (umbral supuesto) | 537 | `NULL` |
| 11 | `dti` vacío | 374 | Conservado como `NULL` |
| 12 | `revol_util` > 100 (máx 892.3) | 4,687 | Conservado; reportar mediana |
| 13 | `revol_util` vacío | 857 | Conservado como `NULL` |
