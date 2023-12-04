from rest_framework import serializers

class ExpenseSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=200)
    amount = serializers.DecimalField(max_digits=20, decimal_places=2) 
    date = serializers.DateTimeField()
    payment = serializers.CharField(max_length=200)
    type = serializers.CharField(max_length=200)

class CategorySerializer(serializers.Serializer):
    color = serializers.CharField(max_length=10)
    category = serializers.CharField(source='id', max_length=10)