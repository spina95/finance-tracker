from rest_framework import viewsets
from django.shortcuts import render
from .models import ProductCategory, Product
from .serializers import ProductCategorySerializer, ProductSerializer
from .custom_pagination import CustomPagination
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

# Create your views here.
class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['id', 'name', 'ticker', 'category']
    search_fields = ['=name', 'intro']
    ordering_fields = ['name', 'id', 'category__name', 'ticker']
    ordering = ['id']

class ProductCategoriesViewSet(viewsets.ModelViewSet):
    queryset = ProductCategory.objects.all()
    serializer_class = ProductCategorySerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['id', 'name']
    ordering_fields = ['name', 'id']
    ordering = ['id']