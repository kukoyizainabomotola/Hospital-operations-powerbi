# Hospital Operations, Cost & Patient Flow Intelligence

**AnalystLab Africa Experience Lab | Week 3 | Track A: Data Analytics**
Prepared by Kukoyi Zainab Omotola

A six-page Power BI dashboard and supporting documentation that investigates encounter volumes, encounter classes, claim costs, payer coverage and procedure use for one hospital (2 January 2011 to 5 February 2022).

![Overview page](screenshots/01_Overview.png)

## Business problem

A healthcare organisation holds detailed records but no single view of how activity, cost, payer coverage and procedures relate to one another. This project answers:

- How have encounter volumes changed over time?
- Which encounter classes account for the most encounters and the most cost?
- How much claim cost do payers cover, and how many encounters have no recorded coverage?
- Which procedures are most frequent, and which have the highest average base cost?

**Intended users:** hospital operations managers and finance and planning leads.

## Data

The dataset pack was supplied by AnalystLab Africa for this assignment and is **not redistributed in this repository**, because the source files contain patient-level identifiers. To reproduce the report, place the supplied files in a local `data/` folder.

| File | Records | Used for |
|---|---|---|
| encounters.csv | 27,891 | Volumes, classes, duration, costs, payer coverage |
| procedures.csv | 47,701 | Procedure frequency and base cost |
| payers.csv | 10 | Payer analysis |
| patients.csv | 974 | Only Id, birth date and gender were loaded |
| organizations.csv | 1 | Context only |
| data_dictionary.csv | 65 | Reference |

## Tools

Power BI, Power Query, DAX, Excel and SQL (MySQL).

## Method

1. **Inspected** every file for record counts, missing values, duplicates, data types, date validity and key relationships. Nothing was removed or imputed.
2. **Cleaned and modelled in Power Query:** typed columns, kept only the fields needed, converted timestamps to date/time with time zone, added `StartDate` and `DurationHours`, and removed identifying columns from `patients`.
3. **Modelled** encounters to patients, payers, organizations and a date table, and procedures to encounters.
4. **Measured** with DAX (see [`dax/measures.md`](dax/measures.md)).
5. **Built** six report pages: Overview, Volume Trend, Encounter Classes, Cost & Payer Coverage, Procedures and Data Notes.
6. **Validated** key figures independently (see below).

## Key findings

All figures come from the supplied data.

- **Scale:** 27,891 encounters, 974 patients and about $101.5M of total claim cost (average $3,640 per encounter). The currency is not stated in the data.
- **Volume:** peaked at 3,885 encounters in 2014 (February 2014 alone has 1,179, against about 200 in a typical month), settled at roughly 2,200 to 2,500 a year from 2015 to 2020 and rose to 3,530 in 2021. 2022 is partial.
- **Encounter classes:** ambulatory (45.0%) and outpatient (22.6%) make up 67.5% of encounters but 49.6% of claim cost. Urgent care is 13.1% of encounters and 23.0% of claim cost. Inpatient has the highest average claim cost ($7,761) and 58 of the 75 encounters lasting over 24 hours.
- **Payer coverage:** payers are recorded as covering $31.1M (30.6% of claim cost). 13,586 encounters (48.7%) have no recorded coverage. Five private insurers (Humana, Aetna, UnitedHealthcare, Cigna and Anthem) record 0.0% to 0.2% of their claim cost as covered, while Medicare, Medicaid and Dual Eligible record 78% to 94%. The data does not explain why.
- **Procedures:** 163 procedure descriptions. The ten most frequent make up 63% of records. Electrical cardioversion is the largest cost concentration (1,383 records, average base cost $25,903, about $35.8M in total). 47.4% of encounters have no procedure record.

## Recommendations

1. Check how payer coverage is recorded for the five private insurers with near-zero coverage.
2. Quantify the exposure from encounters with no recorded payer coverage, by adding payment data.
3. Prioritise cost review for urgent care and inpatient encounters.
4. Validate the recorded cost of electrical cardioversion and other high-cost procedures.
5. Improve data completeness and explain unusual volume.

