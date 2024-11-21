import random
import json
from faker import Faker

# Initialize the Faker object to generate random data
fake = Faker()

# Number of users to generate
num_users = 100

# Generate user data
users = []
for i in range(1, num_users + 1):
    user = {
        "UserID": i,
        "Username": fake.user_name(),
        "FirstName": fake.first_name(),
        "LastName": fake.last_name(),
        "Email": fake.email(),
        "PhoneNumber": fake.phone_number(),
        "Address": fake.address().replace("\n", " "),
        "Balance": round(random.uniform(500, 5000), 2),
        "DateJoined": fake.date_this_decade().isoformat(),  # Convert date to string
        "IsActive": random.choice([True, False]),
        "IsStaff": random.choice([True, False]),
        "IsSuperuser": random.choice([True, False]),
        "LastLogin": fake.date_this_year().isoformat()  # Convert date to string
    }
    users.append(user)

# Define the path where the JSON file will be saved
json_file_path = "user_data_100_extended.json"

# Save the user data to a JSON file
with open(json_file_path, "w") as json_file:
    json.dump(users, json_file, indent=4)

print(f"JSON file created with {num_users} users and saved as {json_file_path}")
