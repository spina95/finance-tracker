
from django.db.models import fields
from rest_framework import serializers
from .models import Habit, Note, TrackHabit

class NoteSerializer(serializers.ModelSerializer):
    class Meta:
        model = Note
        fields = '__all__'

class HabitSerializer(serializers.ModelSerializer):
    class Meta:
        model = Habit
        fields = '__all__'

class TrackHabitSerializer(serializers.ModelSerializer):
    habit_name = serializers.CharField(source='habit.name', read_only=True)

    class Meta:
        model = TrackHabit
        fields = ['id', 'habit', 'habit_name', 'created_date']