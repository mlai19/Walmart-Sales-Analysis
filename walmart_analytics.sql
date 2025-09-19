SELECT * FROM walmart;

DROP TABLE walmart;
--

SELECT COUNT(*) FROM walmart;

SELECT DISTINCT payment_method FROM walmart;

SELECT payment_method, COUNT(*)
FROM walmart
GROUP BY payment_method;

SELECT COUNT(DISTINCT Branch)
FROM walmart;

-- 1. Analyze Payment Methods and Sales
-- Question: What are the different payment methods, and how many transactions and items were sold with each method?
-- Purpose: This helps understand customer preferences for payment methods, aiding in payment optimization strategies.
SELECT COUNT(*) AS transactions, SUM(quantity) AS quantity_sold
FROM walmart
GROUP BY payment_method;

-- 2. Identify the Highest-Rated Category in Each Branch
-- Question: Which category received the highest average rating in each branch?
-- Purpose: This allows Walmart to recognize and promote popular categories in specific branches, enhancing customer satisfaction and branch-specific marketing.
SELECT *
FROM
(
	SELECT branch, category, AVG(rating) AS avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank
	FROM walmart
	GROUP BY branch, category
	ORDER BY branch, avg_rating DESC
)  AS t1
WHERE rank = 1

-- 3. Determine the Busiest Day for Each Branch
-- Question: What is the busiest day of the week for each branch based on transaction volume?
-- Purpose: This insight helps in optimizing staffing and inventory management to accommodate peak days.
SELECT *
FROM
(
	SELECT branch, 
		TO_CHAR(TO_DATE(date, 'DD/MM/YY'), 'Day') AS day_name,
		COUNT(*) AS no_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC ) AS rank
	FROM walmart
	GROUP BY branch, day_name
) AS t1
WHERE rank = 1;

-- 4. Calculate Total Quantity Sold by Payment Method
-- Question: How many items were sold through each payment_method?
-- Purpose: This helps Walmart track sales volume by payment type, providing insights into customer purchasing habits

SELECT payment_method, SUM(quantity) AS items_sold
FROM walmart
GROUP BY payment_method;


-- 5. Analyze Category Ratings by City
-- Question: What are the average, minimum, and maximum ratings for each category in each city?
-- Purpose: This data can guide city-level promotions, allowing Walmart to address regional preferences and improve customer experiences.

SELECT city, category, AVG(rating), MIN(rating) AS min_rating, MAX(rating) AS max_rating
FROM walmart
GROUP BY city, category;


-- 6. Calculate Total Profit By Category
-- Question: What is the total profit for each category, ranked from highest to lowest?
-- Purpose: Identifying high profit categories helps focus efforts on expanding these products or manageing strategies effectively
SELECT category, SUM(total * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY category, total_profit DESC;


-- 7. Determine the most common payment method per branch
-- Question: What is the most frequently used payment method in each branch?
-- Purpose: This information aids in understanding branch-specific payment preferences, potentially allowing branches to streamline their payment processing
WITH ranking AS
(
	SELECT branch, payment_method, COUNT(payment_method), RANK() OVER(PARTITION BY branch ORDER BY COUNT(payment_method) DESC) AS rank
	FROM walmart
	GROUP BY branch, payment_method
	ORDER BY branch, COUNT(payment_method) DESC
)
SELECT *
FROM ranking
WHERE rank = 1

-- 8. Analyze Sales Shifts Throughout the Day
-- Question: How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?
-- Purpose: This insight helps in managing staff shifts and stock replenishment schedules, especially during high-sales periods.

SELECT
	CASE
		WHEN EXTRACT(HOUR FROM(time::time)) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM(time::time)) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS day_time,
	COUNT(*) AS no_transactions
FROM walmart 
GROUP BY day_time;

-- 9. Identify 5 Branches with Highest Revenue Decline Year-Over-Year
-- Question: Which branches experienced the largest decrease in revenue compared to the previous year? PREVIOUS YEAR = 2022
-- Purpose: Detecting branches with declining revenue is crucial for understanding possible local issues and creating strategies to boost sales or mitigate losses.

-- Revenue decrease ratio = (LY_revenue - CY_revenue / LY_revenue) * 100

WITH rev_2022 AS
(
	SELECT branch, SUM(total) AS revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2022
	GROUP BY branch
),
rev_2023 AS
(
	SELECT branch, SUM(total) AS revenue
	FROM walmart
	WHERE EXTRACT(YEAR FROM TO_DATE(date, 'DD/MM/YY')) = 2023
	GROUP BY branch
)
SELECT
	ly.branch,
	ly.revenue AS last_year_revenue,
	cy.revenue AS current_year_revenue,
	ROUND(
		(ly.revenue - cy.revenue)::numeric/ ly.revenue::numeric * 100,
		2) AS revenue_decrease_ratio
FROM rev_2022 AS ly
JOIN rev_2023 AS cy ON ly.branch = cy.branch
WHERE ly.revenue > cy.revenue
ORDER BY revenue_decrease_ratio DESC 
LIMIT 5;






