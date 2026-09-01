-- Customers with their last purchase ordered by how much money they spent during the year
SELECT CustomerID, MAX(InvoiceDate), count(DISTINCT(`InvoiceNo`)) AS Frequency, ROUND(SUM(`totalPrice`), 2) as Monetary
FROM cleaned_online_retail
GROUP BY `CustomerID`
HAVING Frequency > 10 
ORDER BY Monetary Desc LIMIT 100;

SELECT CustomerId, MAX(InvoiceDate) AS LastPurchaseDate
FROM cleaned_online_retail
GROUP BY CustomerID
ORDER BY LastPurchaseDate DESC;

-- Customer Segmentation
WITH customer_metrics AS (
    SELECT 
        CustomerID, 
        DATEDIFF('2011-12-09', MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT CASE WHEN Cancelled = 0 THEN InvoiceNo END) AS Frequency,
        ROUND(SUM(`totalPrice`), 2) AS Monetary
    FROM cleaned_online_retail
    GROUP BY CustomerID
),
customer_segments AS (
    SELECT 
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        CASE 
            WHEN Frequency < 6 THEN "Low Frequency"
            WHEN Frequency < 13 THEN "Medium Frequency"
            WHEN Frequency < 51 THEN "High Frequency"
            ELSE "Very High Frequency"
        END AS CustomerSegmentation
    FROM customer_metrics
)
SELECT 
    CustomerSegmentation,
    COUNT(*) AS CustomerCount,
    ROUND(AVG(Monetary), 2) AS AvgMonetary,
    ROUND(AVG(Recency), 2) AS AvgRecency,
    ROUND(AVG(Frequency), 2) AS AvgFrequency
FROM customer_segments
GROUP BY CustomerSegmentation
ORDER BY AvgMonetary DESC;

-- Added two more categories based on recency 
WITH customer_metrics AS (
    SELECT 
        CustomerID, 
        DATEDIFF('2011-12-09', MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT CASE WHEN Cancelled = 0 THEN InvoiceNo END) AS Frequency,
        ROUND(SUM(`totalPrice`), 2) AS Monetary
    FROM cleaned_online_retail
    GROUP BY CustomerID
),
customer_segments AS (
    SELECT 
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        CASE 
            WHEN Monetary > 10000 THEN "VIP Client"
            WHEN Frequency < 6 AND Recency <= 30 THEN "Low Frequency Promising"
            WHEN Frequency < 6 AND Recency > 30 THEN "Low Frequency At Risk"
            WHEN Frequency < 13 AND Recency <= 30 THEN "Medium Frequency Promising"
            WHEN Frequency < 13 AND Recency > 30 THEN "Medium Frequency At Risk"
            ELSE "High Frequency"
        END AS CustomerSegmentation
    FROM customer_metrics
)
SELECT 
    CustomerSegmentation,
    COUNT(*) AS CustomerCount,
    ROUND(AVG(Monetary), 2) AS AvgMonetary,
    ROUND(AVG(Recency), 2) AS AvgRecency,
    ROUND(AVG(Frequency), 2) AS AvgFrequency,
    ROUND(AVG(Monetary / NULLIF(Frequency, 0)), 2) AS AOV
FROM customer_segments
GROUP BY CustomerSegmentation
ORDER BY AvgMonetary DESC;

-- High value accounts detail extract
WITH customer_metrics AS (
    SELECT 
        CustomerID, 
        DATEDIFF('2011-12-09', MAX(InvoiceDate)) AS Recency,
        COUNT(DISTINCT CASE WHEN Cancelled = 0 THEN InvoiceNo END) AS Frequency,
        ROUND(SUM(`totalPrice`), 2) AS Monetary
    FROM cleaned_online_retail
    GROUP BY CustomerID
),
customer_segments AS (
    SELECT 
        CustomerID,
        Recency,
        Frequency,
        Monetary,
        ROUND((Monetary / NULLIF(Frequency, 0)), 2) AS AverageOrderValue,
        CASE 
            WHEN Monetary > 10000 THEN "VIP Client"
            WHEN Frequency < 6 AND Recency <= 30 THEN "Low Frequency Promising"
            WHEN Frequency < 6 AND Recency > 30 THEN "Low Frequency At Risk"
            WHEN Frequency < 13 AND Recency <= 30 THEN "Medium Frequency Promising"
            WHEN Frequency < 13 AND Recency > 30 THEN "Medium Frequency At Risk"
            WHEN Frequency < 51 THEN "High Frequency"
            ELSE "Very High Frequency"
        END AS CustomerSegmentation
    FROM customer_metrics
)
SELECT 
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    AverageOrderValue,
    CustomerSegmentation
FROM customer_segments
WHERE CustomerSegmentation IN ('High Frequency', 'Very High Frequency', 'VIP Client')
ORDER BY Monetary DESC;

-- General Statistics organized by country
SELECT
    Country,
    ROUND(SUM(totalPrice), 2) AS TotalRevenue,
    COUNT(DISTINCT CustomerID) AS UniqueCustomers,
    COUNT(DISTINCT CASE WHEN Cancelled = 0 THEN InvoiceNo END) AS ValidOrders,
    COUNT(DISTINCT InvoiceNo) AS UniqueInvoices,
    ROUND(SUM(totalPrice) / NULLIF(COUNT(DISTINCT CASE WHEN Cancelled = 0 THEN InvoiceNo END), 0), 2) AS AverageOrderValue,
    ROUND(SUM(totalPrice) / NULLIF(COUNT(DISTINCT CustomerID), 0), 2) AS RevenuePerCustomer,
    ROUND(COUNT(DISTINCT CASE WHEN Cancelled = 1 THEN InvoiceNo END) * 100.0 / NULLIF(COUNT(DISTINCT InvoiceNo), 0), 2) AS CancellationRate
FROM cleaned_online_retail
GROUP BY Country
ORDER BY TotalRevenue DESC;