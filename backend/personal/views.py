from django.shortcuts import render
from rest_framework import viewsets, mixins
from rest_framework.response import Response
from .models import Habit, Note, TrackHabit
from .serializers import NoteSerializer, HabitSerializer, TrackHabitSerializer
from rest_framework import filters
from django.db.models import Q

class NoteViewSet(viewsets.ModelViewSet):
    queryset = Note.objects.all()
    serializer_class = NoteSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['created_at__month']
    
    def get_queryset(self):
        queryset = super().get_queryset()
        month = self.request.query_params.get('month', None)
        if month:
            queryset = queryset.filter(created_at__month=month)
        return queryset
    
class HabitViewSet(viewsets.ModelViewSet):
    queryset = Habit.objects.all()
    serializer_class = HabitSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['name']

class TrackHabitViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    queryset = Habit.objects.all()
    serializer_class = HabitSerializer
    filter_backends = [filters.SearchFilter]
    search_fields = ['name']
    
    def list(self, request, *args, **kwargs):
        date = request.query_params.get('date', None)
        if date:
            habits_with_track_habits = TrackHabit.objects.filter(date=date).values_list('habit_id', flat=True)
            habits = self.queryset.annotate(has_track_habit=Q(id__in=habits_with_track_habits)).values('id', 'name', 'has_track_habit')
            serializer = self.get_serializer(habits, many=True)
 
            return Response(serializer.data)
        else:
            return super().list(request, *args, **kwargs)