# admin.py
from django.contrib import admin
from .models import CustomUser, Transaction
from django.contrib.auth.forms import UserCreationForm, UserChangeForm


class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ('username', 'email', 'first_name', 'last_name')


class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = CustomUser
        fields = ('username', 'email', 'first_name', 'last_name', 'balance', 'savings_balance')


class CustomUserAdmin(admin.ModelAdmin):
    model = CustomUser
    add_form = CustomUserCreationForm
    form = CustomUserChangeForm

    list_display = (
    'username', 'email', 'first_name', 'last_name', 'balance', 'savings_balance', 'is_active', 'is_staff',
    'date_joined')
    list_filter = ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions', 'date_joined', 'last_login')
    search_fields = ('username', 'email', 'first_name', 'last_name')
    ordering = ('username',)
    readonly_fields = ('balance', 'savings_balance', 'transaction_history')

    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal info', {'fields': ('first_name', 'last_name', 'email', 'pin', 'balance', 'savings_balance')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'email', 'password1', 'password2'),
        }),
    )

    def save_model(self, request, obj, form, change):
        if not change:  # If creating a new user
            obj.set_password(obj.password)
        super().save_model(request, obj, form, change)

    def get_readonly_fields(self, request, obj=None):
        """
        Returns readonly fields based on whether the object exists.
        """
        if obj:  # Object exists, make certain fields readonly
            return self.readonly_fields + ('username', 'email')
        return self.readonly_fields


class TransactionAdmin(admin.ModelAdmin):
    list_display = ('user', 'transaction_type', 'amount', 'date', 'details')
    search_fields = ('user__username', 'transaction_type', 'details')
    list_filter = ('transaction_type', 'date')
    ordering = ('-date',)
    readonly_fields = ('date',)

    def has_add_permission(self, request):
        """
        Allows adding new transactions from the admin interface.
        """
        return True

    def has_change_permission(self, request, obj=None):
        """
        Restricts changing existing transactions from the admin interface.
        """
        return False

    def has_delete_permission(self, request, obj=None):
        """
        Restricts deleting transactions from the admin interface.
        """
        return False


admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(Transaction, TransactionAdmin)
