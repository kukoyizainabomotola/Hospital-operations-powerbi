# Hospital Operations, Cost & Patient Flow Intelligence

**AnalystLab Africa Experience Lab | Week 3 | Track A: Data Analytics**
Prepared by Kukoyi Zainab Omotola | #AnalystLabAfrica

An interactive Power BI dashboard that helps decision-makers understand hospital encounter patterns, claim costs, payer coverage and procedure utilisation, with documented data-quality checks and independent validation of every headline KPI.

## Business problem
A healthcare organisation wants to understand its encounter volumes, costs, payer coverage, procedure use and patient return visits. This project turns historical encounter, procedure and payer records (Jan 2011 to Feb 2022, one hospital) into a six-page dashboard that supports evidence-based operational decisions.

## Tools
Power BI, Power Query, DAX, Excel (formulas and pivot tables), SQL.

## Dashboard pages
1. Overview: key operational indicators
2. Encounter Volume Trend: by year, quarter and month
3. Encounter Classes: volume, cost share and average cost by class
4. Cost & Payer Coverage: claim cost vs payer coverage, zero-coverage encounters
5. Procedures Utilisation: frequency vs average base cost
6. Data Notes & KPI Definitions

## Headline figures (no filters)
| KPI | Value |
|---|---|
| Total Encounters | 27,891 |
| Total Claim Cost | $101.5M |
| Avg Claim Cost per Encounter | $3,640 |
| Payer Coverage % | 30.6% |
| Zero Coverage % | 48.7% (13,586 encounters) |
| Encounters over 24 hours | 75 |
| Procedure Count | 47,701 |
| Avg Procedure Base Cost | $2,212 |

Full KPI definitions and DAX are in `KPI_Definitions.xlsx`.

## Selected findings
- Urgent care is 13.1% of encounters but 23.0% of claim cost.
- Inpatient has the highest average claim cost ($7,761) and 58 of the 75 encounters over 24 hours.
- Nearly half of encounters (48.7%) record zero payer coverage; the data does not say whether this means uninsured, unrecorded or unpaid.
- February 2014 is an unusually high month (1,179 encounters); the data does not explain why.

## Validation
Key figures were checked independently against the source CSVs, Excel and SQL, and the dashboard was tested under filters. All checks matched. Details: `Validation_Evidence` and the Validation Values sheet in `KPI_Definitions.xlsx`; SQL in `validation_queries.sql`.

## Limitations
- One hospital only; 2022 is a partial year (data ends 5 Feb 2022).
- Currency is not stated in the data.
- Procedure base cost is not claim cost and the two are not added.
- 47.4% of encounters have no procedure record.
- No clinical outcomes, so no clinical claims are made.

## Repository structure
```
├── Hospital Operations, Cost & Patient Flow.pbix
├── KPI_Definitions.xlsx
├── validation_queries.sql
├── Data_Quality_Assessment.pdf
├── Validation_Evidence.pdf
├── Executive_Summary.pdf
├── Dashboard_Screenshots/
└── Dataset/            (see data privacy note)
```

## Data privacy note
The supplied `patients.csv` contains names, addresses and other identifiers. These columns were removed in Power Query before loading, and **the raw patient file is not included in this repository**. No patient names, addresses or identifiers appear in any screenshot or document.

## How to reproduce
1. Obtain the AnalystLab Africa healthcare dataset pack.
2. Open the `.pbix` file in Power BI Desktop and point the data source to your local copy of the CSV files.
3. Recalculate the KPIs using the definitions in `KPI_Definitions.xlsx`.
4. Run `validation_queries.sql` in an isolated practice database (never against a production database) and compare with the Validation Values sheet.

## Acknowledgements
Dataset and assignment: AnalystLab Africa. AI assistance (Claude) was used for planning, profiling and documentation; all results were reviewed by the author.
