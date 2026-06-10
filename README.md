DataCo Supply Chain Performance Analysis
An end-to-end data analytics project on a global e-commerce supply chain dataset (~180,000 orders), covering data cleaning, exploratory data analysis, SQL-based business intelligence, and an interactive Power BI dashboard. The project surfaces actionable insights across revenue, delivery performance, product profitability, and customer behaviour.

Project Structure
├── DataCoSupplyChainDataset.csv   # Raw dataset (source)
├── Data_Cleaning_script.ipynb     # Python data cleaning pipeline
├── cleaned_dataset.csv            # Cleaned, analysis-ready dataset
├── Create_Table.sql               # PostgreSQL table schema
├── Analysis_query.sql             # Full SQL analysis (40+ queries)
├── EDA.ipynb                      # Python EDA with statistical tests
└── Datacopbi.pbix                 # Power BI dashboard

Dataset Overview

Source: DataCo Global Supply Chain dataset
Rows: ~180,000 order-item records
Scope: Orders across 6 markets (Europe, LATAM, Pacific Asia, USCA, Africa, Middle East)
Key fields: Order details, product categories, customer segments, shipping mode, delivery status, revenue, and profit metrics


Tools & Technologies
LayerToolsData CleaningPython (Pandas, NumPy)Exploratory AnalysisPython (Matplotlib, Seaborn, SciPy)Business IntelligencePostgreSQL (40+ SQL queries)VisualisationPower BI

Key Findings
Revenue & Profitability

Total revenue: $36.78M across all orders
Total profit: $3.97M — an overall profit margin of ~10.8%
Revenue lost to cancellations: $744,370
Fan Shop generates the highest revenue; Fitness delivers the highest profit margin percentage

Delivery Performance

54.83% of all orders are delivered late — the single biggest operational issue
Root cause: a scheduling mismatch, not an operations failure. First Class shipping promises 1-day delivery but consistently takes 2 days, producing a 95.3% late delivery rate for that mode alone
Second Class shipments are delayed by an average of 2 days vs. schedule
Late delivery rate is consistent across all markets and departments, confirming it is a systemic, company-wide issue

Product & Category Analysis

Computers is the most loss-making category, despite having a listed price of ~$1,500
Losses occur even on orders with 0% discount — with some orders recording losses as high as $2,550
Root cause: procurement cost exceeds the selling price. This is a pricing strategy failure, not a discount control problem
Cleats and Men's Footwear have the highest cancellation volumes

Customer Behaviour

The Consumer segment drives the highest revenue
Cancellation rates are nearly equal across all three segments (Consumer, Corporate, Home Office)
High-cancellation customers are identifiable by customer_id — enabling targeted retention interventions

Statistical Tests (EDA Notebook)

T-Test: Cancelled orders have a statistically significant difference in profit vs. non-cancelled orders (p < 0.05)
Chi-Square Test: Shipping mode and delivery status are significantly associated — shipping mode choice is a meaningful predictor of late delivery


SQL Analysis Highlights
The Analysis_query.sql file contains 40+ queries organised into five themes:

Revenue Analysis — total revenue, profit, profit margin, cancellation losses
Delivery Performance — late delivery rates by mode, market, and department; scheduled vs. actual shipping days
Customer Behaviour — cancellation rates by segment, revenue per segment, high-value customer ranking
Product Analysis — most cancelled categories, loss-making categories, discount impact, computers deep-dive
Advanced Analytics — window functions (RANK, PARTITION BY), CTEs, CASE-based profit banding


Power BI Dashboard
The Datacopbi.pbix file contains an interactive dashboard covering:

Revenue and profit KPIs
Late delivery rate by shipping mode and market
Category-level profitability breakdown
Monthly revenue and profit trends
Order status distribution


How to Reproduce

Load the data into PostgreSQL

sql   -- Run Create_Table.sql first to create the schema
   -- Then load cleaned_dataset.csv using \COPY or pgAdmin import
   \COPY cleaned_dataset FROM 'cleaned_dataset.csv' DELIMITER ',' CSV HEADER;

Run SQL analysis

sql   -- Open Analysis_query.sql in pgAdmin or any PostgreSQL client and execute

Run Python notebooks

bash   pip install pandas numpy matplotlib seaborn scipy
   jupyter notebook Data_Cleaning_script.ipynb
   jupyter notebook EDA.ipynb

Open Power BI dashboard

Open Datacopbi.pbix in Power BI Desktop
Update the data source path to point to cleaned_dataset.csv if prompted




Business Recommendations
ProblemRecommendation95% late delivery rate for First ClassRevise scheduled delivery promise from 1 day to 2 daysComputers sold below costAudit procurement pricing; raise selling price or discontinue the SKU$744K revenue lost to cancellationsInvestigate cancellation triggers; introduce order confirmation workflowsHigh Cleats cancellation volumeReview stock availability and return policy for footwear
