-- Task 1
-- In the first task, Little Lemon need you to create a virtual table called OrdersView that focuses on OrderID, Quantity and Cost columns within the Orders table for all orders with a quantity greater than 2. 
-- Here’s some guidance around completing this task: 
-- Use a CREATE VIEW statement.
-- Extract the order id, quantity and cost data from the Orders table.
-- Filter data from the orders table based on orders with a quantity greater than 2. 

create view OrdersView as  
select o.order_id as OrderID, sum(d.quantity) as Quantity, sum(d.cost) as Cost
from orders as o 
join order_detail as d 
on o.order_id = d.order_id
group by o.order_id
having sum(d.quantity) > 2;

-- Task 2
-- For your second task, Little Lemon need information from four tables on all customers with orders that cost more than $150. Extract the required information from each of the following tables by using the relevant JOIN clause: 
-- Customers table: The customer id and full name.
-- Orders table: The order id and cost.
-- Menus table: The menus name.
-- MenusItems table: course name and starter name.
-- The result set should be sorted by the lowest cost amount.

select c.customer_id, c.name, o.order_id, sum(d.cost) as order_cost, m.menu_name, i.name as course_name
from orders o
join order_detail d
on d.order_id = o.order_id
join customer c
on c.customer_id = o.customer_id
join menu_item i
on i.menu_item_id = d.menu_item_id
join menu m
on m.menu_id = i.menu_id
group by o.order_id, i.name, m.menu_name
having sum(d.cost) > 150
order by order_cost;

-- Task 3
-- For the third and final task, Little Lemon need you to find all menu items for which more than 2 orders have been placed. You can carry out this task by creating a subquery that lists the menu names from the menus table for any order quantity with more than 2.
-- Here’s some guidance around completing this task: 
-- Use the ANY operator in a subquery
-- The outer query should be used to select the menu name from the menus table.
-- The inner query should check if any item quantity in the order table is more than 2. 

select menu_name
from menu
where menu_id = any(  
	select mi.menu_id  
	from orders o 
	join order_detail od 
	on od.order_id = o.order_id 
	join menu_item mi 
	on od.menu_item_id = mi.menu_item_id 
	where od.quantity > 2
);