The full reasoning, limitations and information needed for each is in the executive summary.

## Data quality and limitations

- One hospital only. 2022 contains data only to 5 February.
- Zero payer coverage may mean uninsured, unrecorded or unpaid. The data does not say which.
- Procedure base cost is not claim cost and must not be added to it.
- Procedure start times fall outside their encounter's time window in about 51% of cases, so procedures are dated by their encounter.
- The median encounter lasts 15 minutes. Of the 75 encounters over 24 hours, 13 last over 30 days.
- 47.4% of encounters have no procedure record. Four procedure codes appear under more than one description.
- The data holds no clinical outcomes, so no clinical claims are made.

See [`docs/Week3_Data_Quality_Assessment.docx`](docs/Week3_Data_Quality_Assessment.docx) for the full issues log.

## Validation

Key dashboard figures were compared with independent calculations in Excel (formulas on the source CSV files) and SQL (MySQL queries on a practice `hospital_db`), and filter behaviour was tested. Evidence is in [`validation/`](validation/) and the queries are in [`sql/validation_queries.sql`](sql/validation_queries.sql).

| Check | Source file | Power BI | Excel | SQL | Result |
|---|---|---|---|---|---|
| Total encounters | 27,891 | 27,891 | 27,891 | 27,891 | Match |
| Total claim cost | 101,514,375.52 | $101.5M (card) | 101,514,375.5 (as displayed) | 101,514,375.52 | Match |
| Total payer coverage | 31,097,506.99 | $31.1M (card) | 31,097,506.99 | 31,097,506.99 | Match |
| Zero coverage encounters | 13,586 | 13,586 | 13,586 | 13,586 | Match |
| Procedure count | 47,701 | 47,701 | 47,701 | 47,701 | Match |
| Encounters over 24 hours | 75 | n/a | n/a | 75 | Match (SQL) |
| Encounters in 2014 (Year slicer) | 3,885 | 3,885 | 3,885 | 3,885 | Match |
| Inpatient encounters (class slicer) | 1,135 | 1,135 | 1,135 | 1,135 | Match |

n/a = not checked with that tool. Power BI card values are shown to display precision.

**Filter tests.** With the Year slicer set to 2014 the Overview cards show 3,885 encounters, $12.0M claim cost, 29.6% payer coverage, 50.9% zero coverage and a $3,092 average claim cost. With the encounter class set to inpatient they show 1,135 encounters, $8.8M, 41.9%, 48.5% and $7,761. Both agree with values calculated directly from the source file.

## Reproducing the report

1. Obtain the supplied dataset pack and place the CSV files in a local folder.
2. Build the report in Power BI Desktop (the .pbix file itself is not included here) and point each query at your local copy of the CSV files in Power Query (Transform data > Data source settings).
3. Recreate the model relationships and measures from [`dax/measures.md`](dax/measures.md).
4. To run the SQL checks, use an **isolated practice MySQL instance only**: the supplied setup script drops and recreates a database named `hospital_db`. Then run [`sql/validation_queries.sql`](sql/validation_queries.sql).

## Repository contents

```
README.md
docs/            Tasks 1 to 4, Data Quality Assessment, Executive Summary, KPI Definitions
dax/             measures.md
sql/             validation_queries.sql
screenshots/     six dashboard pages
validation/      validation workbook and result screenshots
```

## Responsible data handling

- Patient names, addresses and other identifiers were removed before loading and appear nowhere in the dashboard or screenshots.
- The raw data, the setup script and the Power BI file are not included in this repository.
- No clinical claims or treatment recommendations are made.

## Acknowledgements

Data and brief: AnalystLab Africa. AI assistance (Claude, by Anthropic) was used for planning, data profiling and drafting documentation. All figures were checked against the source data.

#AnalystLabAfrica
