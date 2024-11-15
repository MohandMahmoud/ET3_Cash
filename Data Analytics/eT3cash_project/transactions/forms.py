from django import forms


class DepositForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")


class WithdrawForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")


class SendMoneyForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")
    recipient_number = forms.CharField(max_length=20, label="Recipient Number")


class PayBillForm(forms.Form):
    bill_type = forms.CharField(max_length=50, label="Bill Type")
    amount = forms.FloatField(min_value=0.01, label="Amount")


class CreateVirtualCardForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")


class CheckBalanceForm(forms.Form):
    pass


class ChangePinForm(forms.Form):
    old_pin = forms.CharField(max_length=4, label="Old PIN")
    new_pin = forms.CharField(max_length=4, label="New PIN")


class DonateForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")
    charity_name = forms.CharField(max_length=100, label="Charity Name")


class CreateSavingsAccountForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")


class WithdrawSavingsForm(forms.Form):
    amount = forms.FloatField(min_value=0.01, label="Amount")


class CheckSavingsBalanceForm(forms.Form):
    pass
