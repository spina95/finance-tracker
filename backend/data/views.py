from django.shortcuts import render
import datetime

# Create your views here.
from rest_framework import viewsets
from .models import Expense, ExpenseCategory, PaymentType, Income, IncomeCategory
from .serializers import ExpenseSerializer, ExpenseCategorySerializer, PaymentTypeSerializer, IncomeSerializer, IncomeCategorySerializer
from .custom_pagination import CustomPagination
from .filters import ExpenseFilter, IncomeFilter
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.db.models import Sum
from django.db.models.functions import TruncMonth

from .utils import month_name_to_number

class ExpenseViewSet(viewsets.ModelViewSet):
    queryset = Expense.objects.all()
    serializer_class = ExpenseSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = ExpenseFilter
    filterset_fields = ['id', 'name', 'amount', 'date', 'category']
    search_fields = ['=name', 'intro']
    ordering_fields = ['name', 'id', 'date', 'category__name', 'amount', 'paymentType__name']
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
    
class IncomeCategoriesViewSet(viewsets.ModelViewSet):
    queryset = IncomeCategory.objects.all()
    serializer_class = IncomeCategorySerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_fields = ['id', 'name']
    ordering_fields = ['name', 'id']
    ordering = ['id']

class IncomeViewSet(viewsets.ModelViewSet):
    queryset = Income.objects.all()
    serializer_class = IncomeSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter, OrderingFilter]
    filterset_class = IncomeFilter
    filterset_fields = ['id', 'name', 'amount', 'date', 'category']
    search_fields = ['=name', 'intro']
    ordering_fields = ['name', 'id', 'date', 'category__name', 'amount', 'paymentType__name']
    ordering = ['id']
    
'''
Return total amounts per category
'''
@api_view(['GET'])
def total_categories(request):
    year = request.GET.get('year')
    month = request.GET.get('month')
    if month:
        month = month_name_to_number(month)
        total_categories = Expense.objects.filter(date__year=year, date__month=month).values('category__name', 'category__icon', 'category__color').annotate(total_price=Sum('amount')).order_by('-total_price')
        total = Expense.objects.filter(date__year=year, date__month=month).aggregate(total_price=Sum('amount'))
    else:
        total_categories = Expense.objects.filter(date__year=year).values('category__name', 'category__icon', 'category__color').annotate(total_price=Sum('amount')).order_by('-total_price')
        total = Expense.objects.filter(date__year=year).aggregate(total_price=Sum('amount'))
    
    data = {
        "categories": total_categories,
        "total": total['total_price']
    }
    return Response(data)

'''
Return total expenses per month by year
'''
@api_view(['GET'])
def expenses_months(request):
    year = request.GET.get('year')
    totals = Expense.objects.filter(date__year=year).annotate(month=TruncMonth("date")).values("month").annotate(amount=Sum("amount")).order_by('month')
    return Response(totals)

'''
Return total incomes per month by year
'''
@api_view(['GET'])
def incomes_months(request):
    year = request.GET.get('year')
    totals = Income.objects.filter(date__year=year).annotate(month=TruncMonth("date")).values("month").annotate(amount=Sum("amount")).order_by('month')
    return Response(totals)

'''
Return this month total expenses and increase
'''
@api_view(['GET'])
def month_total_expenses(request):
    today = datetime.date.today()
    totals = Expense.objects.filter(date__year=today.year, date__month=today.month).aggregate(amount=Sum("amount"))['amount']
    
    first = today.replace(day=1)
    last_month = first - datetime.timedelta(days=1)
    last_month_total = Expense.objects.filter(date__year=last_month.year, date__month=last_month.month).aggregate(amount=Sum("amount"))['amount']
    
    increase = (totals - last_month_total) / last_month_total * 100
    data = {
        'amount': round(totals, 2),
        'increase': round(increase, 2)
    }
    return Response(data)

'''
Return this month total incomes and increase
'''
@api_view(['GET'])
def month_total_incomes(request):
    today = datetime.date.today()
    totals = Income.objects.filter(date__year=today.year, date__month=today.month).aggregate(amount=Sum("amount"))['amount']
    
    first = today.replace(day=1)
    last_month = first - datetime.timedelta(days=1)
    last_month_total = Income.objects.filter(date__year=last_month.year, date__month=last_month.month).aggregate(amount=Sum("amount"))['amount']
    
    increase = (totals - last_month_total) / last_month_total * 100
    data = {
        'amount': round(totals, 2),
        'increase': round(increase, 2)
    }
    return Response(data)