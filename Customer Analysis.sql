# Read the database
SELECT *
FROM `Customer Personality`.`marketing_campaign`;

-- Before conducting analysis, let's eliminate missing values or null values to avoid errors
SELECT * FROM `Customer Personality`.`marketing_campaign`
WHERE ID IS NULL
OR Year_Birth IS NULL
OR Education IS NULL
OR Marital_Status IS NULL
OR Income IS NULL
OR Kidhome IS NULL
OR Teenhome IS NULL
OR Dt_Customer IS NULL
OR Recency IS NULL
OR MntWines IS NULL
OR MntFruits IS NULL
OR MntMeatProducts IS NULL
OR MntFishProducts IS NULL
OR MntSweetProducts IS NULL
OR MntGoldProds IS NULL
OR NumDealsPurchases IS NULL
OR NumWebPurchases IS NULL
OR NumCatalogPurchases IS NULL
OR NumStorePurchases IS NULL
OR NumWebVisitsMonth IS NULL
OR AcceptedCmp3 IS NULL
OR AcceptedCmp4 IS NULL
OR AcceptedCmp5 IS NULL
OR AcceptedCmp1 IS NULL
OR AcceptedCmp2 IS NULL
OR Complain IS NULL
OR Z_CostContact IS NULL
OR Z_Revenue IS NULL
OR Response IS NULL;
-- no null values

# 1. Calculate the average income of customers in different education levels
SELECT Education, AVG(Income) AS AvgIncome
FROM `Customer Personality`.`marketing_campaign`
GROUP BY Education;

# 2. Count the number of customers who complained in the last 2 years
SELECT COUNT(*) AS NumComplainers
FROM `Customer Personality`.`marketing_campaign`
WHERE Complain = 1;
-- 21

# 3. Find the top-spending customers based on the total amount spent on all product categories
SELECT ID, (MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + MntGoldProds) AS TotalSpent
FROM `Customer Personality`.`marketing_campaign`
ORDER BY TotalSpent DESC
LIMIT 5;
-- ID: 5735, 5350, 1763, 4580, 4475

# 4. Calculate the acceptance rate for each campaign
SELECT
  SUM(AcceptedCmp1) / COUNT(*) AS AcceptanceRate_Cmp1,
  SUM(AcceptedCmp2) / COUNT(*) AS AcceptanceRate_Cmp2,
  SUM(AcceptedCmp3) / COUNT(*) AS AcceptanceRate_Cmp3,
  SUM(AcceptedCmp4) / COUNT(*) AS AcceptanceRate_Cmp4,
  SUM(AcceptedCmp5) / COUNT(*) AS AcceptanceRate_Cmp5
FROM `Customer Personality`.`marketing_campaign`;

# 5. Identify customers who made purchases through all available channels (web, catalog, and store)
SELECT ID
FROM `Customer Personality`.`marketing_campaign`
WHERE NumWebPurchases > 0
  AND NumCatalogPurchases > 0
  AND NumStorePurchases > 0;

# 6. Calculate the average recency (number of days since last purchase) for customers who accepted the last campaign and those who didn't
SELECT Response, AVG(Recency) AS AvgRecency
FROM `Customer Personality`.`marketing_campaign`
GROUP BY Response;

# 7. Calculate the average amount spent on each product category (e.g., wine, meat, fish) for customers with and without children
SELECT Kidhome,
       AVG(MntWines) AS AvgWineSpent,
       AVG(MntMeatProducts) AS AvgMeatSpent,
       AVG(MntFishProducts) AS AvgFishSpent
FROM `Customer Personality`.`marketing_campaign`
GROUP BY Kidhome;

# 8. Determine the most popular campaign (highest acceptance rate) among customers who have accepted at least one campaign
WITH CampaignAcceptance AS (
    SELECT Response, SUM(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 + AcceptedCmp4 + AcceptedCmp5) AS TotalAccepted
    FROM `Customer Personality`.`marketing_campaign`
    GROUP BY Response
)
SELECT Response
FROM CampaignAcceptance
ORDER BY TotalAccepted DESC
LIMIT 1;

# 9. Find the top 3 marital statuses with the highest average income
SELECT Marital_Status, AVG(Income) AS AvgIncome
FROM `Customer Personality`.`marketing_campaign`
GROUP BY Marital_Status
ORDER BY AvgIncome DESC
LIMIT 3;

# 10. Calculate the average number of web visits per month for customers who accepted each campaign
SELECT
  Response,
  AVG(NumWebVisitsMonth) AS AvgWebVisits
FROM `Customer Personality`.`marketing_campaign`
GROUP BY Response;

# 11. Identify customers who have a high total spend on sweets (MntSweetProducts) but have not accepted any campaign
SELECT ID
FROM `Customer Personality`.`marketing_campaign`
WHERE MntSweetProducts > 500
  AND AcceptedCmp1 = 0
  AND AcceptedCmp2 = 0
  AND AcceptedCmp3 = 0
  AND AcceptedCmp4 = 0
  AND AcceptedCmp5 = 0
  AND Response = 0;

# 12. Find the average number of web visits per month for customers whose last purchase was less than 30 days ago
SELECT AVG(NumWebVisitsMonth) AS AvgWebVisits
FROM `Customer Personality`.`marketing_campaign`
WHERE Recency < 30;

# 13. Calculate the acceptance rate for each campaign among customers with incomes above the overall average income
WITH AvgIncome AS (
    SELECT AVG(Income) AS OverallAvgIncome
    FROM `Customer Personality`.`marketing_campaign`
)
SELECT
  Response,
  SUM(AcceptedCmp1) / COUNT(*) AS AcceptanceRate_Cmp1,
  SUM(AcceptedCmp2) / COUNT(*) AS AcceptanceRate_Cmp2,
  SUM(AcceptedCmp3) / COUNT(*) AS AcceptanceRate_Cmp3,
  SUM(AcceptedCmp4) / COUNT(*) AS AcceptanceRate_Cmp4,
  SUM(AcceptedCmp5) / COUNT(*) AS AcceptanceRate_Cmp5
FROM `Customer Personality`.`marketing_campaign`
CROSS JOIN AvgIncome
WHERE Income > OverallAvgIncome
GROUP BY Response;




