# 🏢 Data Warehouse & Analytics Project

[![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://www.microsoft.com/sql-server)
[![Data Warehouse](https://img.shields.io/badge/Data%20Warehouse-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)](https://github.com/Abhijeet314/DataWareHouse)
[![TSQL](https://img.shields.io/badge/T--SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)](https://github.com/Abhijeet314/DataWareHouse)

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀 This project demonstrates a comprehensive end-to-end data warehousing solution, showcasing industry best practices in data engineering, dimensional modeling, and analytics.

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Data Model](#-data-model)
- [Project Structure](#-project-structure)
- [Key Features](#-key-features)
- [Technologies Used](#-technologies-used)
- [Getting Started](#-getting-started)
- [Business Logic](#-business-logic)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 Overview

This project implements a **Medallion Architecture data warehouse** with multiple source systems (CRM and ERP). It demonstrates:

- **Medallion Architecture**: Bronze (raw) → Silver (cleansed) → Gold (business-ready) layers
- **Multi-Source Integration**: Combining data from CRM and ERP systems
- **Dimensional Modeling**: Star schema implementation in the Gold layer
- **Data Quality**: Progressive data refinement through each layer
- **Best Practices**: Industry-standard approaches to modern data warehousing

### Use Cases

- Sales performance analysis across multiple systems
- Customer 360-degree view (CRM + ERP data)
- Product performance tracking with location data
- Cross-system data reconciliation
- Time-series sales trends
- Revenue and profitability insights

## 🏗️ Architecture

The data warehouse follows a **Medallion Architecture** (Bronze → Silver → Gold) with multiple data sources:

```
┌─────────────────────────────────────────────────────────────┐
│                      DATA SOURCES                            │
├──────────────────────┬──────────────────────────────────────┤
│   CRM System         │        ERP System                     │
│   ├── cust_info      │        ├── CUST_AZ12                 │
│   ├── prd_info       │        ├── LOC_A101                  │
│   └── sales_details  │        └── PX_CAT_G1V2               │
└──────────────────────┴──────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    BRONZE LAYER (Raw Data)                   │
│                  Raw ingestion from sources                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                 SILVER LAYER (Cleaned Data)                  │
│         Data cleansing, transformation, validation           │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              GOLD LAYER (Business Ready)                     │
│                                                              │
│    ┌─────────────────┐                                      │
│    │  dim_customers  │──┐                                   │
│    └─────────────────┘  │                                   │
│                         │                                   │
│    ┌─────────────────┐  │    ┌──────────────┐             │
│    │  dim_products   │──┼────│  fact_sales  │             │
│    └─────────────────┘  │    └──────────────┘             │
│                         │                                   │
└─────────────────────────────────────────────────────────────┘
```

## 📊 Data Model

### Entity Relationship Diagram

```
┌─────────────────────────────┐
│    gold.dim_customers       │
├─────────────────────────────┤
│ PK  customer_key            │◄───┐
│     customer_id             │    │
│     customer_number         │    │
│     first_name              │    │
│     last_name               │    │
│     country                 │    │
│     marital_status          │    │
│     gender                  │    │
│     birthdate               │    │
└─────────────────────────────┘    │
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
        │                          │                          │
┌───────▼──────────────────┐       │       ┌──────────────────▼──────┐
│   gold.fact_sales        │       │       │  gold.dim_products      │
├──────────────────────────┤       │       ├─────────────────────────┤
│     order_number         │       │       │ PK  product_key         │
│ FK1 product_key          │───────┼───────┤     product_id          │
│ FK2 customer_key         │───────┘       │     product_number      │
│     order_date           │               │     product_name        │
│     shipping_date        │               │     category_id         │
│     due_date             │               │     category            │
│     sales_amount         │               │     subcategory         │
│     quantity             │               │     maintenance         │
│     price                │               │     cost                │
└──────────────────────────┘               │     product_line        │
                                           │     start_date          │
                                           └─────────────────────────┘

                       Sales Calculation Formula:
                    ═══════════════════════════════
                    Sales Amount = Quantity × Price
```

### Table Descriptions

#### 🔹 Fact Table: `gold.fact_sales`

The central fact table storing all sales transactions with measures and foreign keys to dimensions.

**Columns:**
- `order_number` - Unique identifier for each order
- `product_key` (FK) - Foreign key to dim_products
- `customer_key` (FK) - Foreign key to dim_customers
- `order_date` - Date when order was placed
- `shipping_date` - Date when order was shipped
- `due_date` - Expected delivery date
- `sales_amount` - Total sales value (Quantity × Price)
- `quantity` - Number of units sold
- `price` - Unit price of the product

**Business Metrics:**
- Total Revenue
- Average Order Value
- Sales Quantity
- Price Points

---

#### 🔹 Dimension Table: `gold.dim_customers`

Customer dimension containing demographic and profile information.

**Columns:**
- `customer_key` (PK) - Surrogate key
- `customer_id` - Natural key
- `customer_number` - Business identifier
- `first_name` - Customer's first name
- `last_name` - Customer's last name
- `country` - Customer's country of residence
- `marital_status` - Married or Single
- `gender` - Customer's gender
- `birthdate` - Customer's date of birth

**Analysis Capabilities:**
- Customer segmentation
- Demographic analysis
- Geographic distribution
- Age-based analysis

---

#### 🔹 Dimension Table: `gold.dim_products`

Product dimension containing product details, categories, and attributes.

**Columns:**
- `product_key` (PK) - Surrogate key
- `product_id` - Natural key
- `product_number` - Business identifier
- `product_name` - Name of the product
- `category_id` - Category identifier
- `category` - Product category
- `subcategory` - Product subcategory
- `maintenance` - Maintenance required (Yes/No)
- `cost` - Cost to produce/acquire
- `product_line` - Product line grouping
- `start_date` - Product availability date

**Analysis Capabilities:**
- Product performance analysis
- Category-wise sales
- Profitability analysis (Price vs Cost)
- Product lifecycle tracking

---

### 🔐 Data Model Design Principles

1. **Star Schema**: Optimized for query performance and ease of use
2. **Surrogate Keys**: All dimensions use surrogate keys for better performance and flexibility
3. **Slowly Changing Dimensions**: Ready to implement SCD Type 2 if needed
4. **Grain Definition**: Fact table grain is at the order line item level
5. **Denormalization**: Dimensions are denormalized for query performance

## 📁 Project Structure

```
DataWareHouse/
├── datasets/
│   ├── crm/
│   │   ├── cust_info.csv          # Customer information
│   │   ├── prd_info.csv           # Product information
│   │   └── sales_details.csv      # Sales transaction details
│   └── erp/
│       ├── CUST_AZ12.csv          # ERP customer data
│       ├── LOC_A101.csv           # Location data
│       └── PX_CAT_G1V2.csv        # Product category data
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_create_table.sql   # Bronze layer table creation
│   │   ├── load_sources.sql       # Load data from sources
│   │   └── _init_db.sql           # Database initialization
│   │
│   ├── Silver/
│   │   ├── ddl_create_table.sql   # Silver layer table creation
│   │   └── insert_data_silver.sql # Transform and load to Silver
│   │
│   └── Gold/
│       └── ddl_create_views.sql   # Gold layer views/tables
│
└── README.md                       # This file
```

## ✨ Key Features

### 🎯 Data Warehouse Capabilities

- **Medallion Architecture**: Industry-standard Bronze → Silver → Gold approach
- **Multi-Source Integration**: Seamlessly combines CRM and ERP data
- **Star Schema Design**: Optimized Gold layer for OLAP queries and BI tools
- **Data Quality Layers**: Progressive refinement from raw to business-ready
- **Dimensional Modeling**: Conformed dimensions for enterprise-wide consistency
- **Scalability**: Designed to handle growing data volumes across multiple sources
- **Performance**: Layered architecture for optimal query performance

### 📊 Analytics Ready

- Pre-built analytical queries for common business questions
- Time-series analysis capabilities
- Customer segmentation support
- Product performance metrics
- Revenue and profitability analysis

### 🔧 Technical Highlights

- **Medallion Architecture**: Bronze → Silver → Gold data layers
- **Multi-Source Integration**: CRM and ERP system consolidation
- **T-SQL implementation** with modular layer design
- **Progressive data quality** improvement through layers
- **Star schema** in Gold layer for analytics
- Comprehensive documentation
- Modular script structure organized by layer
- Best practice naming conventions
- Multiple source datasets (CRM + ERP)

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **Microsoft SQL Server** | Data warehouse platform |
| **T-SQL** | Data definition and manipulation |
| **Medallion Architecture** | Data layer organization (Bronze/Silver/Gold) |
| **Star Schema** | Dimensional modeling in Gold layer |
| **CSV Files** | Source data format (CRM & ERP) |

## 🚀 Getting Started

### Prerequisites

- Microsoft SQL Server 2016 or higher
- SQL Server Management Studio (SSMS) or Azure Data Studio
- Basic understanding of SQL and data warehousing concepts

### Installation Steps

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Abhijeet314/DataWareHouse.git
   cd DataWareHouse
   ```

2. **Initialize Database**
   ```sql
   -- Initialize the database
   :r scripts/bronze/_init_db.sql
   ```

3. **Set Up Bronze Layer (Raw Data)**
   ```sql
   -- Create bronze layer tables
   :r scripts/bronze/ddl_create_table.sql
   
   -- Load data from source systems (CRM & ERP)
   :r scripts/bronze/load_sources.sql
   ```

4. **Set Up Silver Layer (Cleaned Data)**
   ```sql
   -- Create silver layer tables
   :r scripts/Silver/ddl_create_table.sql
   
   -- Transform and load data to silver
   :r scripts/Silver/insert_data_silver.sql
   ```

5. **Set Up Gold Layer (Business Ready)**
   ```sql
   -- Create gold layer views/tables (Star Schema)
   :r scripts/Gold/ddl_create_views.sql
   ```

### Quick Start Example

```sql
-- Query the Gold layer for business insights
SELECT 
    p.category,
    c.country,
    SUM(f.sales_amount) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.customer_key) AS unique_customers
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
JOIN gold.dim_customers c ON f.customer_key = c.customer_key
GROUP BY p.category, c.country
ORDER BY total_sales DESC;
```

### Data Flow

1. **Bronze Layer**: Raw data loaded from CRM (`cust_info.csv`, `prd_info.csv`, `sales_details.csv`) and ERP systems (`CUST_AZ12.csv`, `LOC_A101.csv`, `PX_CAT_G1V2.csv`)
2. **Silver Layer**: Data cleansing, standardization, and validation
3. **Gold Layer**: Business-ready dimensional model (Star Schema) for analytics

## 💼 Business Logic

### Key Calculations

**Sales Amount Calculation:**
```sql
sales_amount = quantity × price
```

**Gross Profit Calculation:**
```sql
gross_profit = sales_amount - (quantity × cost)
```

**Profit Margin:**
```sql
profit_margin = (gross_profit / sales_amount) × 100
```

### Common Analysis Patterns

1. **Time-Series Analysis**: Track sales trends over time
2. **Customer Lifetime Value**: Calculate total customer value
3. **Product Mix Analysis**: Understand product portfolio performance
4. **Geographic Analysis**: Sales distribution by country/region
5. **Cohort Analysis**: Customer behavior patterns

## 📈 Sample Analytics Queries

### Top Selling Products
```sql
SELECT TOP 10
    p.product_name,
    SUM(f.quantity) AS total_units_sold,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
JOIN gold.dim_products p ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;
```

### Customer Segmentation by Country
```sql
SELECT 
    c.country,
    c.marital_status,
    COUNT(DISTINCT c.customer_key) AS customer_count,
    AVG(f.sales_amount) AS avg_purchase_value
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f ON c.customer_key = f.customer_key
GROUP BY c.country, c.marital_status
ORDER BY customer_count DESC;
```

### Monthly Sales Trend
```sql
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales_amount) AS monthly_sales,
    COUNT(DISTINCT order_number) AS order_count
FROM gold.fact_sales
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Commit your changes** (`git commit -m 'Add some AmazingFeature'`)
4. **Push to the branch** (`git push origin feature/AmazingFeature`)
5. **Open a Pull Request**

### Areas for Contribution

- Additional data sources integration
- Data quality validation scripts for each layer
- ETL optimization and performance tuning
- Documentation improvements
- Incremental load strategies
- Data lineage tracking
- Integration with BI tools (Power BI, Tableau)
- Automated testing scripts

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Abhijeet**

- GitHub: [@Abhijeet314](https://github.com/Abhijeet314)
- Project Link: [https://github.com/Abhijeet314/DataWareHouse](https://github.com/Abhijeet314/DataWareHouse)

## 🙏 Acknowledgments

- Medallion Architecture best practices from Databricks
- Kimball Group for dimensional modeling methodology
- Microsoft SQL Server documentation
- Data warehousing community for modern architecture patterns

---

## 📊 Data Warehouse Metrics

| Metric | Description |
|--------|-------------|
| **Architecture** | Medallion (Bronze → Silver → Gold) |
| **Data Sources** | 2 (CRM + ERP) |
| **Layers** | 3 (Bronze, Silver, Gold) |
| **Gold Tables** | 3 (1 Fact, 2 Dimensions) |
| **Schema** | Star Schema (Gold Layer) |
| **Grain** | Order Line Item Level |
| **Technology** | Microsoft SQL Server |
| **Language** | T-SQL |

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

**Happy Data Warehousing!** 🚀📊

</div>
