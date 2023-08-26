-- Task 1
-- In this first task you need to create a new procedure called AddBooking to add a new table booking record.
-- The procedure should include four input parameters in the form of the following bookings parameters:
-- booking id,  customer id,  booking date, and table number.

delimiter //
create procedure AddBooking(in _booking_id int, in _customer_id int , in _booking_date varchar(255), in _table_number int, in _people_quantity int)
begin	
		insert into booking(booking_id, table_number, resevertation_date, people_quantity, customer_id)
		values (_booking_id, _table_number, date(_booking_date), _people_quantity, _customer_id);
		select 'New booking added' as 'Confirmation';
end //
delimiter ;

-- Task 2
-- For your second task, Little Lemon need you to create a new procedure called UpdateBooking that they can use to update existing bookings in the booking table.
-- The procedure should have two input parameters in the form of booking id and booking date. You must also include an UPDATE statement inside the procedure. 

delimiter //
create procedure UpdateBooking(in _booking_id int , in _booking_date varchar(255))
begin
	update booking set resevertation_date = date(_booking_date) where booking_id = _booking_id;
	select concat('Booking ', _booking_id, ' updated') as 'Confirmation';
end //
delimiter ;

-- Task 3
-- For the third and final task, Little Lemon need you to create a new procedure called CancelBooking that they can use to cancel or remove a booking.
-- The procedure should have one input parameter in the form of booking id. You must also write a DELETE statement inside the procedure.

delimiter //
create procedure CancelBooking(in _booking_id int)
begin
	delete from booking where booking_id = _booking_id;
	select concat('Booking ', _booking_id, ' cancelled') as 'Confirmation';
end //
delimiter ;