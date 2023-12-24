from rest_framework import viewsets
from django.shortcuts import render
from .models import ProductCategory, Product
from .serializers import ProductCategorySerializer, ProductSerializer
from .custom_pagination import CustomPagination
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.decorators import api_view
from rest_framework.response import Response
import yfinance as yf
from datetime import date, timedelta


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
    
'''
Return info data of product
'''
@api_view(['GET'])
def product_info(request, id):
    product = Product.objects.get(id=id)
    ticker = product.ticker
    product_data = yf.Ticker(ticker)
    data = {
        "info": product_data.info,
    }
    
    return Response(data)

    
'''
Return historical data of product
'''
@api_view(['GET'])
def product_history(request, id):
    product = Product.objects.get(id=id)
    ticker = product.ticker
    product_data = yf.Ticker(ticker)
    
    history = product_data.history(period="3mo", interval="1d")
    
    len_history = len(history['Open'])
    
    start_dt = date.today()
    delta = timedelta(days=1)
    
    dates = []
    for i in range(len_history):
        dates.insert(0, start_dt.isoformat())
        start_dt -= delta
        
    data = {
        "history": history,
        "dates": dates
    }
    
    return Response(data)
