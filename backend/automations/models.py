from django.db import models

# Create your models here.
class Automations(models.Model):
 
    name = models.CharField(max_length = 50)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    success = models.BooleanField()
    
 
    class Meta:
        db_table = "automations"
        ordering = ['start_time']

        def __str__(self) -> str:
            return self.name