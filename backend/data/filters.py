from django_filters import rest_framework as filters
from .models import Expense

class ExpenseFilter(filters.FilterSet):
    min_amount = filters.NumberFilter(field_name="amount", lookup_expr="gte")
    max_amount = filters.NumberFilter(field_name="amount", lookup_expr="lte")
    start_date = filters.DateFilter(field_name="date", lookup_expr="gte")
    end_date = filters.DateFilter(field_name="date", lookup_expr="lte")

    class Meta:
        model = Expense
        fields = [
            'id', 'name', 'amount', 'date', 'category',
            'min_amount',
            'max_amount',
            'start_date',
            'end_date',
        ]
