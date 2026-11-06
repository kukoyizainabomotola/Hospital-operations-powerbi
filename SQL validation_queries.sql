-- ============================================================
-- Week 3: Hospital Operations, Cost & Patient Flow Intelligence
-- SQL validation queries (AnalystLab Africa, Track A)
-- Prepared by Kukoyi Zainab Omotola
--
-- Purpose: independently check key Power BI figures against the
-- source data loaded into a practice MySQL database (hospital_db).
-- Run these in MySQL Workbench one at a time.
-- Note: the setup script that creates hospital_db is NOT included
-- in this repository because it contains patient-level data.
-- ============================================================

USE hospital_db;

-- 1. Total encounters (expected: 27891)
SELECT COUNT(*) AS total_encounters FROM encounters;

-- 2. Total claim cost and total payer coverage
--    (expected: 101514375.52 and 31097506.99)
SELECT ROUND(SUM(TOTAL_CLAIM_COST), 2) AS total_claim_cost,
       ROUND(SUM(PAYER_COVERAGE), 2)   AS total_payer_coverage
FROM encounters;

-- 3. Encounters with zero recorded payer coverage (expected: 13586)
SELECT COUNT(*) AS zero_coverage
FROM encounters WHERE PAYER_COVERAGE = 0;

-- 4. Procedure count (expected: 47701)
SELECT COUNT(*) AS procedure_count FROM procedures;

-- 5. Filter test: encounters starting in 2014 (expected: 3885)
SELECT COUNT(*) AS enc_2014
FROM encounters WHERE YEAR(START) = 2014;

-- 6. Filter test: inpatient encounters (expected: 1135)
SELECT COUNT(*) AS inpatient
FROM encounters WHERE ENCOUNTERCLASS = 'inpatient';

-- 7. Encounters lasting more than 24 hours (expected: 75)
--    Uses seconds so that exactly 24 hours is not counted.
SELECT COUNT(*) AS over_24h
FROM encounters WHERE TIMESTAMPDIFF(SECOND, START, STOP) > 86400;
