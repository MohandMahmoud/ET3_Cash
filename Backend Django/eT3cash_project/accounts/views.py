# accounts/views.py
from rest_framework import viewsets
from rest_framework.permissions import IsAuthenticated
from .models import Transaction, VirtualCard
from .serializers import CustomUserSerializer, TransactionSerializer, VirtualCardSerializer, LoginSerializer
from .permissions import IsOwnerOrReadOnly
from django.shortcuts import render, redirect
from django.contrib.auth import logout as auth_logout
from django.http import JsonResponse
from .forms import CustomUserCreationForm
from django.contrib.auth import authenticate
from .models import CustomUser
from .forms import DepositForm, WithdrawForm, SendMoneyForm, PayBillForm, CreateVirtualCardForm, ChangePinForm, \
    DonateForm, CreateSavingsAccountForm, WithdrawSavingsForm
from django.contrib.auth.decorators import login_required
from decimal import Decimal
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.views.decorators.http import require_POST

from rest_framework import status
from rest_framework.views import APIView
from .serializers import CustomUserSerializer
from rest_framework.pagination import PageNumberPagination


class LoginView(APIView):
    def post(self, request):
        serializer = LoginSerializer(data=request.data)
        if serializer.is_valid():
            username = serializer.validated_data['username']
            password = serializer.validated_data['password']
            user = authenticate(username=username, password=password)
            if user is not None:
                # Return user info (excluding sensitive data)
                return Response({'customer_id': user.id, 'username': user.username, 'email': user.email},
                                status=status.HTTP_200_OK)
            else:
                return Response({'detail': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


def signup_view(request):
    if request.method == 'POST':
        form = CustomUserCreationForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('login')
    else:
        form = CustomUserCreationForm()
    return render(request, 'signup.html', {'form': form})


@login_required
def dashboard(request):
    user = request.user
    balance = user.get_balance()
    if request.method == 'POST':
        action = request.POST.get('action')
        recipient_number = request.POST.get('recipient_number', '')
        charity_name = request.POST.get('charity_name', '')
        old_pin = request.POST.get('old_pin')
        new_pin = request.POST.get('new_pin')

        try:
            amount = Decimal(request.POST.get('amount'))  # Convert amount to Decimal

            if action == 'deposit':
                user.deposit(amount)
                Transaction.objects.create(user=user, transaction_type='Deposit', amount=amount)
                message = 'Deposit successful.'

            elif action == 'withdraw':
                user.withdraw(amount)
                Transaction.objects.create(user=user, transaction_type='Withdrawal', amount=amount)
                message = 'Withdrawal successful.'

            elif action == 'send_money':
                user.send_money(amount, recipient_number)
                Transaction.objects.create(user=user, transaction_type='Send Money', amount=amount,
                                           details=f"Recipient: {recipient_number}")
                message = 'Money sent successfully.'

            elif action == 'pay_bill':
                bill_type = request.POST.get('bill_type')
                amount = Decimal(request.POST.get('amount'))
                user = request.user
                user_balance = user.get_balance()

                if 0 < amount <= user_balance:
                    user_balance -= amount
                    Transaction.objects.create(
                        user=user,
                        transaction_type='pay_bill',
                        amount=amount,
                        details=f"Paid {bill_type} bill."
                    )

                    return JsonResponse({'message': f'Paid ${amount:.2f} for {bill_type} successfully.'})
                else:
                    return JsonResponse({'message': 'Insufficient balance or invalid amount.'}, status=400)

            elif action == 'donate':
                user.donate(amount, charity_name)
                Transaction.objects.create(user=user, transaction_type='Donation', amount=amount,
                                           details=f"Charity: {charity_name}")
                message = 'Donation successful.'

            elif action == 'create_savings_account':
                amount = Decimal(amount)
                request.user.create_savings_account(amount)
                message = 'Savings account created successfully.'

            elif action == 'create_virtual_card':
                amount = Decimal(amount)
                creation_result = request.user.create_virtual_cad(amount)
                if "successfully" in creation_result:
                    VirtualCard.objects.create(
                        user=request.user,
                        card_name=request.POST.get('card_name', 'Default Card Name'),
                        limit=amount,
                    )
                    return JsonResponse({'message': creation_result})
                else:
                    return JsonResponse({'message': creation_result}, status=400)

            elif action == 'withdraw_savings':
                user.withdraw_savings(amount)
                Transaction.objects.create(user=user, transaction_type='Withdraw Savings', amount=amount)
                message = 'Savings withdrawal successful.'

            elif action == 'change_pin':
                if user.verify_pin(old_pin):  # Assume you have a method to check the PIN
                    user.set_pin(new_pin)  # Assume you have a method to set the PIN
                    return JsonResponse({'message': 'PIN changed successfully!'})
                else:
                    return JsonResponse({'message': 'Old PIN is incorrect!'}, status=400)
            else:
                message = 'Invalid action.'

        except ValueError as e:
            message = f'Error processing amount: {e}'

        except Exception as e:
            message = str(e)

        return JsonResponse({'message': message})

    # GET request: render the dashboard template

    deposit_form = DepositForm()
    withdraw_form = WithdrawForm()
    send_money_form = SendMoneyForm()
    pay_bill_form = PayBillForm()
    create_virtual_card_form = CreateVirtualCardForm()
    change_pin_form = ChangePinForm()
    donate_form = DonateForm()
    create_savings_account_form = CreateSavingsAccountForm()
    withdraw_savings_form = WithdrawSavingsForm()

    return render(request, 'dashboard.html', {
        'deposit_form': deposit_form,
        'withdraw_form': withdraw_form,
        'send_money_form': send_money_form,
        'pay_bill_form': pay_bill_form,
        'create_virtual_card_form': create_virtual_card_form,
        'change_pin_form': change_pin_form,
        'donate_form': donate_form,
        'create_savings_account_form': create_savings_account_form,
        'withdraw_savings_form': withdraw_savings_form,
        'balance': balance,
    })


@login_required
def get_balance(request):
    if request.is_ajax and request.method == "GET":
        user = request.user
        balance = user.get_balance()  # Fetch balance
        return JsonResponse({'balance': balance})


@login_required
@api_view(['GET'])
def get_transactions(request):
    user = request.user
    transactions = Transaction.objects.filter(user=user).values('transaction_type', 'amount',
                                                                'date')  # Adjust fields as needed

    return Response({'transactions': list(transactions)})


@login_required
@require_POST
def change_pin(request):
    old_pin = request.POST.get('old_pin')
    new_pin = request.POST.get('new_pin')

    user = request.user  # Get the logged-in user

    if user.verify_pin(old_pin):
        user.set_pin(new_pin)
        return JsonResponse({'message': 'PIN changed successfully!'})
    else:
        return JsonResponse({'message': 'Old PIN is incorrect!'}, status=400)


def logout_view(request):
    auth_logout(request)
    return redirect('login')


class CustomPagination(PageNumberPagination):
    page_size = 10  # Set the default page size
    page_size_query_param = 'page_size'
    max_page_size = 100


class CustomUserViewSet(viewsets.ModelViewSet):
    queryset = CustomUser.objects.all()
    serializer_class = CustomUserSerializer
    permission_classes = [IsOwnerOrReadOnly, IsAuthenticated]
    pagination_class = CustomPagination


class TransactionViewSet(viewsets.ModelViewSet):
    queryset = Transaction.objects.all()
    serializer_class = TransactionSerializer
    permission_classes = [IsOwnerOrReadOnly, IsAuthenticated]

    def perform_create(self, serializer):
        # Set the 'user' field to the current user before saving
        serializer.save(user=self.request.user)


class VirtualCardViewSet(viewsets.ModelViewSet):
    queryset = VirtualCard.objects.all()
    serializer_class = VirtualCardSerializer
    permission_classes = [IsOwnerOrReadOnly, IsAuthenticated]
