from django.urls import include, path
from rest_framework import routers
from .views import ExpenseViewSet, ExpenseCategoriesViewSet, PaymentViewSet, IncomeViewSet, IncomeCategoriesViewSet, total_categories, expenses_months, incomes_months, month_total_expenses, month_total_incomes

router = routers.DefaultRouter()
router.register(r'expenses', ExpenseViewSet, basename="expense")
router.register(r'expenses-categories', ExpenseCategoriesViewSet, basename="expense-categories")
router.register(r'payments', PaymentViewSet, basename="payments")
router.register(r'incomes', IncomeViewSet, basename="incomes")
router.register(r'income-categories', IncomeCategoriesViewSet, basename="income-categories")

urlpatterns = [
    path('', include(router.urls)),
    path('expenses/categories-total', total_categories),
    path('expenses/months', expenses_months),
    path('incomes/months', incomes_months),
    path('expenses/current-month', month_total_expenses),
    path('incomes/current-month', month_total_incomes),
]