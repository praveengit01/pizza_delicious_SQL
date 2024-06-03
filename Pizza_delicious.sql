use pizza_delicious;

-- Retrieve the total number of orders placed.

select count(orders.order_id) as Total_orders
from orders;


-- Calculate the total revenue generated from pizza sales.

select round(sum(p.price * od.quantity), 2) as Total_Reveue
from pizzas p
join order_details od on p.pizza_id = od.pizza_id;



-- Identify the highest-priced pizza.

select pt.name as Name, p.price as Price
from pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
order by Price desc limit 1;


-- Identify the most common pizza size ordered.

select p.size as Size, count(od.order_details_id) as Pizza_Count
from pizzas p
join order_details od on p.pizza_id = od.pizza_id
group by Size
order by Pizza_count desc;


-- List the top 5 most ordered pizza types along with their quantities.

select pt.name as Pizza, sum(od.quantity) as Quantity
from pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pizza
order by quantity desc limit 5;


-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pt.category as Pizza_Category, sum(od.quantity) as Total_quantity
from pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by Pizza_category
order by Total_quantity desc;

-- Determine the distribution of orders by hour of the day.

select hour(orders.order_time) as Hour, count(orders.order_id) as Orders_count
from orders
group by Hour;




-- Join relevant tables to find the category-wise distribution of pizzas.

select category as Pizza_Category, count(pizza_type_id) as Pizza_count
from pizza_types
group by Pizza_category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.

select round(avg(quantity),1) as Average_pizza_Ordered from
(select o.order_date as Oders_Date, sum(od.quantity) as Quantity
from orders o
join order_details od on o.order_id = od.order_id
group by oders_date) as Order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue.

select pt.name as Pizza_Type, round(sum(od.quantity * p.price),1) as Revenue
from pizza_types pt
join pizzas p on pt.pizza_type_id = p.pizza_type_id
join order_details od on p.pizza_id = od.pizza_id
group by pizza_type
order by Revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price),
                                2) AS Total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id) * 100,
            2) AS Revenue_percent
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY Revenue_percent DESC;

-- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over (order by order_date) as Cum_revenue
from
(select orders.order_date, sum(order_details.quantity * pizzas.price) as Revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.order_date) as Sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select pizza_types.name, sum((order_details.quantity) * pizzas.price) as Revenue
from pizza_types
join pizzas on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;





-- Calculate the percentage contribution of each pizza type to total revenue.

select pizza_types.category, round(sum(order_details.quantity * pizzas.price) / 
(select round(sum(order_details.quantity * pizzas.price),2) as total_sales
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id) *100,2) as revenue
from pizza_types
Join pizzas on pizza_types.pizza_type_id = pizzas.pizza_type_id
Join order_details on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;


-- Analyze the cumulative revenue generated over time.

select order_date, sum(revenue) over(order by order_date) as cum_revenue
from 
(select orders.order_date, sum(order_details.quantity * pizzas.price) as revenue
from order_details
join pizzas on order_details.pizza_id = pizzas.pizza_id
join orders on orders.order_id = order_details.order_id
group by orders.order_date) as sales;



























