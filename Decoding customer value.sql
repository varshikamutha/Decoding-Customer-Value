CREATE DATABASE customer_behavior;
USE customer_behavior;

USE customer_behavior;
SHOW TABLES;

SELECT *
FROM dataset
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM dataset;

DESCRIBE dataset;
ALTER TABLE dataset
RENAME COLUMN `ï»¿Customer ID` TO customer_id;

SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM dataset;

# checking for the duplicates 
SELECT customer_id,
    COUNT(*) AS row_count
FROM dataset
GROUP BY customer_id
HAVING COUNT(*) > 1;

# missing value check 
SELECT
    COUNT(*) AS total_rows,
    SUM(customer_id IS NULL) AS missing_customer_id,
    SUM(Age IS NULL) AS missing_age,
    SUM(Gender IS NULL) AS missing_gender,
    SUM(Category IS NULL) AS missing_category,
    SUM(`Purchase Amount (USD)` IS NULL) AS missing_purchase_amount,
    SUM(Location IS NULL) AS missing_location,
    SUM(Season IS NULL) AS missing_season,
    SUM(`Review Rating` IS NULL) AS missing_rating,
    SUM(`Previous Purchases` IS NULL) AS missing_previous_purchases,
    SUM(`Discount Applied` IS NULL) AS missing_discount,
    SUM(`Promo Code Used` IS NULL) AS missing_promo
FROM dataset;

#checking the values of discount applied
SELECT
    `Discount Applied`,
    COUNT(*) AS customers
FROM dataset
GROUP BY `Discount Applied`;

#checking promo code used 
SELECT
    `Promo Code Used`,
    COUNT(*) AS customers
FROM dataset
GROUP BY `Promo Code Used`;

# checking previous purchases
SELECT
    MIN(`Previous Purchases`) AS minimum_previous_purchases,
    MAX(`Previous Purchases`) AS maximum_previous_purchases,
    ROUND(AVG(`Previous Purchases`), 2) AS average_previous_purchases
FROM dataset;

#checking purchase amount(usd)
SELECT
    MIN(`Purchase Amount (USD)`) AS minimum_purchase,
    MAX(`Purchase Amount (USD)`) AS maximum_purchase,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS average_purchase
FROM dataset;

#checking review rating 
SELECT
    MIN(`Review Rating`) AS minimum_rating,
    MAX(`Review Rating`) AS maximum_rating,
    ROUND(AVG(`Review Rating`), 2) AS average_rating
FROM dataset;

#checking frequency of purchase
SELECT
    `Frequency of Purchases`,
    COUNT(*) AS customers
FROM dataset
GROUP BY `Frequency of Purchases`
ORDER BY customers DESC;

#checking subscription status
SELECT
    `Subscription Status`,
    COUNT(*) AS customers
FROM dataset
GROUP BY `Subscription Status`;

#promo depency score
SELECT
    customer_id,
    `Discount Applied`,
    `Promo Code Used`,
    
    CASE
        WHEN `Discount Applied` = 'Yes'
             AND `Promo Code Used` = 'Yes'
            THEN 2
            
        WHEN `Discount Applied` = 'Yes'
             OR `Promo Code Used` = 'Yes'
            THEN 1
        ELSE 0
    END AS promo_dependency_score

FROM dataset
LIMIT 20;

# checking discount/promo combinations 
SELECT
    `Discount Applied`,
    `Promo Code Used`,
    COUNT(*) AS customers
FROM dataset
GROUP BY
    `Discount Applied`,
    `Promo Code Used`
ORDER BY
    `Discount Applied`,
    `Promo Code Used`;
  #verifying   
    SELECT
    `Discount Applied`,
    `Promo Code Used`,
    COUNT(*) AS customers
FROM dataset
GROUP BY
    `Discount Applied`,
    `Promo Code Used`;
    
    #creating promo depency score 
    SELECT
    customer_id,
    `Discount Applied`,
    
    CASE
        WHEN `Discount Applied` = 'Yes' THEN 1
        ELSE 0
    END AS promo_dependency_score

FROM dataset
LIMIT 20;

#Verify the score across the entire dataset
SELECT
    CASE
        WHEN `Discount Applied` = 'Yes' THEN 1
        ELSE 0
    END AS promo_dependency_score,
    COUNT(*) AS customers
