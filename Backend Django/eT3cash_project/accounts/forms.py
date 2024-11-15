# accounts/forms.py
from django import forms
from django.contrib.auth.forms import UserCreationForm, AuthenticationForm
from .models import CustomUser
from django.contrib.auth.forms import PasswordChangeForm
from django.utils.translation import gettext_lazy as _


class CustomPasswordChangeForm(PasswordChangeForm):
    old_password = forms.CharField(label=_("Old Password"), widget=forms.PasswordInput)
    new_password1 = forms.CharField(label=_("New Password"), widget=forms.PasswordInput)
    new_password2 = forms.CharField(label=_("Confirm New Password"), widget=forms.PasswordInput)

    class Meta:
        model = CustomUser  # Your custom user model
        fields = ['old_password', 'new_password1', 'new_password2']


class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password1', 'password2']


class CustomAuthenticationForm(AuthenticationForm):
    class Meta:
        model = CustomUser
        fields = ['username', 'password']


class DepositForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)


class WithdrawForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)


class SendMoneyForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)
    recipient_number = forms.CharField(max_length=20)


class PayBillForm(forms.Form):
    bill_type = forms.CharField(max_length=100)
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)


class CreateVirtualCardForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)


class ChangePinForm(forms.Form):
    old_pin = forms.CharField(max_length=6)
    new_pin = forms.CharField(max_length=6)


class DonateForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)
    charity_name = forms.CharField(max_length=100)


class CreateSavingsAccountForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)


class WithdrawSavingsForm(forms.Form):
    amount = forms.DecimalField(decimal_places=2, max_digits=10, min_value=0)
