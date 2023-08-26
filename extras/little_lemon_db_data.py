from mysql.connector import connect
import json, sys
from faker import Faker
import random
from decimal import Decimal
from datetime import datetime

faker = Faker()


def clean_up(conn):
    print("Deleting all tables data...")
    with conn.cursor() as c:
        c.execute("DELETE FROM order_status")
        c.execute("DELETE FROM order_detail")
        c.execute("DELETE FROM orders")
        c.execute("DELETE FROM menu_item")
        c.execute("DELETE FROM menu")
        c.execute("DELETE FROM customer")
        c.execute("DELETE FROM staff")

    conn.commit()
    print("Data deleted successfully")


def insert_staff_data(conn, quantity=25):
    print(f"Inserting {quantity} staff members...")
    with conn.cursor() as c:
        query_statement = """
            INSERT INTO staff(NAME, LAST_NAME, STATUS, SALARY, OCCUPATION, BIRTHDATE, EMAIL, PHONE_NUMBER)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s) 
        """
        staff_ids = []
        for _ in range(0, quantity):
            first_name = faker.first_name()
            last_name = faker.last_name()
            rand_number = random.randint(0, 1000)
            email_address = (
                f"{first_name}_{last_name}{rand_number}@little_lemon.net".lower()
            )
            rand_salary = Decimal(random.randrange(9000, 20000))
            c.execute(
                query_statement,
                (
                    first_name,
                    last_name,
                    "active",
                    rand_salary,
                    faker.job(),
                    faker.date_of_birth(minimum_age=20, maximum_age=80),
                    email_address,
                    faker.phone_number(),
                )
            )
            staff_ids.append(c.lastrowid)
    print(f"Staff members inserted")

    return staff_ids


def insert_customer_data(conn, quantity=25):
    print(f"Inserting {quantity} customers...")
    with conn.cursor() as c:
        query_statement = """
            INSERT INTO customer(NAME, LAST_NAME, ADDRESS, EMAIL, PHONE_NUMBER)
            VALUES (%s, %s, %s, %s, %s) 
        """
        customer_data = []
        customer_ids = []
        for _ in range(0, quantity):
            first_name = faker.first_name()
            last_name = faker.last_name()
            rand_number = random.randint(0, 1000)
            rand_email_provider = faker.free_email_domain()
            email_address = (
                f"{first_name}_{last_name}{rand_number}@{rand_email_provider}".lower()
            )

            c.execute(query_statement,
                (
                    first_name,
                    last_name,
                    faker.address(),
                    email_address,
                    faker.phone_number(),
                 )
            )
            customer_ids.append(c.lastrowid)

    print(f"Customer inserted")
    
    return customer_ids


def insert_menu_data(db_conn):
    print(f"Inserting Menu data...")
    with db_conn.cursor() as c:
        menu_query_statement = """
            INSERT INTO menu(MENU_NAME, COUSINE)
            VALUES(%s, %s)
        """
        menu_item_query_statement = """
            INSERT INTO menu_item(NAME, TYPE, PRICE, MENU_ID)
            VALUES(%s, %s, %s, %s)
        """
        menu = {
            "dessert": [
                "Chocolate Cake",
                "Cheesecake",
                "Apple Pie",
                "Tiramisu",
                "Fruit Salad"
            ],
            "starter": [
                "Bruschetta",
                "Spinach Dip",
                "Garlic Bread",
                "Caprese Salad",
                "Chicken Wings"
            ],
            "main dish": [
                "Grilled Salmon",
                "Beef Steak",
                "Pasta Carbonara",
                "Vegetable Stir-Fry",
                "Chicken Alfredo"
            ],
            "meat": [
                "Lamb Chops",
                "Pork Ribs",
                "Turkey Burger",
                "Bacon-Wrapped Filet Mignon",
                "Sausage Platter"
            ],
            "fitness": [
                "Grilled Chicken Salad",
                "Salmon Quinoa Bowl",
                "Greek Yogurt Parfait",
                "Veggie Wrap",
                "Mixed Berry Smoothie"
            ],
            "vegetarian": [
                "Mushroom Risotto",
                "Eggplant Parmesan",
                "Vegetable Lasagna",
                "Chickpea Curry",
                "Stuffed Bell Peppers"
            ],
            "drink": [
                "Classic Mojito",
                "Mango Lassi",
                "Iced Coffee",
                "Green Tea",
                "Fresh Orange Juice"
            ]
        }

        menu_item_ids = []
        for category, items in menu.items():
            c.execute(menu_query_statement, (category.title() + " menu", category))
            menu_id = c.lastrowid

            for menu_item in items:
                rand_price = Decimal(random.randrange(10, 59)) + Decimal(0.99)
                c.execute(menu_item_query_statement, (menu_item, category, rand_price, menu_id))
                menu_item_id = c.lastrowid
                menu_item_ids.append((menu_item_id, rand_price,))

    print(f"Menu data inserted")

    return menu_item_ids


