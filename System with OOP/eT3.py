from datetime import datetime
import openpyxl
from openpyxl import Workbook


class eT3Cash:
    def __init__(self, customer_id, balance=0.0, pin="1234", excel_file="et3cash_customers.xlsx"):
        self.customer_id = customer_id
        self.balance = balance
        self.pin = pin
        self.excel_file = excel_file
        self.savings_balance = 0.0  # Track savings balance separately
        self.transaction_history = []
        self._initialize_excel()

    def _initialize_excel(self):
        try:
            self.wb = openpyxl.load_workbook(self.excel_file)
            self.ws = self.wb.active
        except FileNotFoundError:
            self.wb = Workbook()
            self.ws = self.wb.active
            self.ws.title = "Customer Transactions"
            self.ws.append(["Customer ID", "Date", "Transaction Type", "Amount", "Details"])
            self.wb.save(self.excel_file)

    def _save_to_excel(self, transaction_type, amount, details=""):
        current_date = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        self.ws.append([self.customer_id, current_date, transaction_type, amount, details])
        self.wb.save(self.excel_file)

    """
    Depositing Money:
    At Stores: You can deposit money into your  Cash account by visiting any  store.
    ATM Deposit: You can deposit money into your account using select ATMs (linked to specific banks).
    """

    def deposit(self, amount):
        if amount > 0:
            self.balance += amount
            self.transaction_history.append(f"Deposited: {amount}")
            self._save_to_excel("Deposit", amount)
            return f"Deposited {amount} successfully."
        return "Invalid deposit amount."

    """
    Withdrawing Money: 
    At Stores: You can withdraw money from your Cash account at any store. 
    ATM Withdrawal: You can withdraw cash from your Cash account using ATMs of selected banks.
    """

    def withdraw(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.transaction_history.append(f"Withdrew: {amount}")
            self._save_to_excel("Withdrawal", amount)
            return f"Withdrew {amount} successfully."
        return "Insufficient balance or invalid amount."

    """
    Sending Money:
    Send to Another Cash User: You can transfer money to other Cash users instantly by using their phone numbers.
    Send to Non- Users: You can send money to non- Cash users who can withdraw it using a code sent via SMS.
    """

    def send_money(self, amount, recipient_number):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.transaction_history.append(f"Sent {amount} to {recipient_number}")
            self._save_to_excel("Send Money", amount, f"Recipient: {recipient_number}")
            return f"Sent {amount} to {recipient_number} successfully."
        return "Insufficient balance or invalid amount."

    """
    Paying Bills:
    Utility Bills: You can pay utility bills (electricity, water, gas) through  Cash.
    Internet and TV Subscriptions: You can pay for your home internet, TV subscriptions, and other services.
    Mobile Recharge: Recharge your own or someone else's  prepaid line.
    Purchasing Goods and Services:
    In-Store Payments: You can pay at participating stores directly using Cash by scanning a (QR code).
    E-commerce Payments: Pay for items purchased online using  Cash.
    """

    def pay_bill(self, bill_type, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.transaction_history.append(f"Paid {amount} for {bill_type}")
            self._save_to_excel("Pay Bill", amount, f"Bill Type: {bill_type}")
            return f"Paid {amount} for {bill_type} successfully."
        return "Insufficient balance or invalid amount."

    """
    Online Shopping:
    Virtual Credit Card: You can create a virtual credit card for online shopping, which is valid for 24 hours or until you use it.
    Direct Online Payments: Pay for goods and services directly using  Cash on supported websites.

    """

    def create_virtual_card(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.transaction_history.append(f"Virtual card created with {amount}")
            self._save_to_excel("Virtual Card", amount)
            return f"Virtual card created with {amount} successfully."
        return "Insufficient balance or invalid amount."

    """
    Checking Balance:
    USSD Code: Check your Cash balance using the USSD code *9#.
    Cash App: You can also check your balance via the Cash mobile app.
    """

    def check_balance(self):
        return f"Your current balance is: {self.balance}"

    """
    Transaction History:
    USSD Code: View your recent transaction history using the USSD code
    Cash App: Access detailed transaction history via the app.
    """

    def view_transaction_history(self):
        if self.transaction_history:
            return "\n".join(self.transaction_history)
        return "No transactions available."

    """
    Changing PIN:
    USSD Code: Change your Vodafone Cash PIN using a USSD code to secure your account.
    """
    def change_pin(self, old_pin, new_pin):
        if old_pin == self.pin:
            self.pin = new_pin
            self.transaction_history.append(f"PIN changed successfully")
            self._save_to_excel("Change PIN", 0, "PIN changed successfully")
            return "PIN changed successfully."
        return "Incorrect old PIN."

    """
    Donations:
    Charity Donations: Donate to various charities and NGOs directly through Vodafone Cash.
    """

    def donate(self, amount, charity_name):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.transaction_history.append(f"Donated {amount} to {charity_name}")
            self._save_to_excel("Donation", amount, f"Charity: {charity_name}")
            return f"Donated {amount} to {charity_name} successfully."
        return "Insufficient balance or invalid amount."

    """
    Saving Money:
    Savings Account: Some Cash services offer a saving account feature where users can save and earn interest.
    """

    def create_savings_account(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.savings_balance += amount
            self.transaction_history.append(f"Savings account created with {amount}")
            self._save_to_excel("Create Savings", amount, "Savings account created")
            return f"Savings account created with {amount} successfully."
        return "Insufficient balance or invalid amount."

    def withdraw_savings(self, amount):
        if 0 < amount <= self.savings_balance:
            self.savings_balance -= amount
            self.balance += amount
            self.transaction_history.append(f"Withdrew {amount} from savings")
            self._save_to_excel("Withdraw Savings", amount, "Savings account withdrawal")
            return f"Withdrew {amount} from savings successfully."
        return "Insufficient savings balance or invalid amount."

    def check_savings_balance(self):
        return f"Savings account balance is: {self.savings_balance}"

    @staticmethod
    def Customer_Service():
        print("Customer Service Options:")
        print("1. Call Center: Contact Cash customer service for assistance with any issues.")
        print("   Phone Number: 888 (for Cash users) or 010-0888-888 (for other networks).")
        print("2. Cash Stores: Visit your nearest  store for in-person support.")
        print("   Store Locator: Visit the  website to find the closest store.")


"""django-admin startproject eT3cash_project
Script to Generate Data for 50 Customers with Unique IDs
"""
# customers = []
# for i in range(1, 51):
#     unique_id = f"CUST{i:03}"
#     balance = random.uniform(500, 10000)
#     customer = eT3Cash(customer_id=unique_id, balance=balance)
#     customers.append(customer)
#
#     # Simulate transactions for each customer
#     print(customer.deposit(random.uniform(100, 1000)))
#     print(customer.withdraw(random.uniform(50, 500)))
#     print(customer.send_money(random.uniform(50, 300), f"RECIPIENT{i:03}"))
#     print(customer.pay_bill("Electricity", random.uniform(30, 200)))
#     print(customer.create_virtual_card(random.uniform(100, 500)))
#     print(customer.donate(random.uniform(10, 100), "Charity ABC"))
#
# print("Data for 50 customers has been generated and saved in 'et3cash_customers.xlsx'.")

# Example Usage
et3cash = eT3Cash(customer_id="CUST101", balance=1000.0)
print("My Balance is ", et3cash.balance)
print(et3cash.deposit(500))
print("My Balance is ", et3cash.balance)
print(et3cash.withdraw(200))
print("My Balance is ", et3cash.balance)
print(et3cash.send_money(100, "0123456789"))
print("My Balance is ", et3cash.balance)
print(et3cash.pay_bill("Electricity", 150))
print(et3cash.create_virtual_card(300))
print(et3cash.check_balance())
print("######################################################################")
print("View transaction history")
print(et3cash.view_transaction_history())
print("######################################################################")
print(et3cash.change_pin("1234", "5678"))
print(et3cash.donate(50, "Charity ABC"))
print(et3cash.create_savings_account(200))
print(et3cash.withdraw_savings(100))
print(et3cash.check_savings_balance())
print(et3cash.check_balance())
print("######################################################################")
print("View transaction history again ")
print(et3cash.view_transaction_history())
print("######################################################################")
eT3Cash.Customer_Service()
print("######################################################################")
print("Created By Honda ❤❤😎")