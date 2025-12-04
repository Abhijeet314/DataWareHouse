create table Silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(50),
	cst_firstname NVARCHAR(50),
	cst_lastname NVARCHAR(50),
	cst_marital_status NVARCHAR(50),
	cst_gndr NVARCHAR(50),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

TRUNCATE TABLE Silver.crm_cust_info;
INSERT INTO Silver.crm_cust_info (
cst_id, 
cst_key, 
cst_firstname, 
cst_lastname, 
cst_marital_status, 
cst_gndr,
cst_create_date
)
select 
cst_id,
cst_key,
TRIM(cst_firstname) cst_firsname,
TRIM(cst_lastname) cst_lastname,
CASE UPPER(TRIM(cst_marital_status))
	WHEN 'M' then 'Married'
	WHEN 'S' then 'Single'
	else 'n/a'
end cst_marital_status,
CASE UPPER(TRIM(cst_gndr))
	WHEN 'M' then 'Male'
	WHEN 'F' then 'Female'
	else 'n/a'
end cst_gndr,
cst_create_date
from
(
select
*,
ROW_NUMBER() over(partition by cst_id order by cst_create_date desc) ranking
from Bronze.crm_cust_info
)t
where ranking = 1 AND cst_id is not null

CREATE TABLE Silver.crm_prd_info (
	prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
)

INSERT INTO Silver.crm_prd_info (
prd_id,
cat_id,
prd_key,
prd_nm,
prd_cost,
prd_line,
prd_start_dt,
prd_end_dt
)
select 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id,
SUBSTRING(prd_key, 7, LEN(prd_key)) as prd_key,
prd_nm,        
ISNULL(prd_cost, 0) prd_cost,        
CASE UPPER(TRIM(prd_line))
	WHEN 'R' THEN 'Road'
	WHEN 'M' THEN 'Mountain'
	WHEN 'S' THEN 'Other Sales'
	WHEN 'T' THEN 'Touring'
	ELSE 'n/a'
END prd_line,
CAST(prd_start_dt AS DATE) prd_start_dt,   
CAST(
	LEAD(prd_start_dt) over(partition by prd_key order by prd_start_dt) - 1 AS DATE
) prd_end_dt
from Bronze.crm_prd_info;


select
sls_ord_num,
sls_prd_key,
sls_cust_id,
sls_order_dt,
sls_ship_dt,
sls_due_dt,
sls_sales,
sls_quantity,
sls_price
from Bronze.crm_sales_details

