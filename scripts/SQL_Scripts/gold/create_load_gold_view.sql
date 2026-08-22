/*
=============================================================
DDL Script: CREATE Gold Views
=============================================================
Script Purpose:
	This script creates views in the 'gold' schema.
	Dropping existing views if they already exists.
	The gold schema represnts th final dimention and fact tables.

	Each view performs transformations and combines data from the silver
	layer to proucr a clean, enriched and business-readt dataset.

Usage:
	- There views can be queried directly for analytics and reporting.
*/

-- =============================================================
-- Create Dimention: gold.dim_organizations
-- =============================================================
GO

IF OBJECT_ID('gold.dim_organizations','V') IS NOT NULL
	DROP VIEW gold.dim_organizations

GO

CREATE VIEW gold.dim_organizations AS(
SELECT 
	ROW_NUMBER() OVER(ORDER BY organization_id) AS organization_key,
	organization_id,
	organization_name,
	organization_address,
	organization_city,
	organization_state,
	organization_zip,
	organization_lat,
	organization_lon
FROM silver.organizations_info)

GO

-- =============================================================
-- Create Dimention: gold.dim_payers
-- =============================================================

IF OBJECT_ID('gold.dim_payers','V') IS NOT NULL
	DROP VIEW gold.dim_payers

GO

CREATE VIEW gold.dim_payers AS(
SELECT 
	ROW_NUMBER() OVER(ORDER BY p.payer_id) AS payer_key,
	p.payer_id,
	p.payer_name,
	p.payer_address,
	p.payer_city,
	p.payer_state_headquartered,
	p.payer_zip,
	p.phone
FROM silver.payers_info as p)

GO

-- =============================================================
-- Create Dimention: gold.dim_patients
-- =============================================================

IF OBJECT_ID('gold.dim_patients','V') IS NOT NULL
	DROP VIEW gold.dim_patients

GO

CREATE VIEW gold.dim_patients AS(
SELECT 
	ROW_NUMBER() OVER(ORDER BY pa.patients_id) AS patient_key,
	pa.patients_id,
	pa.birthdate,
	pa.deathdate,
	pa.first_name,
	pa.last_name,
	pa.marital_status,
	pa.race,
	pa.ethnicity,
	pa.gender,
	pa.birthplace,
	pa.birth_country,
	pa.patient_address,
	pa.patient_city,
	pa.patient_state,
	pa.patient_country,
	pa.patient_zip,
	pa.patient_lat,
	pa.patient_lon
FROM silver.patients_info as pa)

GO

-- =============================================================
-- Create Fact: gold.fact_encounters
-- =============================================================

IF OBJECT_ID('gold.fact_encounters','V') IS NOT NULL
	DROP VIEW gold.fact_encounters

GO

CREATE VIEW gold.fact_encounters AS 
SELECT 
	ROW_NUMBER() OVER(ORDER BY e.encounter_id) AS encounter_key,
	e.encounter_id,
	pa.patient_key,
	e.patient_id,
	o.organization_key,
	p.payer_key,
	e.payer_id,
	e.encounter_class,
	e.encounter_code,
	e.encounter_description,
	e.base_encounter_cost,
	e.Total_claim_cost AS total_claim_cost,
	e.payer_coverage,
	e.reason_code,
	e.reason_description,
	e.start AS encounter_start,
	e.stop AS encounter_stop
FROM silver.encounters_info AS e
LEFT JOIN gold.dim_organizations AS o
ON e.organization_id = o.organization_id
LEFT JOIN gold.dim_payers AS p
ON e.payer_id = p.payer_id
LEFT JOIN gold.dim_patients AS pa
ON e.patient_id = pa.patients_id

GO

-- =============================================================
-- Create Dimention: gold.dim_procedure
-- =============================================================

IF OBJECT_ID('gold.dim_procedure','V') IS NOT NULL
	DROP VIEW gold.dim_procedure

GO

CREATE VIEW gold.dim_procedure AS
(SELECT 
	p.patient_key,
	po.patient_id,
	e.encounter_key,
	po.encounter_id,
	po.procedure_code,
	po.procedure_description,
	po.procedure_base_cost,
	po.reason_code,
	po.reason_description,
	po.start AS procedure_start,
	po.stop AS procedure_stop
FROM silver.procedures_info AS po
LEFT JOIN gold.dim_patients AS p
ON po.patient_id = p.patients_id
LEFT JOIN gold.fact_encounters AS e
ON po.encounter_id = e.encounter_id)

GO