def insert_order_data(db_conn, customer_ids, menu_items, staff_ids):
    print("Inserting Order, Order details, and Order Status...")
    with db_conn.cursor() as c:
        insert_order_query_statement = """
            INSERT INTO orders(ORDER_TYPE, CUSTOMER_ID, STAFF_ID)
            VALUES (%s, %s, %s)
        """
        insert_order_item_query_statement = """
            INSERT INTO order_detail(quantity, price, cost, order_id, menu_item_id)
            VALUES (%s, %s, %s, %s, %s)
        """
        insert_order_status_query_statement = """
            INSERT INTO order_status(status, last_update_date, order_id)
            VALUES (%s, %s, %s)
        """

        for customer_id in customer_ids:
            order_type = "on-site" if random.choice([True, False]) else "on-line"
            staff_id = random.choice(staff_ids)
            c.execute(insert_order_query_statement, (order_type, customer_id, staff_id))
            order_id = c.lastrowid

            # Order Detail
            for _ in range(0, random.randint(1, 10)):
                rand_quantity = random.randint(1, 10)
                rand_menu_item = menu_items[random.randrange(0, len(menu_items))]
                menu_item_id = rand_menu_item[0]
                menu_item_price = rand_menu_item[1]
                total_cost = rand_quantity * menu_item_price

                c.execute(insert_order_item_query_statement, (rand_quantity, menu_item_price, total_cost, order_id, menu_item_id))
            
            # Add Status to the order
            rand_status = random.choice(["queued", "in-progress", "completed"])
            last_update_datetime = datetime.now()

            c.execute(insert_order_status_query_statement, (rand_status, last_update_datetime, order_id))

    print("Inserting Order, Order details, and Order Status inserted")


if __name__ == "__main__":
    if len(sys.argv) > 2:
        credential_filename = sys.argv[1]
    else:
        credential_filename = "db_connection.json"
    try:
        with open(credential_filename) as creds_file:
            db_creds = json.load(creds_file)
            db_host = db_creds["host"]
            db_port = db_creds["port"]
            db_user = db_creds["user"]
            db_password = db_creds["password"]
            db_name = db_creds["name"]

            print(
                f"Database Connection: DB Host: {db_host}, DB Port: {db_port}, DB Name: {db_name}"
            )

            with connect(
                host=db_host,
                port=db_port,
                user=db_user,
                password=db_password,
                database=db_name,
            ) as db_conn:
                clean_up(db_conn)
                staff_ids = insert_staff_data(db_conn)
                customer_ids = insert_customer_data(db_conn)
                menu_items = insert_menu_data(db_conn)
                insert_order_data(db_conn, customer_ids, menu_items, staff_ids)
                db_conn.commit()
    except KeyError as ke:
        print(f"Missing required property {ke}")
    except:
        db_conn.rollback()
