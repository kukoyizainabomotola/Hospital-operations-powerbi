# DAX measures and calculated items

Measures live in a table named `_Measures`. Table and field names match the supplied files.

## Date table

```dax
DateTable =
ADDCOLUMNS (
    CALENDAR ( DATE ( 2011, 1, 1 ), DATE ( 2022, 12, 31 ) ),
    "Year", YEAR ( [Date] ),
    "Month Number", MONTH ( [Date] ),
    "Month", FORMAT ( [Date], "MMM" ),
    "Quarter", "Q" & QUARTER ( [Date] ),
    "Year-Month", FORMAT ( [Date], "YYYY-MM" )
)
```

Marked as the date table on `Date`. `Month` is sorted by `Month Number`.

## Core measures

```dax
Total Encounters = COUNTROWS ( encounters )
Total Claim Cost = SUM ( encounters[TOTAL_CLAIM_COST] )
Total Payer Coverage = SUM ( encounters[PAYER_COVERAGE] )
Avg Claim Cost per Encounter = DIVIDE ( [Total Claim Cost], [Total Encounters] )
Payer Coverage % = DIVIDE ( [Total Payer Coverage], [Total Claim Cost] )
Cost Not Covered by Payer = [Total Claim Cost] - [Total Payer Coverage]
Unique Patients = DISTINCTCOUNT ( encounters[PATIENT] )
```

## Zero coverage and long encounters

```dax
Zero Coverage Encounters =
CALCULATE ( COUNTROWS ( encounters ), encounters[PAYER_COVERAGE] = 0 )

Zero Coverage % = DIVIDE ( [Zero Coverage Encounters], [Total Encounters] )

Encounters Over 24h =
CALCULATE ( COUNTROWS ( encounters ), encounters[DurationHours] > 24 ) + 0

Over 24h % = DIVIDE ( [Encounters Over 24h], [Total Encounters] )
```

## Class share

```dax
Encounter Share % =
DIVIDE ( [Total Encounters],
    CALCULATE ( [Total Encounters], ALLSELECTED ( encounters[ENCOUNTERCLASS] ) ) )

Claim Cost Share % =
DIVIDE ( [Total Claim Cost],
    CALCULATE ( [Total Claim Cost], ALLSELECTED ( encounters[ENCOUNTERCLASS] ) ) )
```

## Year-on-year

```dax
Encounters PY = CALCULATE ( [Total Encounters], SAMEPERIODLASTYEAR ( DateTable[Date] ) )

YoY Change % =
VAR PY = [Encounters PY]
RETURN
IF ( HASONEVALUE ( DateTable[Year] ) && SELECTEDVALUE ( DateTable[Year] ) <> 2022,
     DIVIDE ( [Total Encounters] - PY, PY ) )
```

## Procedures

```dax
Procedure Count = COUNTROWS ( procedures )
Avg Procedure Base Cost = AVERAGE ( procedures[BASE_COST] )
Total Procedure Base Cost = SUM ( procedures[BASE_COST] )
Encounters with Procedure = DISTINCTCOUNT ( procedures[ENCOUNTER] )

Encounters without Procedure % =
DIVIDE ( [Total Encounters] - [Encounters with Procedure], [Total Encounters] )
```

## Power Query additions (encounters)

- `StartDate = Date.From ( [START] )`
- `DurationHours = Duration.TotalHours ( [STOP] - [START] )`

## Relationships

| From (many) | To (one) |
|---|---|
| encounters[PATIENT] | patients[Id] |
| encounters[PAYER] | payers[Id] |
| encounters[ORGANIZATION] | organizations[Id] |
| encounters[StartDate] | DateTable[Date] |
| procedures[ENCOUNTER] | encounters[Id] |

All are many-to-one with single-direction filtering. Procedures are placed in time through their encounter.