FROM dataset
GROUP BY
    promo_dependency_score;
    
    #Create the Satisfaction Flag
    SELECT
    customer_id,
    `Review Rating`,

    CASE
        WHEN `Review Rating` >= 4 THEN 'Satisfied'
        ELSE 'Lower Satisfaction'
    END AS satisfaction_flag

FROM dataset
LIMIT 20;

#Find the average values for our customer base
SELECT
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases
FROM dataset;

#Create the first Value Tier
SELECT
    customer_id,
    `Purchase Amount (USD)`,
    `Previous Purchases`,

    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
            THEN 'High Value'

        WHEN `Purchase Amount (USD)` >= 59.70
             OR `Previous Purchases` >= 25.34
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS value_tier

FROM dataset
LIMIT 20;

#Count customers by Value Tier
SELECT
    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
            THEN 'High Value'

        WHEN `Purchase Amount (USD)` >= 59.70
             OR `Previous Purchases` >= 25.34
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS value_tier,

    COUNT(*) AS customers

FROM dataset

GROUP BY value_tier
ORDER BY customers DESC;

#Compare Value Tier with Promo Dependency
SELECT
    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
            THEN 'High Value'

        WHEN `Purchase Amount (USD)` >= 59.70
             OR `Previous Purchases` >= 25.34
            THEN 'Medium Value'

        ELSE 'Low Value'
    END AS value_tier,

    CASE
        WHEN `Discount Applied` = 'Yes' THEN 1
        ELSE 0
    END AS promo_dependency_score,

    COUNT(*) AS customers

FROM dataset

GROUP BY
    value_tier,
    promo_dependency_score

ORDER BY
    value_tier,
    promo_dependency_score;
    
    #Create Loyalty Definition #1
    SELECT
    customer_id,
    `Purchase Amount (USD)`,
    `Previous Purchases`,

    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
            THEN 'Loyal'
        ELSE 'Non-Loyal'
    END AS loyalty_definition_1

FROM dataset
LIMIT 20;

#Test Loyalty Definition #1
SELECT
    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
            THEN 'Loyal'
        ELSE 'Non-Loyal'
    END AS loyalty_definition_1,

    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS avg_promo_dependency

FROM dataset

GROUP BY loyalty_definition_1;

#Create Loyalty Definition #2
SELECT
    customer_id,
    `Purchase Amount (USD)`,
    `Previous Purchases`,
    `Discount Applied`,

    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
             AND `Discount Applied` = 'No'
            THEN 'Strongly Loyal'
        ELSE 'Other'
    END AS loyalty_definition_2

FROM dataset
LIMIT 20;

#Test Loyalty Definition #2
SELECT
    CASE
        WHEN `Purchase Amount (USD)` >= 59.70
             AND `Previous Purchases` >= 25.34
             AND `Discount Applied` = 'No'
            THEN 'Strongly Loyal'
        ELSE 'Other'
    END AS loyalty_definition_2,

    COUNT(*) AS customers,

    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,

    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,

    ROUND(AVG(`Review Rating`), 2) AS avg_rating,

    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS avg_promo_dependency

FROM dataset

GROUP BY loyalty_definition_2;

#Category Analysis
SELECT
    Category,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating
FROM dataset
GROUP BY Category
ORDER BY avg_previous_purchases DESC;

#Analyze Season
SELECT 
    Season,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating
FROM dataset
GROUP BY Season
ORDER BY avg_previous_purchases DESC;

#Geographic Opportunity
SELECT
    Location,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(
        CASE
            WHEN `Discount Applied` = 'Yes' THEN 1
            ELSE 0
        END
    ), 2) AS avg_promo_dependency,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating
FROM dataset
GROUP BY Location
ORDER BY avg_purchase_amount DESC;

#Demographic Analysis
SELECT
    Gender,
    COUNT(*) AS customers,
    ROUND(AVG(Age), 1) AS avg_age,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_purchase_amount,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating
FROM dataset
GROUP BY Gender
ORDER BY avg_previous_purchases DESC;

