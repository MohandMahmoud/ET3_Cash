# accounts/serializers.py

from rest_framework import serializers
from .models import CustomUser, Transaction, VirtualCard


class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)


class TransactionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Transaction
        fields = ['id', 'transaction_type', 'amount', 'date', 'details']  # Send money


class CustomUserSerializer(serializers.ModelSerializer):
    transactions = TransactionSerializer(many=True, read_only=True)

    class Meta:
        model = CustomUser
        fields = ['customer_id', 'username', 'email', 'balance', 'savings_balance', 'pin', 'transaction_history',
                  'transactions']


class VirtualCardSerializer(serializers.ModelSerializer):
    class Meta:
        model = VirtualCard
        fields = ['card_name', 'limit', 'created_at']
