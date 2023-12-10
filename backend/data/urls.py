from django.urls import include, path
from rest_framework import routers
from .views import ExpenseViewSet, ExpenseCategoriesViewSet, PaymentViewSet

router = routers.DefaultRouter()
router.register(r'expenses', ExpenseViewSet, basename="expense")
router.register(r'expenses-categories', ExpenseCategoriesViewSet, basename="expense-categories")
router.register(r'payments', PaymentViewSet, basename="payments")

urlpatterns = [
    path('', include(router.urls)),
]