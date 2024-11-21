# accounts/models.py

from django.contrib.auth.models import AbstractUser
from django.db import models
from django.utils import timezone
import json
from django.contrib.auth.hashers import make_password, check_password


class CustomUser(AbstractUser):

    customer_id = models.AutoField(primary_key=True)
    balance = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    savings_balance = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    pin = models.CharField(max_length=4)
    transaction_history = models.JSONField(default=list)  # Store transaction history

    def __str__(self):
        return f"{self.username} (ID: {self.customer_id})"

    def _update_transaction_history(self, action, amount, details=""):
        """Helper method to update transaction history."""
        # Load current transaction history
        history = self.transaction_history or []
        # Append new transaction
        history.append({
            "action": action,
            "amount": str(amount),
            "details": details,
            "timestamp": timezone.now().isoformat()
        })
        # Save updated transaction history
        self.transaction_history = history
        self.save()

    def deposit(self, amount):
        if amount > 0:
            self.balance += amount
            self._update_transaction_history("Deposit", amount)
            return f"Deposited {amount} successfully."
        return "Invalid deposit amount."

    def get_balance(self):
        # Logic to return the user's balance
        return self.balance

    def withdraw(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self._update_transaction_history("Withdrawal", amount)
            return f"Withdrew {amount} successfully."
        return "Insufficient balance or invalid amount."

    def send_money(self, amount, recipient_number):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self._update_transaction_history("Send Money", amount, f"Recipient: {recipient_number}")
            return f"Sent {amount} to {recipient_number} successfully."
        return "Insufficient balance or invalid amount."

    def pay_bill(self, bill_type, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self._update_transaction_history("Pay Bill", amount, f"Bill Type: {bill_type}")
            return f"Paid {amount} for {bill_type} successfully."
        return "Insufficient balance or invalid amount."

    def create_virtual_cad(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self._update_virtual_cad_history("Virtual Card", amount)
            return f"Virtual card created with {amount} successfully."
        return "Insufficient balance or invalid amount."

    def _update_virtual_cad_history(self, transaction_type, amount):
        Transaction.objects.create(
            user=self,
            transaction_type=transaction_type,
            amount=amount,
            details=f"Created virtual card for {amount}."
        )

    def check_balance(self):
        return f"Your current balance is: {self.balance}"

    def view_transaction_history(self):
        if self.transaction_history:
            return json.dumps(self.transaction_history, indent=2)
        return "No transactions available."

    def set_pin(self, new_pin):
        self.pin = make_password(new_pin)  # Hash the new PIN before saving
        self.save()  # Save changes t

    def verify_pin(self, input_pin):
        return check_password(input_pin, self.pin)  # Use hashed comparison

    def change_pin(self, old_pin, new_pin):
        print(f"Stored PIN (hashed): {self.pin}")  # Output stored hashed PIN
        print(f"Input Old PIN: {old_pin}")  # Output input old PIN
        message = "Incorrect old PIN."  # Initialize the message variable

        if self.verify_pin(old_pin):
            self.set_pin(new_pin)
            self._update_transaction_history("Change PIN", 0, "PIN changed successfully")
            message = "PIN changed successfully."
            print(f"New PIN (hashed): {self.pin}")  # Output new hashed PIN for verification
        else:
            print("Old PIN verification failed.")

        return message

    def donate(self, amount, charity_name):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self._update_transaction_history("Donation", amount, f"Charity: {charity_name}")
            return f"Donated {amount} to {charity_name} successfully."
        return "Insufficient balance or invalid amount."

    def create_savings_account(self, amount):
        if 0 < amount <= self.balance:
            self.balance -= amount
            self.savings_balance += amount
            self._update_transaction_history("Create Savings", amount, "Savings account created")
            return f"Savings account created with {amount} successfully."
        return "Insufficient balance or invalid amount."

    def withdraw_savings(self, amount):
        if 0 < amount <= self.savings_balance:
            self.savings_balance -= amount
            self.balance += amount
            self._update_transaction_history("Withdraw Savings", amount, "Savings account withdrawal")
            return f"Withdrew {amount} from savings successfully."
        return "Insufficient savings balance or invalid amount."

    def check_savings_balance(self):
        return f"Savings account balance is: {self.savings_balance}"

    @staticmethod
    def Customer_Service():
        print("Customer Service Options:")
        print("1. Call Center: Contact Cash customer service for assistance with any issues.")
        print("   Phone Number: 888 (for Cash users) or 010-0888-888 (for other networks).")
        print("2. Cash Stores: Visit your nearest store for in-person support.")
        print("   Store Locator: Visit the website to find the closest store.")


class Transaction(models.Model):
    objects = None
    TRANSACTION_TYPES = [
        ('Deposit', 'Deposit'),
        ('Withdrawal', 'Withdrawal'),
        ('Send Money', 'Send Money'),
        ('Bill Payment', 'Bill Payment'),
        ('Virtual Card', 'Virtual Card'),
        ('Savings Account', 'Savings Account'),
        ('Withdraw Savings', 'Withdraw Savings'),
    ]
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='transactions')
    transaction_type = models.CharField(max_length=20, choices=TRANSACTION_TYPES)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    date = models.DateTimeField(default=timezone.now)
    details = models.TextField()

    def __str__(self):
        return f"{self.transaction_type} - {self.amount} by {self.user.__str__()}"


class VirtualCard(models.Model):
    objects=None
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='virtual_cards')
    card_name = models.CharField(max_length=100)
    limit = models.DecimalField(max_digits=10, decimal_places=2)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.card_name} - {self.limit} by {self.user.__str__()}"


class FileUpload(models.Model):
    uploaded_file = models.FileField(upload_to='uploads/')  # Store files in the 'uploads/' directory
    file_type = models.CharField(max_length=50, choices=[('csv', 'CSV'), ('json', 'JSON'), ('sql', 'SQL')])
    uploaded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.uploaded_file.name} - {self.file_type}"