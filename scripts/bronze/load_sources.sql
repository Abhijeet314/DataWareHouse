/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/

-- Loading data in Tables through CSV FILES
-- creating a stored procedure for frequentaly used sql scripts

CREATE OR ALTER PROCEDURE Bronze.load_bronze AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME;
	DECLARE @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @batch_start_time = GETDATE();
		PRINT '==============================='
		PRINT '-----LOADING BRONZE LAYER-----'
		PRINT '==============================='


		PRINT '-----LOADING SOURCE CRM-----'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.crm_cust_info'
		TRUNCATE TABLE Bronze.crm_cust_info;
		PRINT '>> INSERTING INTO TABLE Bronze.crm_cust_info'
		BULK INSERT Bronze.crm_cust_info
		FROM 'C:\CSVDATA\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();

		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.crm_prd_info'
		TRUNCATE TABLE Bronze.crm_prd_info;
		PRINT '>> INSERTING INTO TABLE Bronze.crm_prd_info'
		BULK INSERT Bronze.crm_prd_info
		FROM 'C:\CSVDATA\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.sales_details'
		TRUNCATE TABLE Bronze.crm_sales_details;
		PRINT '>> INSERTING INTO TABLE Bronze.crm_sales_details'
		BULK INSERT Bronze.crm_sales_details
		FROM 'C:\CSVDATA\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'

		PRINT '-----LOADING SOURCE ERP-----'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.erp_cust_az12'
		TRUNCATE TABLE Bronze.erp_cust_az12;
		PRINT '>> INSERTING INTO TABLE Bronze.erp_cust_az12'
		BULK INSERT Bronze.erp_cust_az12
		FROM 'C:\CSVDATA\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'
		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.erp_loc_a101'
		TRUNCATE TABLE Bronze.erp_loc_a101;
		PRINT '>> INSERTING INTO TABLE Bronze.erp_loc_a101'
		BULK INSERT Bronze.erp_loc_a101
		FROM 'C:\CSVDATA\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'

		SET @start_time = GETDATE();
		PRINT '>> TRUNCATING TABLE Bronze.erp_px_cat_g1v2'
		TRUNCATE TABLE Bronze.erp_px_cat_g1v2;
		PRINT '>> INSERTING INTO TABLE Bronze.erp_px_cat_g1v2'
		BULK INSERT Bronze.erp_px_cat_g1v2
		FROM 'C:\CSVDATA\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) as NVARCHAR) + ' seconds';
		PRINT '------------------'

		SET @batch_end_time = GETDATE();

		PRINT '==========================================='
		PRINT '>> LOAD BRONZE LAYER FULL DURATION: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) as NVARCHAR) + ' seconds';
		PRINT '==========================================='
	END TRY
	BEGIN CATCH
		PRINT '------ERROR LOADING BRONZE LAYER-----'
		PRINT 'ERROR MESSAGE : ' + ERROR_MESSAGE()
		PRINT 'ERROR NUMBER :' + CAST(ERROR_NUMBER() AS VARCHAR)
		PRINT 'ERROR STATE : ' + ERROR_STATE()
	END CATCH
END
