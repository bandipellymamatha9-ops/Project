"""
Retail Business Performance & Profitability Analysis
Run: python retail_analysis.py
Input: retail_sales_raw.csv (same folder)
Outputs: retail_sales_cleaned.csv, category_summary.csv,
         seasonal_summary.csv, product_inventory_summary.csv
Dataset is synthetic demo data; replace with real transactional data for business decisions.
"""
from pathlib import Path
import pandas as pd

BASE = Path(__file__).resolve().parent
raw = pd.read_csv(BASE / "retail_sales_raw.csv")

# Clean missing values, dates, numeric columns and duplicate order IDs
raw["order_date"] = pd.to_datetime(raw["order_date"], errors="coerce")
raw["region"] = raw["region"].fillna("Unknown")
raw["inventory_days"] = pd.to_numeric(raw["inventory_days"], errors="coerce")
raw["inventory_days"] = raw["inventory_days"].fillna(raw["inventory_days"].median()).round().astype(int)
for col in ["units_sold", "unit_price", "discount_rate", "sales", "cost", "profit"]:
    raw[col] = pd.to_numeric(raw[col], errors="coerce")
df = raw.dropna(subset=["order_id", "order_date", "category", "product"])
df = df.drop_duplicates(subset=["order_id"])
df["order_date"] = df["order_date"].dt.strftime("%Y-%m-%d")
df.to_csv(BASE / "retail_sales_cleaned.csv", index=False)

# Category profitability and margin
category = df.groupby("category").agg(
    orders=("order_id", "count"), units_sold=("units_sold", "sum"),
    sales=("sales", "sum"), cost=("cost", "sum"), profit=("profit", "sum"),
    avg_inventory_days=("inventory_days", "mean")
).reset_index()
category["profit_margin_pct"] = (category["profit"] / category["sales"] * 100).round(2)
category.to_csv(BASE / "category_summary.csv", index=False)

# Seasonal performance
seasonal = df.groupby(["season", "category"]).agg(
    units_sold=("units_sold", "sum"), sales=("sales", "sum"), profit=("profit", "sum")
).reset_index()
seasonal.to_csv(BASE / "seasonal_summary.csv", index=False)

# Inventory / product performance
inventory = df.groupby(["category", "product"]).agg(
    units_sold=("units_sold", "sum"), avg_inventory_days=("inventory_days", "mean"),
    sales=("sales", "sum"), profit=("profit", "sum")
).reset_index()
inventory.to_csv(BASE / "product_inventory_summary.csv", index=False)

# Pearson correlation: association only, not proof of causation
corr = df[["inventory_days", "profit"]].corr(method="pearson").iloc[0, 1]
print(f"Rows analysed: {len(df)}")
print(f"Pearson correlation (inventory days vs order profit): {corr:.3f}")
print("Files created: cleaned data and three summary CSVs.")
