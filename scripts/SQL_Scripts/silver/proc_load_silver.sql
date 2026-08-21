/*
=============================================================
Stored Procedure: Load Silver Layer(Bronze -> Silver)
=============================================================

Script Purpose:
	This stores procedure performs the ETL(Extract, Transform, Load)
	process to populated the 'silver' schema tables from the 'bronze'
	schema.

Actions Performed:
	- Truncate the silver tables.
	- Insert transformed and cleaned data from Bronze to silver tables

Usage Example:
	EXEC silver.load_silver;
*/

CREATE or Alter PROCEDURE silver.load_silver AS
BEGIN	
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
	BEGIN TRY
		set @Batch_Start_Time = GETDATE();
		print '=======================================================================';
		print 'Loading Silver Layer';
		print '=======================================================================';

		print '-----------------------------------------------------------------------';
		print 'Loading Encounters information table';
		print '-----------------------------------------------------------------------';
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.encounters_info';
		TRUNCATE TABLE silver.encounters_info

		print '>>>Inserting data into Table: silver.encounters_info';
		INSERT INTO silver.encounters_info(
			encounter_id,
			start,
			stop,
			patient_id,
			organization_id,
			payer_id,
			encounter_class,
			encounter_code,
			encounter_description,
			base_encounter_cost,
			Total_claim_cost,
			payer_coverage,
			reason_code,
			reason_description
		)
		SELECT 
			encounter_id,
			start,
			stop,
			patient_id,
			organization_id,
			payer_id,
			encounter_class,
			encounter_code,
			encounter_description,
			base_encounter_cost,
			Total_claim_cost,
			payer_coverage,
			CASE
			WHEN reason_code IS NULL THEN '0000000'
			ELSE reason_code
			END reason_code,
			CASE
			WHEN reason_description IS NULL THEN 'Not Recorded'
			ELSE reason_description
			END reason_description
		FROM bronze.encounters_info

		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '-----------------------------------------------------------------------';
		print 'Loading Organizations information table';
		print '-----------------------------------------------------------------------';
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.organizations_info';
		TRUNCATE TABLE silver.organizations_info

		print '>>>Inserting data into Table: silver.organizations_info';
		INSERT INTO silver.organizations_info(
			organization_id,
			organization_name,
			organization_address,
			organization_city,
			organization_state,
			organization_zip,
			organization_lat,
			organization_lon
		)
		SELECT 
			organization_id,
			organization_name,
			organization_address,
			organization_city,
			CASE
				WHEN organization_state =  'MA' THEN 'MASSACHUSETTS'
			END organization_state,
			organization_zip,
			organization_lat,
			organization_lon
		FROM bronze.organizations_info
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '-----------------------------------------------------------------------';
		print 'Loading Patients information table';
		print '-----------------------------------------------------------------------';
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.patients_info';
		TRUNCATE TABLE silver.patients_info

		print '>>>Inserting data into Table: silver.patients_info';
		INSERT INTO silver.patients_info(
			patients_id,
			birthdate,
			deathdate,
			first_name,
			last_name,
			marital_status,
			race,
			ethnicity,
			gender,
			birthplace,
			birth_country,
			patient_address,
			patient_city,
			patient_state,
			patient_country,
			patient_zip,
			patient_lat,
			patient_lon
		)
		SELECT 
			patients_id,
			birthdate,
			deathdate,
			first_name,
			last_name,
			CASE 
				WHEN UPPER(marital_status) = 'M' THEN 'Married'
				WHEN UPPER(marital_status) = 'S' THEN 'Single'
			END marital_status,
			race,
			ethnicity,
			CASE 
				WHEN UPPER(gender) = 'F' THEN 'Female'
				WHEN UPPER(gender) = 'M' THEN 'Male'
			END gender,
			birthplace,
			RIGHT(birthplace,2) AS birth_country,
			patient_address,
			patient_city,
			patient_state,
			patient_country,
			case 
			WHEN patient_zip IS NULL THEN 00000
			ELSE patient_zip
			END patient_zip,
			patient_lat,
			patent_lon as patient_lon
		FROM bronze.patients_info
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '-----------------------------------------------------------------------';
		print 'Loading Payers information table';
		print '-----------------------------------------------------------------------';
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.payers_info';
		TRUNCATE TABLE silver.payers_info

		print '>>>Inserting data into Table: silver.payers_info';
		INSERT INTO silver.payers_info(
			payer_id,
			payer_name,
			payer_address,
			payer_city,
			payer_state_headquartered,
			payer_zip,
			phone	
		)
		SELECT 
			payer_id,
			payer_name,
			Payer_address as payer_address,
			payer_city,
			CASE
			WHEN UPPER(payer_state_headquartered) = 'MD' THEN 'Maryland'
			WHEN UPPER(payer_state_headquartered) = 'KY' THEN 'Kentucky'
			WHEN UPPER(payer_state_headquartered) = 'IL' THEN 'Illinois'
			WHEN UPPER(payer_state_headquartered) = 'MN' THEN 'Minnesota'
			WHEN UPPER(payer_state_headquartered) = 'CT' THEN 'Connecticut'
			WHEN UPPER(payer_state_headquartered) = 'IN' THEN 'Indiana'
			ELSE payer_state_headquartered
		END payer_state_headquartered,
		payer_zip,
		phone
		FROM bronze.payers_info
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		print '-----------------------------------------------------------------------';
		print 'Loading Procedures information table';
		print '-----------------------------------------------------------------------';
		SET @Start_Time = GETDATE();
		print '>>>Truncating Table: silver.procedures_info';
		TRUNCATE TABLE silver.procedures_info

		print '>>>Inserting data into Table: silver.procedures_info';
		INSERT INTO silver.procedures_info(
			start,
			stop,
			patient_id,
			encounter_id,
			procedure_code,
			procedure_description,
			procedure_base_cost,
			reason_code,
			reason_description
		)
		SELECT 
			start,
			stop,
			patient_id,
			encounter_id,
			procedure_code,
			procedure_description,
			priocedure_base_cost AS procedure_base_cost,
			CASE
			WHEN reason_code IS NULL THEN '0000000'
			ELSE reason_code
			END reason_code,
			CASE
			WHEN reason_description IS NULL THEN 'Not Recorded'
			ELSE reason_description
			END reason_description
		FROM bronze.procedures_info
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		SET @Batch_End_Time = GETDATE();
		print '============================================================';
		print 'Loading Silver layer is completed.';
		print '>>>Total Load Duration: ' + cast(DATEDIFF(second,@Batch_Start_Time,@Batch_End_Time) as NVARCHAR) + ' Seconds';
		print '============================================================';

	END TRY
	BEGIN CATCH
		print '============================================================';
		print 'Error while loading silver layer.';
		print 'Error Message' + error_message();
		print 'Error Number' + cast(ERROR_NUMBER() AS NVARCHAR);
		print 'Error state' + cast(ERROR_STATE() AS NVARCHAR);
		print '============================================================';

	END CATCH
END