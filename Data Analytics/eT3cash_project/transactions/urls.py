from django.urls import path
from . import views

urlpatterns = [
    path('', views.home, name='home'),
    path('deposit/', views.deposit, name='deposit'),
    path('withdraw/', views.withdraw, name='withdraw'),
    path('send-money/', views.send_money, name='send_money'),
    path('pay-bill/', views.pay_bill, name='pay_bill'),
    path('create-virtual-card/', views.create_virtual_card, name='create_virtual_card'),
    path('check-balance/', views.check_balance, name='check_balance'),
    path('view-transaction-history/', views.view_transaction_history, name='view_transaction_history'),
    path('change-pin/', views.change_pin, name='change_pin'),
    path('donate/', views.donate, name='donate'),
    path('create-savings-account/', views.create_savings_account, name='create_savings_account'),
    path('withdraw-savings/', views.withdraw_savings, name='withdraw_savings'),
    path('check-savings-balance/', views.check_savings_balance, name='check_savings_balance'),
]
