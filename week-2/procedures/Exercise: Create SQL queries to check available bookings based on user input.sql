-- Task 1
-- Little Lemon wants to populate the Bookings table of their database with some records of data.
-- Your first task is to replicate the list of records in the following table by adding them to the Little Lemon booking table. 
-- You can use simple INSERT statements to complete this task.
begin 
    insert into booking(table_number, people_quantity, customer_id) values (1, 5, 126), (2, 3, 127), (3, 2, 128), (4, 2, 129), (5, 3, 130);
commit;

-- Task 2
-- For your second task, Little Lemon need you to create a stored procedure called CheckBooking to check whether a table in the restaurant is already booked.
-- Creating this procedure helps to minimize the effort involved in repeatedly coding the same SQL statements.
-- The procedure should have two input parameters in the form of booking date and table number. 
-- You can also create a variable in the procedure to check the status of each table.

delimiter //
create procedure CheckBooking(in _table_number int, in _date varchar(255))
begin
	select case when count(*) > 0 then concat('Table ', _table_number, ' is booked already') else concat('Table ', _table_number, ' is available') end as 'Booking Status'
	from booking
	where table_number = _table_number and date(resevertation_date)  = _date;
end //
delimiter ;


-- Task 3
-- For your third and final task, Little Lemon need to verify a booking, and decline any reservations for tables that are already booked under another name. 
-- Since integrity is not optional, Little Lemon need to ensure that every booking attempt includes these verification and decline steps. However, implementing these steps requires a stored procedure and a transaction. 
-- To implement these steps, you need to create a new procedure called AddValidBooking. This procedure must use a transaction statement to perform a rollback if a customer reserves a table that’s already booked under another name.  

-- Use the following guidelines to complete this task:
-- The procedure should include two input parameters in the form of booking date and table number.
-- It also requires at least one variable and should begin with a START TRANSACTION statement.
-- Your INSERT statement must add a new booking record using the input parameter's values.

-- Use an IF ELSE statement to check if a table is already booked on the given date. 
-- If the table is already booked, then rollback the transaction. If the table is available, then commit the transaction. 
-- The screenshot below is an example of a rollback (cancelled booking), which was enacted because table number 5 is already booked on the specified date.

delimiter //
create procedure AddValidBooking(in _table_number int, in _date varchar(255), in _customer_name varchar(255), _customer_last_name varchar(255), in _people_quantity int)
begin
	declare booking_count int;

	start transaction;
	
	select count(*) into booking_count 
	from booking b 
    join customer c 
    on b.customer_id = c.customer_id 
    where table_number = _table_number and date(resevertation_date) = _date and c.name = _customer_name and c.last_name = _customer_last_name;

	if booking_count > 0 then
		select concat('Table ', _table_number, ' is reserved already') as 'Booking Status';
		rollback;
	else
		insert into booking(table_number, resevertation_date, people_quantity, customer_id)
		select _table_number, _date, _people_quantity, customer_id  from customer c where c.name = _customer_name and c.last_name = _customer_last_name;
		commit;
	end if;

end//
delimiter ;