-- =====================================================================
-- Week 3 | Hospital Operations, Cost & Patient Flow | Validation queries
-- Purpose : independent SQL check of the dashboard KPIs (read-only, SELECT only)
-- Syntax  : MySQL. Run in your ISOLATED practice database only.
-- Tables  : encounters, procedures (as loaded by create_hospital_db.sql)
-- NOTE    : adjust table/column names if your setup script names them
--           differently. If START/STOP were loaded as text, wrap them with
--           STR_TO_DATE(REPLACE(REPLACE(START,'T',' '),'Z',''), '%Y-%m-%d %H:%i:%s').
-- Tested  : logic verified on the same CSV data (SQLite); all 8 results matched.
-- =====================================================================

-- KPI-01 Total Encounters                      expected 27,891
SELECT COUNT(*) AS total_encounters FROM encounters;

-- KPI-02 Total Claim Cost                      expected 101,514,375.52
SELECT ROUND(SUM(TOTAL_CLAIM_COST), 2) AS total_claim_cost FROM encounters;

-- Total Payer Coverage                         expected 31,097,506.99
SELECT ROUND(SUM(PAYER_COVERAGE), 2) AS total_payer_coverage FROM encounters;

-- Unique Patients                              expected 974
SELECT COUNT(DISTINCT PATIENT) AS unique_patients FROM encounters;

-- KPI-07 Procedure Count                       expected 47,701
SELECT COUNT(*) AS procedure_count FROM procedures;

-- KPI-08 Avg Procedure Base Cost               expected 2,212.06
SELECT ROUND(AVG(BASE_COST), 2) AS avg_procedure_base_cost FROM procedures;

-- Zero Coverage Encounters                     expected 13,586
SELECT COUNT(*) AS zero_coverage_encounters
FROM encounters WHERE PAYER_COVERAGE = 0;

-- Encounters Over 24h (strictly more than 24h) expected 75
SELECT COUNT(*) AS encounters_over_24h
FROM encounters
WHERE TIMESTAMPDIFF(SECOND, START, STOP) > 86400;

-- Derived KPIs (all from one query)            expected 3,639.68 | 30.6% | 48.7% | 0.27%
SELECT
  ROUND(SUM(TOTAL_CLAIM_COST) / COUNT(*), 2)                         AS avg_claim_cost_per_encounter,
  ROUND(100 * SUM(PAYER_COVERAGE) / SUM(TOTAL_CLAIM_COST), 1)        AS payer_coverage_pct,
  ROUND(100 * SUM(PAYER_COVERAGE = 0) / COUNT(*), 1)                 AS zero_coverage_pct,
  ROUND(100 * SUM(TIMESTAMPDIFF(SECOND, START, STOP) > 86400) / COUNT(*), 2) AS over_24h_pct
FROM encounters;

-- Extra check: encounters lasting EXACTLY 24h (excluded by "more than 24h")  expected 1,077
SELECT COUNT(*) AS exactly_24h
FROM encounters WHERE TIMESTAMPDIFF(SECOND, START, STOP) = 86400;
