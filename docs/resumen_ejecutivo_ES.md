# LendingClub · Análisis de riesgo de crédito y cobranza (2007–2018)

**Autora:** Dámaris Cubos Rosas · **Herramientas:** PostgreSQL · SQL · Python (preparación de datos) · Git y GitHub · Tableau Public
**Datos:** LendingClub, préstamos aprobados 2007–2018 (Kaggle, publicado por un tercero) · 1,345,350 préstamos cerrados · cifras en dólares (USD)

---

## 🎯 Mensaje principal

> **En todos los grades, LendingClub cobró más interés del que perdió. Pero a mayor riesgo, el interés cubre la pérdida menos veces (de 4.1 en el grade A a cerca de 1.7 de D a G), y cuando un préstamo falla solo se recupera cerca del 13% del capital no pagado, sea cual sea el grade.**

---

## 1. Contexto

LendingClub es una plataforma de préstamos personales en Estados Unidos: conecta a personas que piden dinero con inversionistas que lo financian. Cada préstamo recibe una calificación de riesgo (*grade*, de A, el más seguro, a G, el más riesgoso) y una tasa de interés acorde.

El análisis se planteó como un **caso de negocio simulado**. Las preguntas las definí yo, a partir de los datos disponibles:

1. ¿Cuánto se presta y cómo evoluciona?
2. ¿Qué proporción de los préstamos no se paga?
3. ¿Qué perfiles de cliente y qué tipos de préstamo son más riesgosos?
4. ¿Cuánto se recupera de lo que no se pagó?

**Cómo se leen las cifras.** Un préstamo solo se puede juzgar cuando ya terminó. Por eso el análisis usa los préstamos con resultado final (pagados o incumplidos). Para comparar riesgo y retorno entre grades se usan, además, solo los préstamos **cuyo plazo ya venció** al cierre de los datos (673,553 préstamos, de 2007 a 2015). En el resto del documento se indica cuál base se usa en cada cifra.

---

## 2. Hallazgos principales

### 📈 Cuánto se presta
- La emisión anual creció de **5 millones** de dólares en 2007 a **7,936 millones** en 2018.
- Entre 2015 y 2017 se estancó (6,418, 6,401 y 6,585 millones) y en 2018 volvió a subir.
- Los años recientes están **incompletos**: de lo emitido en 2018, solo el 11.4% ya cerró. Sus tasas de incumplimiento no son comparables con las de años anteriores.

### ⚠️ Quién incumple (cohortes con plazo vencido)
- **14.81%** de los préstamos terminó incumplido (19.96% si se cuentan todos los préstamos cerrados).
- **Por grade:** el incumplimiento sube de 5.5% en el grade A (el más seguro) a 37.5% en el G (el más riesgoso), unas 6.8 veces más. La tasa de interés promedio también sube, de 7.2% a 24.9%, pero solo unas 3.4 veces más: el riesgo crece más rápido que el precio.
- **Por puntaje FICO:** los clientes con peor puntaje incumplen más. El FICO (de 300 a 850) resume qué tan bien ha pagado una persona sus deudas anteriores. Incumplió el 19.1% de los clientes con menos de 680 puntos y solo el 4.7% de los que tenían 780 o más.
- **Por deuda sobre ingreso (DTI):** los clientes con más deuda respecto a su ingreso incumplen más. El DTI mide qué parte del ingreso mensual de una persona ya se va en pagar deudas: quien gana 4,000 dólares al mes y paga 800 en deudas tiene un DTI de 20%. Incumplió el 11.5% de los clientes con DTI menor de 10% y el 20.6% de los que tenían un DTI de 30% a 39.9%.
- **Por propósito:** los préstamos para negocio propio incumplen más (24.4%) y los de auto menos (11.8%).
- **Por plazo** (todos los cerrados): los de 60 meses incumplen más que los de 36 en los siete grades, entre 1.05 y 1.79 veces más. Parte de la diferencia global se debe a que los grades riesgosos usan más plazos largos.
- **Verificación de ingreso:** los clientes verificados incumplen más (17.8% contra 11.7%). Lo más probable es que la plataforma verifique más a quien ya parece riesgoso, y no que verificar cause el incumplimiento. Es una explicación coherente con los datos, no una prueba.

### 💰 Ganancia, pérdida y cobranza (cohortes con plazo vencido)

