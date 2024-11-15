# accounts/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import CustomUserViewSet, TransactionViewSet
from .views import LoginView, signup_view,logout_view,get_balance,get_transactions,change_pin
from . import views

router = DefaultRouter()
router.register(r'users', CustomUserViewSet)
router.register(r'transactions', TransactionViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('login/', LoginView.as_view(), name='login'),
    path('signup/', signup_view, name='signup'),
    path('dashboard/', views.dashboard, name='dashboard'),  # Map root URL to dashboard
    path('logout/', logout_view, name='logout'),
    path('api/get_balance/', get_balance, name='get_balance'),
    path('api/get_transactions/', get_transactions, name='get_transactions'),
    path('change-pin/', change_pin, name='change_pin'),
]
