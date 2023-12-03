from data.views import ExpensesViewSet
from rest_framework.routers import DefaultRouter

app_name = 'data'

router = DefaultRouter()
router.register(r'expenses', ExpensesViewSet, basename='expenses')
urlpatterns = router.urls