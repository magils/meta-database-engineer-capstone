-- Task 1
-- In this first task, Little Lemon need you to create a procedure that displays the maximum ordered quantity in the Orders table. 
-- Creating this procedure will allow
-- Little Lemon to reuse the logic implemented in the procedure easily without retyping the same code over again and again to check the maximum quantity. 

delimiter //
create procedure GetMaxQuantity()
begin
	select max(d.quantity) as 'Max Quantity In Order'
	from orders o
	join order_detail d
	on d.order_id = o.order_id;
end //
delimiter ;

call GetMaxQuantity2();

-- Task 2
-- In the second task, Little Lemon need you to help them to create a prepared statement called GetOrderDetail.
-- This prepared statement will help to reduce the parsing time of queries. It will also help to secure the database from SQL injections.
-- The prepared statement should accept one input argument, the CustomerID value, from a variable. 
-- The statement should return the order id, the quantity and the order cost from the Orders table. 
-- Once you create the prepared statement, you can create a variable called id and assign it value of 1. 

prepare GetOrderDetail from 'select order_id, sum(quantity) as Quantity, sum(cost) as Cost from order_detail where order_id = ? group by order_id';

SET @ID = 30;
EXECUTE GetOrderDetail USING @id;


-- Task 3
-- Your third and final task is to create a stored procedure called CancelOrder.
-- Little Lemon want to use this stored procedure to delete an order record based on the user input of the order id.
-- Creating this procedure will allow Little Lemon to cancel any order by specifying the order id
-- value in the procedure parameter without typing the entire SQL delete statement.   

delimiter //
create procedure CancelOrder(in _order_id int)
begin
	delete from order_detail where order_id=_order_id;
	delete from order_status where order_id=_order_id;
	delete from orders where order_id=_order_id;
	select concat('Order ', _order_id, ' is cancelled') as Confirmation;
end//
delimiter ;