#Find the strongest customer profile
	SELECT
		Gender,
		ROUND(AVG(Age), 1) AS avg_age,
		ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
		ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
		ROUND(AVG(`Review Rating`), 2) AS avg_rating,
		ROUND(AVG(CASE 
			WHEN `Discount Applied` = 'Yes' THEN 1 
			ELSE 0 
		END), 2) AS promo_dependency
	FROM dataset
	GROUP BY Gender
	ORDER BY avg_spend DESC, avg_previous_purchases DESC;
    
    #Find the strongest age group
    SELECT
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,

    COUNT(*) AS customers,

    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,

    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,

    ROUND(AVG(`Review Rating`), 2) AS avg_rating,

    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency

FROM dataset

GROUP BY age_group

ORDER BY avg_previous_purchases DESC;

#Find the strongest category for the ICP
SELECT
    Category,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY Category
ORDER BY avg_previous_purchases DESC;

#Subscription status
SELECT
    `Subscription Status`,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY `Subscription Status`
ORDER BY avg_previous_purchases DESC;

#Find the strongest payment preference
SELECT
    `Payment Method`,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY `Payment Method`
ORDER BY avg_previous_purchases DESC;

#Final ICP
SELECT
    Gender,
    CASE
        WHEN Age < 30 THEN 'Under 30'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    Category,
    `Subscription Status`,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY
    Gender,
    age_group,
    Category,
    `Subscription Status`
HAVING COUNT(*) >= 30
ORDER BY
    avg_previous_purchases DESC,
    avg_spend DESC,
    promo_dependency ASC
LIMIT 10;

#Q1. Loyal vs discount-dependent customers
SELECT
    CASE
        WHEN `Previous Purchases` >= 25
             AND `Discount Applied` = 'No'
        THEN 'Loyal - Low Promo'

        WHEN `Previous Purchases` >= 25
             AND `Discount Applied` = 'Yes'
        THEN 'Loyal - Promo Dependent'

        WHEN `Previous Purchases` < 25
             AND `Discount Applied` = 'Yes'
        THEN 'Low Loyalty - Promo Driven'

        ELSE 'Low Loyalty - Organic'
    END AS customer_segment,

    COUNT(*) AS customers,

    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,

    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,

    ROUND(AVG(`Review Rating`), 2) AS avg_rating

FROM dataset

GROUP BY customer_segment

ORDER BY avg_previous_purchases DESC;

#Q2 — Behavioral patterns associated with high customer value
SELECT
    CASE
        WHEN `Previous Purchases` >= 25
             AND `Purchase Amount (USD)` >= 60
        THEN 'High Value'

        WHEN `Previous Purchases` >= 15
             OR `Purchase Amount (USD)` >= 50
        THEN 'Medium Value'

        ELSE 'Low Value'
    END AS value_segment,

    COUNT(*) AS customers,

    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,

    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,

    ROUND(AVG(`Review Rating`), 2) AS avg_rating,

    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency

FROM dataset

GROUP BY value_segment

ORDER BY avg_spend DESC;

#Q3 — Geographic opportunity
SELECT
    Location,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY Location
HAVING COUNT(*) >= 30
ORDER BY
    avg_spend DESC,
    avg_previous_purchases DESC,
    promo_dependency ASC;
    
    #Q4 — Category + Season.
    SELECT
    Season,
    COUNT(*) AS customers,
    ROUND(AVG(`Purchase Amount (USD)`), 2) AS avg_spend,
    ROUND(AVG(`Previous Purchases`), 2) AS avg_previous_purchases,
    ROUND(AVG(`Review Rating`), 2) AS avg_rating,
    ROUND(
        AVG(
            CASE
                WHEN `Discount Applied` = 'Yes' THEN 1
                ELSE 0
            END
        ), 2
    ) AS promo_dependency
FROM dataset
GROUP BY Season
ORDER BY avg_previous_purchases DESC;

#Final Validation + Documentation.
SELECT COUNT(*) AS total_rows
FROM dataset;
SELECT COUNT(DISTINCT `customer_id`) AS unique_customers
FROM dataset;
SELECT
    `customer_id`,
    COUNT(*) AS record_count
FROM dataset
GROUP BY `customer_id`
HAVING COUNT(*) > 1
ORDER BY record_count DESC;
SELECT	
    SUM(`Purchase Amount (USD)` IS NULL) AS missing_spend,
    SUM(`Previous Purchases` IS NULL) AS missing_previous_purchases,
    SUM(`Review Rating` IS NULL) AS missing_rating,
    SUM(`Discount Applied` IS NULL) AS missing_discount,
    SUM(Age IS NULL) AS missing_age
FROM dataset;