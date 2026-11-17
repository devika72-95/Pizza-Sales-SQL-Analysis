/*
Pizza Sales Analysis | PostgreSQL
Approved questions: 32
Excluded: original Q20 (Price Classification), original Q29 (NULL Handling),
and the earlier question removed because it returned NULL.
Schema: pizza_types, pizzas, orders, order_details, discount_structure
*/

-- Q01. Total number of orders
SELECT COUNT(DISTINCT order_id) AS total_orders FROM orders;

-- Q02. Total pizzas sold
SELECT SUM(quantity) AS total_pizzas_sold FROM order_details;

-- Q03. Total gross revenue
SELECT SUM(od.quantity * p.price) AS total_gross_revenue
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Q04. Average order value (gross revenue / distinct orders)
SELECT ROUND(SUM(od.quantity * p.price) / COUNT(DISTINCT od.order_id), 2) AS average_order_value
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Q05. Gross revenue by category
SELECT pt.category, SUM(od.quantity * p.price) AS gross_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category ORDER BY gross_revenue DESC;

-- Q06. Quantity sold by pizza size
SELECT p.size, SUM(od.quantity) AS total_quantity_sold
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size ORDER BY total_quantity_sold DESC;

-- Q07. Top 5 best-selling pizza types
SELECT pt.name AS pizza_name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name ORDER BY total_quantity_sold DESC LIMIT 5;

-- Q08. Top 5 pizza types by gross revenue
SELECT pt.name AS pizza_name, SUM(od.quantity * p.price) AS gross_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name ORDER BY gross_revenue DESC LIMIT 5;

-- Q09. Monthly gross revenue
SELECT EXTRACT(MONTH FROM o.order_date)::INT AS month_number,
       TO_CHAR(o.order_date, 'Month') AS month_name,
       SUM(od.quantity * p.price) AS gross_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY EXTRACT(MONTH FROM o.order_date), TO_CHAR(o.order_date, 'Month')
ORDER BY month_number;

-- Q10. Gross revenue by weekday
SELECT TO_CHAR(o.order_date, 'Day') AS day_name,
       SUM(od.quantity * p.price) AS gross_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY EXTRACT(ISODOW FROM o.order_date), TO_CHAR(o.order_date, 'Day')
ORDER BY EXTRACT(ISODOW FROM o.order_date);

-- Q11. Number of orders by hour
SELECT EXTRACT(HOUR FROM order_time)::INT AS order_hour,
       COUNT(DISTINCT order_id) AS total_orders
FROM orders
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY order_hour;

-- Q12. Quantity sold by pizza category
SELECT pt.category, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category ORDER BY total_quantity_sold DESC;

-- Q13. Bottom 5 pizza types by quantity sold
SELECT pt.name AS pizza_name, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name ORDER BY total_quantity_sold ASC LIMIT 5;

-- Q14. Top 5 pizza types by gross profit (revenue less product cost)
SELECT pt.name AS pizza_name,
       SUM(od.quantity * (p.price - p.cost)) AS gross_profit
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name ORDER BY gross_profit DESC LIMIT 5;

-- Q15. Overall gross profit margin percentage
SELECT ROUND(100.0 * SUM(od.quantity * (p.price - p.cost))
             / NULLIF(SUM(od.quantity * p.price), 0), 2) AS gross_profit_margin_percentage
FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Q16. Total discount amount
SELECT ROUND(SUM(od.quantity * p.price
                 * COALESCE(ds.discount_percentage, 0) / 100.0), 2) AS total_discount_amount
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
LEFT JOIN discount_structure ds ON od.discount_id = ds.discount_id;

-- Q17. Net revenue after discounts
SELECT ROUND(SUM(od.quantity * p.price
                 * (1 - COALESCE(ds.discount_percentage, 0) / 100.0)), 2) AS net_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
LEFT JOIN discount_structure ds ON od.discount_id = ds.discount_id;

-- Q18. Net profit after discounts and product cost
SELECT ROUND(SUM(od.quantity * p.price
                 * (1 - COALESCE(ds.discount_percentage, 0) / 100.0)
                 - od.quantity * p.cost), 2) AS net_profit
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
LEFT JOIN discount_structure ds ON od.discount_id = ds.discount_id;

-- Q19. Number of orders containing more than one distinct pizza type
SELECT COUNT(*) AS orders_with_multiple_pizza_types
FROM (
    SELECT od.order_id
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
    HAVING COUNT(DISTINCT p.pizza_type_id) > 1
) multi_type_orders;

-- Q21. Pizzas priced above the average pizza price
SELECT pizza_id, pizza_type_id, size, price
FROM pizzas
WHERE price > (SELECT AVG(price) FROM pizzas)
ORDER BY price DESC;

-- Q22. Pizza types with more than 100 units sold (CTE)
WITH pizza_sales AS (
    SELECT p.pizza_type_id, SUM(od.quantity) AS total_quantity_sold
    FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY p.pizza_type_id
)
SELECT pt.name AS pizza_name, ps.total_quantity_sold
FROM pizza_sales ps
JOIN pizza_types pt ON ps.pizza_type_id = pt.pizza_type_id
WHERE ps.total_quantity_sold > 100
ORDER BY ps.total_quantity_sold DESC;

