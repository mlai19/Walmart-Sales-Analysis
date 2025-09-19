# Walmart-Sales-Analysis

## Project Overview  
**Project Title**: Walmart Sales Analysis  
**Database**: walmart_db [Kaggle]  

<img width="1920" height="1280" alt="image" src="https://github.com/user-attachments/assets/9ef6b865-89c7-4247-8b0a-fdf1bbf7c150" />

<br>
<br>

This project ingests Walmart sales data, cleans and joins it with pandas, and runs targeted SQL queries via SQLAlchemy to answer business questions. It’s a practical walkthrough of data wrangling, EDA, and query design in one repo.

---

# Project Steps

**1. Set Up the Environment**
- **Tools Used:** Visual Studio Code (VS Code), Python, SQL (PostgreSQL)
- **Goal:** Configure a clean VS Code setup with organized folders to support smooth coding and data ops


**2. Set Up Kaggle API**
- **API Setup:** Create a Kaggle token (kaggle.json)  
- **Configure Kaggle:** I store it in ```~/kaggle``` and set ```KAGGLE_CONFIG_DIR``` so the CLI finds it  
Command: ```kaggle datasets download -d <owner/slug> -p ./data```

**3. Download Kaggle datasets**  
- **Data Source:** Use the Kaggle API to download the Walmart sales datasets from Kaggle  
- **Dataset Link:** [Walmart Sales Dataset](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets)
- **Storage:** Save the data in the data/ folder for easy reference and access

**4. Install  Libraries and Load Data**
- **Libraries:** Install necessary Python libraries using:
```pip install pandas numpy sqlalchemy psycopg2```
- **Loading Data:** Use pandas to read the file into a DataFrame, then analyze and transform it

**5. Exploring the Data**
- **Goal:** First-pass exploration to check column names, types, ranges, and anomalies
- **Analysis:** Use df.info(), df.describe(), and df.head() for a quick view of schema and stats


**6. Data Cleaning**
- **Deduplicate:** Remove duplicate rows to prevent double counting
- **Missing data:** Drop negligible rows/columns; fill essential gaps where needed
- **Types:** Normalize dtypes (dates → datetime, prices/qty → numeric)
- **Currency:** Strip symbols/commas (.str.replace) and cast to numeric
- **Validate:** Recheck schema/stats and scan for any remaining inconsistencies

**7. Feature Engineering**
- **Derive totals:** Compute a ```total``` column (```unit_price * quantity```) per transaction
- **Purpose:** Standardizes a key measure for cleaner joins and aggregations later

**8. Load Data into PostgreSQL**
- **Connect to PostgreSQL:** Use SQLAlchemy (postgresql+psycopg2) and load the cleaned DataFrame
- **Create tables:** Write data with df.to_sql(...) and add indexes as needed
- **Verify:** Run row counts and spot checks to confirm accurate loads

**9. SQL Analysis:Queries and Business Problem Solving**
- **Business Questions Addressed:**
  - Revenue trends across branches and categories
  - Top-selling product categories
  - Sales performance by time, city, and payment method
  - Peak sales periods and customer behavior patterns
  - Profit margin analysis by branch and category
- **Notes:** Keep a simple log (e.g., reports/queries.md) with each query’s goal, method, final SQL, and results

# Project Steps

**Future Work:**
- Integrate a Tableau dashboard for interactive visualization
- Incorporate supplementary datasets to deepen analysis
- Automate the end-to-end pipeline for scheduled/real-time refreshes


# Acknowledgments

- **Data source:** Kaggle — Walmart Sales dataset (downloaded via Kaggle API)
- **Inspiration:** Industry case studies from Walmart on optimizing sales and logistics































