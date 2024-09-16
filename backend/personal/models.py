from django.db import models

# Create your models here.
class Note(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255, blank=True)
    text = models.TextField(blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_updated_at = models.DateTimeField(auto_now=True)
    status = models.CharField(max_length=10, null=True)
    
    class Meta:
        db_table = "notes"
        ordering = ['id']

        def __str__(self) -> str:
            return self.title
        
class Habit(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=255, blank=True)
    icon = models.CharField(max_length=10, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        db_table = "habits"
        ordering = ['id']

        def __str__(self) -> str:
            return self.name
        
class TrackHabit(models.Model):
    id = models.AutoField(primary_key=True)
    habit = models.ForeignKey(Habit, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    date = models.DateField(null=True, blank=True)


    class Meta:
        db_table = "track_habits"
        ordering = ['date']

    def __str__(self) -> str:
        return f"TrackHabit for {self.habit} on {self.created_at}"