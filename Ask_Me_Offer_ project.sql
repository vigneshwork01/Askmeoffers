SELECT * FROM ASKMEOFFERS;


--1. Coupon Usage:

SELECT COUNT(USER_ID) FROM ASKMEOFFERS;

SELECT DEVICE_TYPE, COUNT(USER_ID) FROM ASKMEOFFERS GROUP BY DEVICE_TYPE;

SELECT LOCATION, COUNT(USER_ID) FROM ASKMEOFFERS GROUP BY LOCATION;

SELECT PRODUCT_CATEGORY, COUNT(*) FROM ASKMEOFFERS GROUP BY PRODUCT_CATEGORY;


--2. Coupon Application Success Rate:

SELECT 
 ROUND((SUM(CASE WHEN COUPON_APPLICATION = 'Successful' THEN 1 else 0 END)/COUNT(*))*100,2) AS Success_Rate
FROM ASKMEOFFERS;


-- Percentage of coupons that failed to apply

SELECT 
 ROUND((SUM(CASE WHEN COUPON_APPLICATION = 'Failed' THEN 1 else 0 END)/COUNT(*))*100,2) AS Failure_Rate
FROM ASKMEOFFERS;

-- Percentage of coupons that failed to apply by category


SELECT PRODUCT_CATEGORY,
 ROUND((SUM(CASE WHEN COUPON_APPLICATION = 'Failed' THEN 1 else 0 END)/COUNT(*))*100,2) AS Failure_Rate
FROM ASKMEOFFERS GROUP BY PRODUCT_CATEGORY;

-- Percentage of coupons that failed to apply by Websites

SELECT WEBSITES,
 ROUND((SUM(CASE WHEN COUPON_APPLICATION = 'Failed' THEN 1 else 0 END)/COUNT(*))*100,2) AS Failure_Rate
FROM ASKMEOFFERS GROUP BY WEBSITES;

--3. Discount Effectiveness

-- Average discount percentage applied

SELECT 
  ROUND(AVG(COUPON_DISCOUNT_PERCENTAGE)*100, 2) AS AVG_COUPON_PERCENTAGE
FROM ASKMEOFFERS WHERE coupon_application= 'Successful';

-- Total discount amount applied
SELECT 
  SUM(COUPON_AMOUNT) AS total_coupon_amount
FROM ASKMEOFFERS
WHERE coupon_application= 'Successful';

-- Average discount amount per successful coupon application
SELECT 
  ROUND(AVG(COUPON_AMOUNT), 2) AS Avg_coupon_amount
FROM coupon_usage
WHERE success = 1;

--4. Conversion Rates:

-- Percentage of cart abandonments
SELECT 
  ROUND(100.0 * SUM(CASE WHEN CART_ABANDONMENT = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS cart_abandonment_rate
FROM ASKMEOFFERS;

-- Percentage of completed purchases
SELECT 
  ROUND(100.0 * SUM(CASE WHEN PURCHASE = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS purchase_completion_rate
FROM ASKMEOFFERS;

-- Conversion rate (purchases / cart visits)
SELECT 
  ROUND(100.0 * SUM(CASE WHEN PURCHASE = 'Yes' THEN 1 ELSE 0 END) / COUNT(CART_ABANDONMENT), 2) AS conversion_rate
FROM ASKMEOFFERS;

--5. Customer Savings:

-- Total customer savings from successful coupon applications
SELECT 
  SUM(COUPON_AMOUNT) AS total_customer_savings
FROM ASKMEOFFERS
WHERE PURCHASE = 'Yes';

-- Average customer savings per successful coupon application
SELECT 
  ROUND(AVG(COUPON_AMOUNT), 2) AS avg_customer_savings
FROM ASKMEOFFERS
WHERE PURCHASE = 'Yes';

--6. Revenue Impact:

-- Total revenue generated from purchases with successful coupon applications
SELECT 
  SUM(PURCHASED_PRICE) AS total_revenue_with_coupons
FROM ASKMEOFFERS
WHERE PURCHASE= 'Yes';

-- Incremental revenue from coupon usage (compared to non-coupon purchases)
SELECT 
  ROUND(
    (SUM(CASE WHEN COUPON_APPLICATION = 'Successful' AND PURCHASE = 'Yes' THEN PURCHASED_PRICE ELSE 0 END) -
     SUM(CASE WHEN COUPON_APPLICATION = 'Falied' THEN PURCHASED_PRICE ELSE 0 END)) /
    SUM(PURCHASED_PRICE) * 100, 2
  ) AS Percentage_incremental_revenue_from_coupons
FROM ASKMEOFFERS;

