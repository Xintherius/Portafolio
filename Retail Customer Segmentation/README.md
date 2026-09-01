# Customer Segmentation & Retention Analysis
**Author:** Andres Chisaca
**Tools Used:** Tableau, Data Visualization, Boolean Logic  

## Project Overview
This project analyzes customer transaction data to identify purchasing patterns by country, segment user bases, and evaluate retention risks. The primary objective is to move beyond standard KPIs to uncover actionable business insights regarding customer loyalty and the effectiveness of promotional discounts. 

## Key Insights & Segments
By mapping customer behavior through a Recency vs. Frequency scatter plot, several distinct segments and trends emerged:

*   **The Core Base:** A large concentration of high-frequency, low-spend customers forms the backbone of the business. 
*   **The At-Risk Sector:** A significant segment of customers falls into a "low-frequency, at-risk" category, visiting slightly less than once in 70 days with lower monetary value. 
*   **Spend vs. Recency Trend:** Applying a power trend line revealed a clear mathematical relationship: as customer spend increases, recency decreases (meaning higher-value customers tend to have shopped more recently).
*   **Discount Effectiveness:** Segmenting the data by `Discount Status` (a boolean indicating if a transaction included a discount) showed that absolutely zero highly-inactive customers had used a discount, suggesting a strong correlation between promotional offers and continued engagement. 

## Visualizations
**1. Kpis by Customer Segmentation**  
![Kpis by Customer Segmentation](/Retail%20Customer%20Segmentation/Images/Kpis%20by%20Customer%20Segmentation.png)  
*KPI's based on customer segmentation. Covers number of customers, average days without making a purchase, average orders made in the last year, and average monetary value spent.*

**2. Retention Risk by Discount Status**  
![Discount Status Segmentation](/Retail%20Customer%20Segmentation/Images/Customer%20Retention%20&%20Spend%20Risk%20by%20Discount%20Status.png)
*A side-by-side comparison showing the behavioral differences between customers who utilized discounts versus those who did not.*

**3. Country Performance Overview**
![Country Performance Overview](/Retail%20Customer%20Segmentation/Images/Country%20Performance%20Overview.png)
*A comparison of every country that has customers, it goes over Total Revenue, Unique Customers, Valid Orders, Unique Invoices, Average Order Value (AOV), Average Revenue per Customer, and Average Cancellation Rate*

## Strategic Recommendations
*   Based on the data, promotional discounts appear to be a strong mechanism for maintaining customer activity. The business should consider implementing targeted discount campaigns specifically aimed at the "Low-Frequency / At-Risk" segment to re-engage them before they churn entirely.

*   Based on the visualizations, as of right now we have vast majority of our customers in the UK. The Netherlands, Australia, and EIRE spend more money than any other country per customer, meaning that it is advisable for the marketing team to expand efforts in the country to try and attract more customers with similar behaviors.

*   Although we don't have much data regarding discounts, it was evident that customers that use discounts have a better frequency. Meaning that expanding the pool of customers that use discounts could 1) give us more information about the effectiveness of discounts and 2) Potentially bring customers to higher frequencies as they can see individual benefits.
