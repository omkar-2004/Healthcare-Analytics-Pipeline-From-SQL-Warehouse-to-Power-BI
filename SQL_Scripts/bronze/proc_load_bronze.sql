		/*
		=============================================================
		Stored Procedure: Load Bronze Layer(Source -> Bronze)
		=============================================================
		Script Purpose:
			This script load the data into the 'bronze' schema from external CSV files.
			It performs the following actions:
			- Truncates the bronze tables before loading data.
			- Uses the 'BULK INSERT' command to load data from csv to bronze tables.
			- Calculates to total and individual duration to load data.
	
		Usage example:
			EXEC bronze.load_bronze

		Note:
			Change the file locations to csv locations.
		*/
CREATE or Alter PROCEDURE bronze.load_bronze AS
BEGIN
	declare @Start_Time DATETIME, @End_Time DATETIME, @Batch_Start_Time DATETIME, @Batch_End_Time DATETIME;
	BEGIN TRY
		set @Batch_Start_Time = GETDATE();
		print '=======================================================================';
		print 'Loading Bronze Layer';
		print '=======================================================================';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table:beronze.encounters_info';
		TRUNCATE TABLE bronze.encounters_info;

		print '>>>Inserting data into Table: bronze.encounters_info';
		BULK INSERT bronze.encounters_info
		FROM 'D:\Project\Healthcare Analytics Pipeline From SQL Warehouse to Power BI\Healthcare-Analytics-Pipeline-From-SQL-Warehouse-to-Power-BI\Dataset\CSV\encounters.csv'
		with(
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table:beronze.organizations_info';
		TRUNCATE TABLE bronze.organizations_info;

		print '>>>Inserting data into Table: bronze.organizations_info';
		BULK INSERT bronze.organizations_info
		FROM 'D:\Project\Healthcare Analytics Pipeline From SQL Warehouse to Power BI\Healthcare-Analytics-Pipeline-From-SQL-Warehouse-to-Power-BI\Dataset\CSV\organizations.csv'
		with (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table:beronze.parients_info';
		TRUNCATE TABLE bronze.patients_info;
		print '>>>Inserting data into Table: broze.patients_info';
		BULK INSERT bronze.patients_info
		FROM 'D:\Project\Healthcare Analytics Pipeline From SQL Warehouse to Power BI\Healthcare-Analytics-Pipeline-From-SQL-Warehouse-to-Power-BI\Dataset\CSV\patients.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();
		print '>>>Truncating Table:beronze.payers_info';
		TRUNCATE TABLE bronze.payers_info;
		print '>>>Insesrting data into Table: bronze.payers_info';
		BULK INSERT bronze.payers_info
		FROM 'D:\Project\Healthcare Analytics Pipeline From SQL Warehouse to Power BI\Healthcare-Analytics-Pipeline-From-SQL-Warehouse-to-Power-BI\Dataset\CSV\payers.csv'
		WITH (
			FIRSTROW= 2,
			FIELDTERMINATOR =',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';

		SET @Start_Time = GETDATE();

		print '>>>Truncating Table:beronze.procedures_info';
		TRUNCATE TABLE bronze.procedures_info;
		print '>>>Inserting data into Table: bronze.procedures_info';
		BULK INSERT bronze.procedures_info
		FROM 'D:\Project\Healthcare Analytics Pipeline From SQL Warehouse to Power BI\Healthcare-Analytics-Pipeline-From-SQL-Warehouse-to-Power-BI\Dataset\CSV\procedures.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @End_Time = GETDATE();
		print '>>>Load Duration: ' + cast(DATEDIFF(second,@Start_Time,@End_Time) as NVARCHAR) + ' Seconds';
		Print '+++++++++++++++++++++++++++++++++++++++';
		
		SET @Batch_End_Time = GETDATE();
		print '============================================================';
		print 'Loading Bronze layer is completed.';
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