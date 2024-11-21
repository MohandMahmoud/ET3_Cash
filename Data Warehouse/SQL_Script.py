import random
import faker


def create_sql_file(file_name, num_users=100):
    """
    Creates an SQL file with a table creation, insertion of data for `num_users` users with detailed information,
    and a select query.

    Args:
        file_name (str): The name of the SQL file to create.
        num_users (int): The number of users to generate.
    """
    fake = faker.Faker()

    try:
        # Start building the SQL file
        sql_statements = """
        -- Create table for user data
        CREATE TABLE IF NOT EXISTS DimUser (
            UserID SERIAL PRIMARY KEY,
            Username VARCHAR(100) NOT NULL,
            FirstName VARCHAR(100),
            LastName VARCHAR(100),
            Email VARCHAR(100) NOT NULL,
            PhoneNumber VARCHAR(15),
            Address TEXT,
            Balance DECIMAL(10, 2),
            DateJoined DATE,
            IsActive BOOLEAN,
            IsStaff BOOLEAN,
            IsSuperuser BOOLEAN,
            LastLogin DATE
        );

        -- Insert sample data into DimUser table
        """

        # Generate INSERT statements for the specified number of users
        insert_statements = []
        for i in range(1, num_users + 1):
            username = fake.user_name()
            first_name = fake.first_name()
            last_name = fake.last_name()
            email = fake.email()
            phone_number = fake.phone_number()
            address = fake.address().replace("\n", " ")  # Remove line breaks in address
            balance = round(random.uniform(500, 5000), 2)
            date_joined = fake.date_this_decade().isoformat()  # Convert date to string
            is_active = random.choice([True, False])
            is_staff = random.choice([True, False])
            is_superuser = random.choice([True, False])
            last_login = fake.date_this_year().isoformat()  # Convert date to string

            insert_statements.append(f"    ({i}, '{username}', '{first_name}', '{last_name}', '{email}', "
                                     f"'{phone_number}', '{address}', {balance}, '{date_joined}', {is_active}, "
                                     f"{is_staff}, {is_superuser}, '{last_login}')")

        # Join the insert statements into a single string
        sql_statements += ",\n".join(insert_statements) + ";\n\n"

        # Add the select query
        sql_statements += """
        -- Select query to check the data
        SELECT * FROM DimUser;
        """

        # Write the SQL statements to the file
        with open(file_name, 'w') as file:
            file.write(sql_statements)

        print(f"SQL file '{file_name}' created successfully with {num_users} users.")

    except Exception as e:
        print(f"Error creating SQL file: {e}")


# Usage
create_sql_file("users.sql", num_users=100)
