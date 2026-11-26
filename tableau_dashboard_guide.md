# Tableau Dashboard Build Guide
## Data source
Connect Tableau to `retail_sales_cleaned.csv` (or import the same CSV into MySQL and connect Tableau to the MySQL table `retail_sales`).

## Recommended dashboard: Retail Performance Overview
Create these worksheets:
1. KPI cards: SUM(Sales), SUM(Profit), SUM(Units Sold), Profit Margin = SUM([Profit])/SUM([Sales]).
2. Category profitability: Category on Rows; SUM(Profit) and Profit Margin on Columns/Label.
3. Regional performance: Region with SUM(Sales) and SUM(Profit).
4. Seasonal trend: Season on Columns; SUM(Sales) and SUM(Profit) on Rows; Category as Color.
5. Inventory watchlist: Product, Category, AVG(Inventory Days), SUM(Units Sold), SUM(Profit). Sort by AVG(Inventory Days) descending.
6. Monthly trend: MONTH(Order Date) on Columns; SUM(Sales) and SUM(Profit) on Rows.

## Filters (apply to all relevant worksheets)
- Region
- Category (product type)
- Season
- Order Date (optional date range)

## Suggested calculated fields
- Profit Margin: `SUM([Profit]) / SUM([Sales])`
- Inventory Status: `IF AVG([Inventory Days]) >= 60 THEN "Slow moving" ELSE "Normal" END`
- Discount Band: `IF [Discount Rate] = 0 THEN "No discount" ELSEIF [Discount Rate] <= 0.10 THEN "Up to 10%" ELSE "Above 10%" END`

## Layout and formatting
Put KPI cards across the top; category and regional charts in the middle; seasonal/monthly trends and inventory watchlist at the bottom. Format Sales and Profit as currency, Profit Margin as percentage, and show filter controls on the right. Use consistent number formats and descriptive chart titles.

## Interpretation note
Inventory days are used as a holding-period proxy in this demo dataset. The dataset does not contain opening/closing stock balances, so it cannot calculate a formal inventory turnover ratio (COGS / average inventory). Replace synthetic data with verified business data before making operational decisions.
