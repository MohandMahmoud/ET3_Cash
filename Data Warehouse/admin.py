from django.contrib import admin
from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from django.core.files.uploadedfile import InMemoryUploadedFile
from io import StringIO
import csv
import json
from django.db import connection
from .models import CustomUser, Transaction, FileUpload


# Custom User Creation Form
class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = CustomUser
        fields = ('username', 'email', 'first_name', 'last_name')


# Custom User Change Form
class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = CustomUser
        fields = ('username', 'email', 'first_name', 'last_name', 'balance', 'savings_balance')


# Custom User Admin Class
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
        if obj:  # Object exists, make certain fields readonly
            return self.readonly_fields + ('username', 'email')
        return self.readonly_fields


# Transaction Admin Class
class TransactionAdmin(admin.ModelAdmin):
    list_display = ('user', 'transaction_type', 'amount', 'date', 'details')
    search_fields = ('user__username', 'transaction_type', 'details')
    list_filter = ('transaction_type', 'date')
    ordering = ('-date',)
    readonly_fields = ('date',)

    def has_add_permission(self, request):
        return True

    def has_change_permission(self, request, obj=None):
        return False

    def has_delete_permission(self, request, obj=None):
        return False


# Registering Custom User and Transaction Admins
admin.site.register(CustomUser, CustomUserAdmin)
admin.site.register(Transaction, TransactionAdmin)


# File Upload Model Form
class FileUploadAdminForm(forms.ModelForm):
    class Meta:
        model = FileUpload
        fields = ['uploaded_file', 'file_type']

    def save(self, commit=True):
        file = self.cleaned_data['uploaded_file']
        file_type = self.cleaned_data['file_type']

        if file_type == 'csv':
            self._process_csv(file)
        elif file_type == 'json':
            self._process_json(file)
        elif file_type == 'sql':
            self._process_sql(file)
        return super().save(commit)

    @staticmethod
    def _process_csv(file):
        if isinstance(file, InMemoryUploadedFile):
            file_content = file.read().decode('utf-8')
            csv_file = StringIO(file_content)
            reader = csv.DictReader(csv_file)
            for row in reader:
                print(row)
                username = row.get('username')
                if not username:
                    continue  # Skip this row if username is missing
                # Process user data
                first_name = row.get('first_name')
                last_name = row.get('last_name')
                email = row.get('email')
                is_active = row.get('is_active', 'True') == 'True'
                is_staff = row.get('is_staff', 'False') == 'True'
                is_superuser = row.get('is_superuser', 'False') == 'True'

                # Create or update user
                CustomUser.objects.update_or_create(
                    username=username,
                    defaults={
                        'first_name': first_name,
                        'last_name': last_name,
                        'email': email,
                        'is_active': is_active,
                        'is_staff': is_staff,
                        'is_superuser': is_superuser,
                    }
                )

    @staticmethod
    def _process_json(file):
        if isinstance(file, InMemoryUploadedFile):
            file_content = file.read().decode('utf-8')
            data = json.loads(file_content)
            print(data)
            for item in data:

                username = item.get('username')
                if not username:
                    continue  # Skip if username is missing
                # Process user data
                first_name = item.get('first_name')
                last_name = item.get('last_name')
                email = item.get('email')
                is_active = item.get('is_active', True)
                is_staff = item.get('is_staff', False)
                is_superuser = item.get('is_superuser', False)

                # Create or update user
                CustomUser.objects.update_or_create(
                    username=username,
                    defaults={
                        'first_name': first_name,
                        'last_name': last_name,
                        'email': email,
                        'is_active': is_active,
                        'is_staff': is_staff,
                        'is_superuser': is_superuser,
                    }
                )

    @staticmethod
    def _process_sql(file):
        if isinstance(file, InMemoryUploadedFile):
            file_content = file.read().decode('utf-8')
            sql_queries = file_content.strip()

            queries = sql_queries.split(';')
            print(queries)
            with connection.cursor() as cursor:
                for query in queries:
                    query = query.strip()
                    if query:
                        try:
                            cursor.execute(query)
                        except Exception as e:
                            print(f"Error executing query: {e}")


# File Upload Admin Class
class FileUploadAdmin(admin.ModelAdmin):
    form = FileUploadAdminForm
    list_display = ('uploaded_file', 'file_type', 'uploaded_at')


admin.site.register(FileUpload, FileUploadAdmin)
