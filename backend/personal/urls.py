from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import HabitViewSet, NoteViewSet, TrackHabitViewSet

router = DefaultRouter()
router.register(r'notes', NoteViewSet, basename="notes")
router.register(r'habits', HabitViewSet, basename="habits")
router.register(r'track-habits', TrackHabitViewSet, basename="track-habits")


urlpatterns = [
    path('', include(router.urls)),
]