-- Q23. ROW_NUMBER ranking of sizes within each pizza type by price
SELECT pizza_type_id, size, price,
       ROW_NUMBER() OVER (PARTITION BY pizza_type_id ORDER BY price DESC) AS row_number
FROM pizzas
ORDER BY pizza_type_id, row_number;

-- Q24. RANK pizzas by price
SELECT pizza_id, pizza_type_id, size, price,
       RANK() OVER (ORDER BY price DESC) AS price_rank
FROM pizzas
ORDER BY price_rank, pizza_id;

-- Q25. DENSE_RANK pizzas by price
SELECT pizza_id, pizza_type_id, size, price,
       DENSE_RANK() OVER (ORDER BY price DESC) AS dense_price_rank
FROM pizzas
ORDER BY dense_price_rank, pizza_id;

-- Q26. Quantity sold by pizza type and size, with type total using PARTITION BY
SELECT pt.name AS pizza_name, p.size,
       SUM(od.quantity) AS quantity_sold,
       SUM(SUM(od.quantity)) OVER (PARTITION BY pt.name) AS total_quantity_for_pizza_type
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.size
ORDER BY pt.name, p.size;

-- Q27. Monthly revenue and previous-month revenue using LAG
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', o.order_date)::DATE AS month_start,
           SUM(od.quantity * p.price) AS gross_revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT month_start, gross_revenue,
       LAG(gross_revenue) OVER (ORDER BY month_start) AS previous_month_revenue,
       gross_revenue - LAG(gross_revenue) OVER (ORDER BY month_start) AS revenue_change
FROM monthly_revenue
ORDER BY month_start;

-- Q28. UNION ALL: top 5 best-selling and top 5 revenue-generating pizza types
WITH pizza_metrics AS (
    SELECT pt.name AS pizza_name,
           SUM(od.quantity) AS total_quantity_sold,
           SUM(od.quantity * p.price) AS gross_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
),
top_sellers AS (
    SELECT 'Top 5 Best-Selling'::TEXT AS metric_group,
           pizza_name, total_quantity_sold::NUMERIC AS metric_value
    FROM pizza_metrics ORDER BY total_quantity_sold DESC LIMIT 5
),
top_revenue AS (
    SELECT 'Top 5 Revenue'::TEXT AS metric_group,
           pizza_name, gross_revenue::NUMERIC AS metric_value
    FROM pizza_metrics ORDER BY gross_revenue DESC LIMIT 5
)
SELECT metric_group, pizza_name, metric_value FROM top_sellers
UNION ALL
SELECT metric_group, pizza_name, metric_value FROM top_revenue
ORDER BY metric_group, metric_value DESC;

-- Q30. Pizza types with sales quantity above the average across pizza types (correlated subquery)
SELECT pt.name AS pizza_name, SUM(od.quantity) AS total_quantity_sold
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.pizza_type_id, pt.name
HAVING SUM(od.quantity) > (
    SELECT AVG(type_quantity)
    FROM (
        SELECT SUM(od2.quantity) AS type_quantity
        FROM pizzas p2
        JOIN order_details od2 ON p2.pizza_id = od2.pizza_id
        WHERE p2.pizza_type_id = pt.pizza_type_id
        GROUP BY p2.pizza_type_id
    ) correlated_sales
)
ORDER BY total_quantity_sold DESC;

-- Q31. Monthly revenue running total
WITH monthly_revenue AS (
    SELECT DATE_TRUNC('month', o.order_date)::DATE AS month_start,
           SUM(od.quantity * p.price) AS gross_revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY DATE_TRUNC('month', o.order_date)
)
SELECT month_start, gross_revenue,
       SUM(gross_revenue) OVER (
           ORDER BY month_start
           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_revenue
FROM monthly_revenue
ORDER BY month_start;

-- Q32. Percentage contribution of each pizza type to total gross revenue
WITH pizza_revenue AS (
    SELECT pt.name AS pizza_name, SUM(od.quantity * p.price) AS gross_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.name
)
SELECT pizza_name, gross_revenue,
       ROUND(100.0 * gross_revenue / NULLIF(SUM(gross_revenue) OVER (), 0), 2)
           AS revenue_contribution_percentage
FROM pizza_revenue
ORDER BY gross_revenue DESC;

-- Q33. Pizza types that have at least one matching order detail (EXISTS)
SELECT pt.pizza_type_id, pt.name AS pizza_name, pt.category
FROM pizza_types pt
WHERE EXISTS (
    SELECT 1
    FROM pizzas p
    JOIN order_details od ON p.pizza_id = od.pizza_id
    WHERE p.pizza_type_id = pt.pizza_type_id
)
ORDER BY pt.name;

-- Q34. Create and query a pizza sales summary view
CREATE OR REPLACE VIEW pizza_sales_summary AS
SELECT pt.pizza_type_id, pt.name AS pizza_name, pt.category,
       SUM(od.quantity) AS total_quantity_sold,
       SUM(od.quantity * p.price) AS gross_revenue,
       SUM(od.quantity * (p.price - p.cost)) AS gross_profit
FROM pizza_types pt
JOIN pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN order_details od ON p.pizza_id = od.pizza_id
GROUP BY pt.pizza_type_id, pt.name, pt.category;

SELECT * FROM pizza_sales_summary ORDER BY gross_revenue DESC;