| Grade | Interés y cargos cobrados | Pérdida neta | Retorno | Veces que el interés cubre la pérdida |
|---|---|---|---|---|
| A | 9.7% | 2.3% | 7.3% | 4.1 |
| B | 14.8% | 5.4% | 9.4% | 2.7 |
| C | 19.8% | 9.6% | 10.3% | 2.1 |
| D | 23.8% | 13.8% | 10.1% | 1.7 |
| E | 31.1% | 18.2% | 12.9% | 1.7 |
| F | 38.5% | 22.6% | 16.0% | 1.7 |
| G | 41.0% | 24.2% | 16.8% | 1.7 |

*Todo como porcentaje de lo prestado. Retorno = interés y cargos − pérdida neta; por ejemplo, un retorno de 7.3% significa que por cada 100 dólares prestados se cobraron 107.3. Son cifras acumuladas de toda la vida del préstamo, no anuales.*

- **Todos los grades dejaron ganancia.** Los más riesgosos dejaron más ganancia, pero con menos colchón. El colchón es cuántas veces tendrían que crecer las pérdidas para borrar la ganancia: 4.1 veces en el grade A y solo 1.7 veces en el G. Con un colchón chico, una racha peor de lo esperado se come la ganancia con más facilidad.
- **La cobranza rinde poco y parejo.** De unos 797 millones de dólares de capital no pagado se recuperaron unos 102 millones (cerca del **13%**), y el porcentaje es casi igual en todos los grades (12.5% a 13.5%). Una explicación probable es que son préstamos sin garantía.
- **La pérdida neta total** fue de unos 696 millones, el 7.9% de lo prestado.
- **Los clientes con más deuda respecto a su ingreso dejaron menos ganancia.** Los préstamos a clientes con DTI menor de 10% dejaron un retorno de 9.75%: por cada 100 dólares prestados se cobraron 109.75. Con DTI de 30% a 39.9%, el retorno fue de 8.39% (108.39 por cada 100). Estos clientes sí pagaron una tasa algo mayor (13.9%, contra 11.8% de los de DTI menor de 10%), pero no alcanzó para compensar que incumplen más.

---

## 3. Recomendaciones

Son ideas para **evaluar o probar**, no conclusiones definitivas: los datos no permiten asegurar que una acción produzca el efecto estimado.

| # | Recomendación | Por qué (dato) | KPI y meta | Impacto estimado* |
|---|---|---|---|---|
| 1 | **Evaluar si la tasa de interés debería tomar más en cuenta el DTI** (la parte del ingreso mensual que el cliente ya destina a pagar deudas), o limitar de forma experimental los préstamos a clientes con DTI de 30% o más. | Con DTI de 30% a 39.9% incumple el 20.6% de los clientes (11.5% con DTI menor de 10%), pero la tasa solo sube de 11.8% a 13.9%. Por eso el retorno cae de 9.75% a 8.39%. | Retorno de los préstamos a clientes con DTI de 30% a 39.9%: **de 8.39% a 9.07%** (el retorno de quienes tienen DTI de 20% a 29.9%). Es cobrar 109.07 en lugar de 108.39 por cada 100 prestados. Se mediría en los préstamos nuevos de una prueba de 12 meses | ≈ **4.1 millones** de dólares sobre 608 millones prestados en esa banda (hasta ≈ 9.8 millones si igualara la mejor banda) |
| 2 | **Probar una cobranza más temprana y diferenciada por segmento**, en un piloto. | La recuperación es casi igual en todos los grades (12.5% a 13.5%), lo que sugiere que no se trata distinto a cada riesgo. Quedan sin pagar unos 797 millones. | Tasa de recuperación (qué parte del capital no pagado se logra cobrar): **de 12.8% a 14%** en el piloto | ≈ **9.6 millones** de dólares sobre el capital no pagado histórico |

\* *Estimaciones aproximadas sobre cohortes históricas con plazo vencido (2007–2015), en retorno acumulado, no anual. Calculadas como la diferencia que produciría la acción, no el total del segmento. No descuentan el costo de operar la acción ni de una cobranza adicional.*

### Para seguimiento

- **Vigilar los grades D a G.** El interés cubre la pérdida apenas 1.7 veces: un colchón delgado. El grade G tiene solo 1,866 préstamos en estas cohortes, así que su rendimiento es menos confiable.
- **Reportar siempre el riesgo por cohorte**, mostrando qué porcentaje de cada año ya cerró. Sin eso, los años recientes parecen más o menos riesgosos de lo que son.

