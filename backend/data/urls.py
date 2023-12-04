from data.views import ExpensesViewSet, CategoriesViewSet
from rest_framework.routers import DefaultRouter

app_name = 'data'

router = DefaultRouter()
router.register(r'expenses', ExpensesViewSet, basename='expenses')
router.register(r'categories', CategoriesViewSet, basename='categories')
urlpatterns = router.urls