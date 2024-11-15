from django.shortcuts import render, redirect
from .models import Customer, Transaction
from .forms import (
    DepositForm, WithdrawForm, SendMoneyForm, PayBillForm, CreateVirtualCardForm,
    ChangePinForm, DonateForm, CreateSavingsAccountForm,
    WithdrawSavingsForm
)


def home(request):
    return render(request, 'transactions/home.html')


def deposit(request):
    if request.method == 'POST':
        form = DepositForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            customer.balance += amount
            customer.save()
            Transaction.objects.create(customer=customer, transaction_type='Deposit', amount=amount)
            return redirect('check_balance')
    else:
        form = DepositForm()
    return render(request, 'transactions/deposit.html', {'form': form})


def withdraw(request):
    if request.method == 'POST':
        form = WithdrawForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Withdrawal', amount=amount)
                return redirect('check_balance')
    else:
        form = WithdrawForm()
    return render(request, 'transactions/withdraw.html', {'form': form})


def send_money(request):
    if request.method == 'POST':
        form = SendMoneyForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            recipient_number = form.cleaned_data['recipient_number']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Send Money', amount=amount,
                                           details=f'Recipient: {recipient_number}')
                return redirect('check_balance')
    else:
        form = SendMoneyForm()
    return render(request, 'transactions/send_money.html', {'form': form})


def pay_bill(request):
    if request.method == 'POST':
        form = PayBillForm(request.POST)
        if form.is_valid():
            bill_type = form.cleaned_data['bill_type']
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Pay Bill', amount=amount,
                                           details=f'Bill Type: {bill_type}')
                return redirect('check_balance')
    else:
        form = PayBillForm()
    return render(request, 'transactions/pay_bill.html', {'form': form})


def create_virtual_card(request):
    if request.method == 'POST':
        form = CreateVirtualCardForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Virtual Card', amount=amount)
                return redirect('check_balance')
    else:
        form = CreateVirtualCardForm()
    return render(request, 'transactions/create_virtual_card.html', {'form': form})


def check_balance(request):
    customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
    return render(request, 'transactions/check_balance.html', {'balance': customer.balance})


def view_transaction_history(request):
    customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
    transactions = Transaction.objects.filter(customer=customer)
    return render(request, 'transactions/view_transaction_history.html', {'transactions': transactions})


def change_pin(request):
    if request.method == 'POST':
        form = ChangePinForm(request.POST)
        if form.is_valid():
            old_pin = form.cleaned_data['old_pin']
            new_pin = form.cleaned_data['new_pin']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if old_pin == customer.pin:
                customer.pin = new_pin
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Change PIN', amount=0,
                                           details='PIN changed successfully')
                return redirect('check_balance')
    else:
        form = ChangePinForm()
    return render(request, 'transactions/change_pin.html', {'form': form})


def donate(request):
    if request.method == 'POST':
        form = DonateForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            charity_name = form.cleaned_data['charity_name']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Donation', amount=amount,
                                           details=f'Charity: {charity_name}')
                return redirect('check_balance')
    else:
        form = DonateForm()
    return render(request, 'transactions/donate.html', {'form': form})


def create_savings_account(request):
    if request.method == 'POST':
        form = CreateSavingsAccountForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.balance:
                customer.balance -= amount
                customer.savings_balance += amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Create Savings Account', amount=amount,
                                           details='Savings account created')
                return redirect('check_savings_balance')
    else:
        form = CreateSavingsAccountForm()
    return render(request, 'transactions/create_savings_account.html', {'form': form})


def withdraw_savings(request):
    if request.method == 'POST':
        form = WithdrawSavingsForm(request.POST)
        if form.is_valid():
            amount = form.cleaned_data['amount']
            customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
            if amount <= customer.savings_balance:
                customer.savings_balance -= amount
                customer.balance += amount
                customer.save()
                Transaction.objects.create(customer=customer, transaction_type='Withdraw Savings', amount=amount)
                return redirect('check_savings_balance')
    else:
        form = WithdrawSavingsForm()
    return render(request, 'transactions/withdraw_savings.html', {'form': form})


def check_savings_balance(request):
    customer = Customer.objects.get(customer_id=request.session.get('customer_id'))
    return render(request, 'transactions/check_savings_balance.html', {'savings_balance': customer.savings_balance})
