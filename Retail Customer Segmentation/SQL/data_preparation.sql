-- Check before creating Table
-- Check for negative values on quantity
SELECT *
FROM online_retail
WHERE Quantity <= 0

-- Check empty values on CustomerID
SELECT * 
FROM online_retail
WHERE `CustomerID` = "" or `CustomerID` is NULL

-- Check empty values on Description
SELECT * 
FROM online_retail
WHERE `Description` = "" or `Description` is NULL

-- Check for unsual UnitPrice
SELECT *
FROM online_retail
WHERE UnitPrice <= 0

-- Check for unusual descriptions
SELECT *
FROM online_retail
WHERE LENGTH(`Description`) <5

-- Check for duplicate values
SELECT 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    UnitPrice, 
    CustomerID, 
    Country,
    COUNT(*) AS duplicate_count
FROM online_retail
GROUP BY 
    InvoiceNo, 
    StockCode, 
    Description, 
    Quantity, 
    InvoiceDate, 
    UnitPrice, 
    CustomerID, 
    Country
HAVING COUNT(*) > 1;

-- Check for outliers in Country
SELECT DISTINCT(`Country`)
FROM online_retail

SELECT *
FROM online_retail
WHERE `Country` = "Unspecified" or `Country`= "European Community"

-- Check for unsual UnitPrice Part 2
SELECT *
FROM online_retail
WHERE UnitPrice > 5000

-- Update date format to DATETIME
ALTER TABLE online_retail
MODIFY COLUMN InvoiceDate DATETIME;

-- Negative quantity values with positive price
SELECT *
FROM online_retail
WHERE Quantity < 0 AND UnitPrice > 0

-- Positive quantity values with negative price
SELECT *
FROM online_retail
WHERE Quantity > 0 AND UnitPrice < 0

-- Add a new column to boolean to check for cancelled orders
SELECT stockcode, `InvoiceNo`,
CASE
    WHEN invoiceNo Like 'C%' THEN 1
    ELSE 0
END AS Cancelled
FROM online_retail
HAVING Cancelled = 1

-- Add new column boolean to check for discounts
SELECT stockcode, `InvoiceNo`, `Description`,
CASE
    WHEN StockCode = 'D' THEN 1
    ELSE 0
END AS Discounted
FROM online_retail
HAVING Discounted = 1

-- Add new column for total price
SELECT  Quantity, UnitPrice, ROUND((Quantity * UnitPrice), 2) AS 'totalPrice'
FROM online_retail

-- Check for 0 PriceUnit dummy variable
Select UnitPrice, `Description`
FROM online_retail
WHERE UnitPrice = 0

-- Create Table with changes to clean file
CREATE TABLE cleaned_online_retail AS
SELECT DISTINCT
    InvoiceNo,
    StockCode,
    `Description`,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    CASE
        WHEN InvoiceNo LIKE 'C%' THEN 1
        ELSE 0
    END AS Cancelled,
    CASE
        WHEN StockCode = 'D' THEN 1
        ELSE 0
    END AS Discounted,
    ROUND((Quantity * UnitPrice), 2) AS 'totalPrice'
FROM online_retail
WHERE
    UnitPrice > 0 AND
    CustomerID IS NOT NULL AND CustomerID != "" AND
    `Description` IS NOT NULL AND `Description` != "" AND
    Country NOT IN ("Unspecified", "European Community");