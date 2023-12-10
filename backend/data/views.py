from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from .models import Expense, ExpenseCategory, PaymentType
from .serializers import ExpenseSerializer, ExpenseCategorySerializer, PaymentTypeSerializer
from .custom_pagination import CustomPagination
from .filters import ExpenseFilter
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter

class ExpenseViewSet(viewsets.ModelViewSet):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = ExpenseFilter
    filterset_fields = ['id', 'name', 'amount', 'date', 'category']
    search_fields = ['=name', 'intro']
    ordering_fields = ['name', 'id']
    ordering = ['id']

class ExpenseCategoriesViewSet(viewsets.ModelViewSet):
    queryset = ExpenseCategory.objects.all()
    serializer_class = ExpenseCategorySerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['id', 'name']
    ordering_fields = ['name', 'id']
    ordering = ['id']
    
class PaymentViewSet(viewsets.ModelViewSet):
    queryset = PaymentType.objects.all()
    serializer_class = PaymentTypeSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['id', 'name']
    ordering_fields = ['name', 'id']
    ordering = ['id']