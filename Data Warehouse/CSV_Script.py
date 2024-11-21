import pandas as pd
import random
from faker import Faker

# Initialize the Faker object to generate random data
fake = Faker()

# Number of users to generate
num_users = 100

# Generate user data
data = {
    "UserID": [i for i in range(1, num_users + 1)],
    "Username": [fake.user_name() for _ in range(num_users)],
    "FirstName": [fake.first_name() for _ in range(num_users)],
    "LastName": [fake.last_name() for _ in range(num_users)],
    "Email": [fake.email() for _ in range(num_users)],
    "PhoneNumber": [fake.phone_number() for _ in range(num_users)],
    "Address": [fake.address().replace("\n", " ") for _ in range(num_users)],
    "Balance": [round(random.uniform(500, 5000), 2) for _ in range(num_users)],
    "DateJoined": [fake.date_this_decade() for _ in range(num_users)],
    "IsActive": [random.choice([True, False]) for _ in range(num_users)],
    "IsStaff": [random.choice([True, False]) for _ in range(num_users)],
    "IsSuperuser": [random.choice([True, False]) for _ in range(num_users)],
    "LastLogin": [fake.date_this_year() for _ in range(num_users)],
}

# Create a DataFrame from the generated data
df = pd.DataFrame(data)

# Define the path where the CSV file will be saved
csv_file_path = "user_data_100_extended.csv"

# Save the DataFrame to a CSV file
df.to_csv(csv_file_path, index=False)

print(f"CSV file created with {num_users} users and saved as {csv_file_path}")
