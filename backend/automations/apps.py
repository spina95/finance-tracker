from django.apps import AppConfig
from .tasks import set_schedule

class AutomationsConfig(AppConfig):
    name = "automations"
    
    def ready(self):
        import sys
        if not 'manage.py' in sys.argv:
            set_schedule()

