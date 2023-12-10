
from django.db.models import fields
from rest_framework import serializers
from .models import Expense, PaymentType, ExpenseCategory

class ExpenseCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ExpenseCategory
        fields = '__all__'
        
class PaymentTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = PaymentType
        fields = '__all__'
 
class ExpenseSerializer(serializers.ModelSerializer):
    category = ExpenseCategorySerializer()
    paymentType = PaymentTypeSerializer()
    class Meta:
        model = Expense
        fields = '__all__'
        depth = 1
        
    def create(self, validated_data):
        category_data = validated_data.pop('category')
        category, created = ExpenseCategory.objects.get_or_create(**category_data)
        
        payment_data = validated_data.pop('paymentType')
        payment, created = PaymentType.objects.get_or_create(**payment_data)
        
        expense = Expense.objects.create(category=category, paymentType=payment, **validated_data)
        return expense