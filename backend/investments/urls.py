from django.urls import include, path
from rest_framework import routers
from .views import ProductViewSet, ProductCategoriesViewSet, product_history, product_info

router = routers.DefaultRouter()
router.register(r'products', ProductViewSet, basename="products")
router.register(r'products-categories', ProductCategoriesViewSet, basename="products-categories")

urlpatterns = [
    path('', include(router.urls)),
    path('products/<int:id>/info', product_info),
    path('products/<int:id>/history', product_history),
]