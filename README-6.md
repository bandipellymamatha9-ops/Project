# Retail Business Performance & Profitability Analysis

## Project objective
Analyse retail transactions to compare category, product, regional and seasonal profitability; inspect the relationship between inventory holding days and profit; and identify products for inventory review.

## Files
- `retail_sales_raw.csv` — 600-row synthetic sample with a few intentional missing values for cleaning practice.
- `retail_sales_cleaned.csv` — cleaned dataset ready for SQL/Tableau.
- `retail_analysis_queries.sql` — MySQL table definition and analysis queries.
- `retail_analysis.py` — reproducible Pandas cleaning and analysis script.
- `tableau_dashboard_guide.md` — worksheet, KPI, filter and layout instructions for building the dashboard in Tableau.
- `category_summary.csv`, `seasonal_summary.csv`, `product_inventory_summary.csv` — analysis outputs.
- `Retail_Project_Report.pdf` — two-page project report.

## Run
Install Python packages: `pip install pandas`
Place all files in one folder and run: `python retail_analysis.py`

## SQL
Create a MySQL database, run the CREATE TABLE statement in the SQL file, then import `retail_sales_cleaned.csv` into `retail_sales` using MySQL Workbench/Table Data Import Wizard or another CSV import method. Execute the analysis queries.

## Tableau
Connect Tableau to `retail_sales_cleaned.csv` or the MySQL table. Follow `tableau_dashboard_guide.md` to build the dashboard and apply Region, Category and Season filters.

## Important data note
This is a synthetic demonstration dataset generated for this portfolio project; it is not actual company sales data. Results demonstrate the workflow and should not be represented as findings from a real retailer. Inventory days are a proxy, not a formal inventory turnover calculation.
