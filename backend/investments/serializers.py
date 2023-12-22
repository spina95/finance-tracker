
from django.db.models import fields
from rest_framework import serializers
from .models import ProductCategory, Product

class ProductCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = ProductCategory
        fields = '__all__'
    
class ProductSerializer(serializers.ModelSerializer):
    category = ProductCategory()
    class Meta:
        model = Product
        fields = '__all__'
        depth = 1
        
    def create(self, validated_data):
        category_data = validated_data.pop('category')
        category, created = ProductCategory.objects.get_or_create(**category_data)
        
        expense = Product.objects.create(category=category, **validated_data)
        return expense