---

## 4. Supuestos y limitaciones

### Decisiones que tomé y por qué

| Decisión | Por qué | Qué limita |
|---|---|---|
| No usar el archivo de solicitudes rechazadas | Mis preguntas son sobre lo que pasa con un préstamo después de aprobado: si se paga, cuánto se pierde y cuánto se recupera. Una solicitud rechazada nunca se convirtió en préstamo, así que no tiene pagos, pérdida ni recuperación. Ese archivo serviría para otra pregunta: si la política de aprobación fue acertada. | Solo se ven clientes que ya pasaron el filtro de LendingClub. No se puede evaluar a quién se rechazó ni si fue una buena decisión. |
| Excluir los préstamos vigentes, en atraso o en periodo de gracia (≈ 912 mil) | Aún no tienen resultado final: no se sabe si se pagarán. Contarlos como pagados subestimaría el riesgo, y contarlos como incumplidos lo exageraría. | Las cohortes recientes y los préstamos a 60 meses quedan incompletos. Los datos lo muestran: los préstamos cuyo plazo aún no vence tienen más incumplimiento, porque los que fallan suelen cerrar antes que los que pagan hasta el final. Por eso las comparaciones de riesgo y retorno usan solo préstamos de plazo vencido. |
| Excluir los préstamos de una política de crédito antigua (2,749) | Son pocos (0.2% del total) y vienen de reglas de crédito distintas; mezclarlos complicaría las comparaciones sin aportar. | Lo decidí por su tamaño; no analicé si se comportan distinto. |
| Excluir 33 préstamos sin estatus | Sin estatus no hay resultado que analizar. | Casi ninguna: son 33 de más de 2.2 millones. |
| Tomar el 31 de diciembre de 2018 como cierre de los datos | Los archivos no dicen la fecha exacta de corte. El nombre del archivo indica que llega al cuarto trimestre de 2018 y el último préstamo emitido es de diciembre de 2018, así que usé el último día de ese año. Con esa fecha se decide si un préstamo ya cumplió su plazo (fecha de emisión más plazo). | Es un supuesto. Si el corte real fue anterior, algunos préstamos se habrían tratado como vencidos sin serlo. No pude verificarlo. |
| No separar por completo el efecto del DTI y del plazo del efecto del grade | El grade lo asigna LendingClub con un modelo propio que usa el puntaje FICO y otras variables, y es probable que ya incluya parte del riesgo que miden el DTI y el plazo. Para el plazo sí comparé dentro de cada grade y la diferencia se mantuvo en los siete. Con el DTI aún no lo he hecho. Y aun comparando dentro de un grade, es una agrupación gruesa de clientes, y LendingClub usa información que no tengo. | Lo que encontré sobre DTI y plazo son asociaciones, no efectos probados. Por eso las recomendaciones se plantean como pruebas. |

### Otras limitaciones

- **Los retornos son acumulados, no anuales**, y no incluyen costos operativos ni las comisiones de la plataforma. No son comparables con las tasas anualizadas que reporta un banco.
- **`total_pymnt` ya incluye las recuperaciones.** Lo verifiqué en los 184,684 castigados con recuperación, para no contarlas dos veces. La comisión de cobranza se resta aparte para el retorno neto; es una deducción mía que no pude confirmar con el diccionario de datos.
- **Muestras pequeñas:** el grade G (1,866 préstamos), la banda de DTI de 40 o más (29) y el propósito `educational` (326) no son confiables.
- **Valores imposibles:** `annual_inc` igual a 0 y `dti` negativo o de 100 o más se convirtieron en vacíos, sin borrar los préstamos, para no perder su resultado de pago. El umbral de 100 es un supuesto mío. Cada decisión de limpieza está en `docs/data_quality_log.md`.
- **Fuente:** el dataset de Kaggle lo publica un tercero, no LendingClub.

---

## 5. Próximos pasos sugeridos

1. Separar el efecto del DTI del efecto del grade, comparando dentro de cada grade.
2. Anualizar el retorno, con las fechas de cada pago.
3. Estimar a qué edad suelen fallar los préstamos (curva de cohorte), para saber cuánto subirá la tasa de las cohortes recientes cuando cierren.
4. Incorporar los costos de operación y de cobranza.
