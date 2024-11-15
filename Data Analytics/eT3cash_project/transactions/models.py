from django.db import models


class Customer(models.Model):
    #Dec
    customer_id = models.CharField(max_length=20, unique=True)
    balance = models.FloatField(default=0.0)
    savings_balance = models.FloatField(default=0.0)
    pin = models.CharField(max_length=4, default='1234')
    objects = models.Manager()


class Transaction(models.Model):
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE)
    transaction_type = models.CharField(max_length=50)
    amount = models.FloatField()
    timestamp = models.DateTimeField(auto_now_add=True)
    details = models.TextField(blank=True, null=True)
    objects = models.Manager()
