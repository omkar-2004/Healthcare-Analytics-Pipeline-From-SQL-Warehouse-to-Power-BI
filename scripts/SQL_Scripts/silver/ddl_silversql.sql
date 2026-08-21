/*
=============================================================
DDL Script procedure: Create silver Table Structure
=============================================================
procedure Purpose:
	This procedure creates tables in the 'silver' schema.
	Dropping existing tables if they already exists.
	Run this procedure to redefine the DDL structure of the 'silver' tables.
	
WARNING:
    Running this procedure will drop the entire table if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this procedure.

Usage example:
	EXEC silver.create_tables
*/

CREATE or Alter PROCEDURE silver.create_tables AS
BEGIN
	BEGIN TRY
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
		set @Batch_Start_Time = GETDATE();

		SET @Start_Time = GETDATE();
		IF OBJECT_ID('silver.encounters_info','U') IS NOT NULL
			DROP TABLE silver.encounters_info;
		CREATE TABLE silver.encounters_info(
			encounter_id VARCHAR(255) PRIMARY KEY,
			start DATETIME,
			stop DATETIME,
			patient_id VARCHAR(255),
			organization_id VARCHAR(255),
			payer_id VARCHAR(255),
			encounter_class VARCHAR(255),
			encounter_code VARCHAR(255),
			encounter_description VARCHAR(255),
			base_encounter_cost FLOAT,
			Total_claim_cost FLOAT,
			payer_coverage FLOAT,
			reason_code VARCHAR(255),
			reason_description VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'silver.encounters_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('silver.organizations_info','U') IS NOT NULL
			DROP TABLE silver.organizations_info;
		CREATE TABLE silver.organizations_info(
			organization_id VARCHAR(255),
			organization_name VARCHAR(255),
			organization_address VARCHAR(255),
			organization_city VARCHAR(255),
			organization_state VARCHAR(255),
			organization_zip VARCHAR(255),
			organization_lat FLOAT,
			organization_lon FLOAT
		);
		SET @End_Time = GETDATE();
		print 'silver.organizations_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('silver.patients_info','U') IS NOT NULL
			DROP TABLE silver.patients_info;
		CREATE TABLE silver.patients_info(
			patients_id VARCHAR(255),
			birthdate DATE,
			deathdate DATE,
			first_name VARCHAR(255),
			last_name VARCHAR(255),
			marital_status VARCHAR(255),
			race VARCHAR(255),
			ethnicity VARCHAR(255),
			gender VARCHAR(255),
			birthplace VARCHAR(255),
			birth_country VARCHAR(255),
			patient_address VARCHAR(255),
			patient_city VARCHAR(255),
			patient_state VARCHAR(255),
			patient_country VARCHAR(255),
			patient_zip VARCHAR(255),
			patient_lat VARCHAR(255),
			patient_lon VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'silver.patients_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('silver.payers_info','U') IS NOT NULL
			DROP TABLE silver.payers_info;
		CREATE TABLE silver.payers_info(
			payer_id VARCHAR(255),
			payer_name VARCHAR(255),
			payer_address VARCHAR(255),
			payer_city VARCHAR(255),
			payer_state_headquartered VARCHAR(255),
			payer_zip VARCHAR(255),
			phone VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'silver.payers_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('silver.procedures_info','U') IS NOT NULL
			DROP TABLE silver.procedures_info;
		CREATE TABLE silver.procedures_info(
			start DATE,
			stop DATE,
			patient_id VARCHAR(255),
			encounter_id VARCHAR(255),
			procedure_code VARCHAR(255),
			procedure_description VARCHAR(255),
			procedure_base_cost BIGINT,
			reason_code VARCHAR(255),
			reason_description VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'silver.procedures_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Batch_End_Time = GETDATE();
		print '============================================================';
		print 'Creating all table structure is completed.';
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
