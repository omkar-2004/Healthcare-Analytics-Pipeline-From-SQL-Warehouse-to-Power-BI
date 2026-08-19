/*
=============================================================
DDL Script procedure: Create Bronze Table Structure
=============================================================
procedure Purpose:
	This procedure creates tables in the 'bronze' schema.
	Dropping existing tables if they already exists.
	Run this procedure to redefine the DDL structure of the 'bronze' tables.
	
WARNING:
    Running this procedure will drop the entire table if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this procedure.

Usage example:
	EXEC bronze.create_tables
*/

CREATE or Alter PROCEDURE bronze.create_tables AS
BEGIN
	BEGIN TRY
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
		set @Batch_Start_Time = GETDATE();

		SET @Start_Time = GETDATE();
		IF OBJECT_ID('bronze.encounters_info','U') IS NOT NULL
			DROP TABLE bronze.encounters_info;
		CREATE TABLE bronze.encounters_info(
			encounter_id VARCHAR(255) PRIMARY KEY,
			start DATETIME,
			stop DATETIME,
			patient_id VARCHAR(255),
			organization_id VARCHAR(255),
			payer_id VARCHAR(255),
			encounter_class VARCHAR(255),
			encounter_code BIGINT,
			encounter_description VARCHAR(255),
			base_encounter_cost FLOAT,
			Total_claim_cost FLOAT,
			payer_coverage FLOAT,
			reason_code BIGINT,
			reason_description VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'bronze.encounters_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('bronze.organizations_info','U') IS NOT NULL
			DROP TABLE bronze.organizations_info;
		CREATE TABLE bronze.organizations_info(
			organization_id VARCHAR(255),
			organization_name VARCHAR(255),
			organization_address VARCHAR(255),
			organization_city VARCHAR(255),
			organization_state VARCHAR(255),
			organization_zip BIGINT,
			organization_lat FLOAT,
			organization_lon FLOAT
		);
		SET @End_Time = GETDATE();
		print 'bronze.organizations_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('bronze.patients_info','U') IS NOT NULL
			DROP TABLE bronze.patients_info;
		CREATE TABLE bronze.patients_info(
			patients_id VARCHAR(255),
			birthdate DATE,
			deathdate DATE,
			prefix VARCHAR(255),
			first_name VARCHAR(255),
			last_name VARCHAR(255),
			suffix VARCHAR(255),
			maiden VARCHAR(255),
			marital_status VARCHAR(255),
			race VARCHAR(255),
			ethnicity VARCHAR(255),
			gender VARCHAR(255),
			birthplace VARCHAR(255),
			patient_address VARCHAR(255),
			patient_city VARCHAR(255),
			patient_state VARCHAR(255),
			patient_country VARCHAR(255),
			patient_zip BIGINT,
			patient_lat VARCHAR(255),
			patent_lon VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'bronze.patients_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('bronze.payers_info','U') IS NOT NULL
			DROP TABLE bronze.payers_info;
		CREATE TABLE bronze.payers_info(
			payer_id VARCHAR(255),
			payer_name VARCHAR(255),
			Payer_address VARCHAR(255),
			payer_city VARCHAR(255),
			payer_state_headquartered VARCHAR(255),
			payer_zip BIGINT,
			phone VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'bronze.payers_info is created.';
		print '>>>Create Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Start_Time = GETDATE();
		IF OBJECT_ID('bronze.procedures_info','U') IS NOT NULL
			DROP TABLE bronze.procedures_info;
		CREATE TABLE bronze.procedures_info(
			start DATE,
			stop DATE,
			patient_id VARCHAR(255),
			encounter_id VARCHAR(255),
			procedure_code BIGINT,
			procedure_description VARCHAR(255),
			priocedure_base_cost BIGINT,
			reason_code BIGINT,
			reason_description VARCHAR(255)
		);
		SET @End_Time = GETDATE();
		print 'bronze.procedures_info is created.';
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
		print 'Error while loading bronze layer.';
		print 'Error Message' + error_message();
		print 'Error Number' + cast(ERROR_NUMBER() AS NVARCHAR);
		print 'Error state' + cast(ERROR_STATE() AS NVARCHAR);
		print '============================================================';

	END CATCH
END
