## Coursera Meta Database Engineer Capstone

This is repo contains the solution for Meta Data Engineer Engineer Capstone project.

## IMPORTANT

Some of excercises contain minor additions like `Exercise: Create SQL queries to check available bookings based on user input` task 3 where `AddValidBooking` contains an extra argument for the amount of people. This does not affect the output of the excercises and the desired result.

The content is divided by weeks:

### Week 1

Contains the following:

- Little lemon DB SQL schema.
- Little Lemon DB ER Diagram
- Little Lemon DB MySQL Workbench file.


### Week 2:

Contains the following:

- Solution to `Exercise: Create a virtual table to summarize data`.
- Solution to `Exercise: Create optimized queries to manage and analyze data`
- Solution to `Exercise: Create SQL queries to add and update bookings`
- Solution to `Exercise: Create SQL queries to check available bookings based on user input`
- Screenshots of the solutions of each of the excercises.

### Week 3: 

Contains the following:

- Jupyter notebook solution for `Exercise: Add query functions`.
- Tableu data visualization.

### Extras:

Contains a docker compose MySQL database for testing and Python script for populating sample data.

For running these follow these instructions:

- Open your terminal and go to `extras` folder.
- Execute this command `docker-compose up -d`. This command will spin up a MySQL database on port `3300` with user `root`, password `Test100`, and database `little_lemon`.
- Run the python script: `python little_lemon_db_data.py`. It will populate all tables on the DB, except `booking`.
- If you need to change the script connection, modify the `db_connection.json`.