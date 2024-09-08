import requests
import json
from datetime import datetime, time

from apscheduler.schedulers.background import BackgroundScheduler


def set_schedule():
    scheduler = BackgroundScheduler()
    
    # Add import_expenses schedule for every day at 1:00 AM
    scheduler.add_job(import_expenses, 'cron', day_of_week='mon-sun', hour=1, minute=0)
    
    # Start the scheduler
    print("Scheduler started")
    scheduler.start()

def my_task():
    print("okokokokok")

def import_expenses(date=None):
    from data.models import Expense, ExpenseCategory, PaymentType
    from .models import Automations
    
    try:
        if not date:
            date = datetime.today().strftime('%Y-%m-%d')
            
        # Search for automations that have already run on this date and succeeded
        found_automations = Automations.objects.filter(start_time__date=date, success=True)
        if found_automations:
            return
        
        start_time = datetime.now()
        
        url = "https://api.notion.com/v1/databases/d2f22b129161420caa9d3d22c1e9f72e/query"

        payload = json.dumps({
        "filter": {
            "and": [
            {
                "property": "Date",
                "date": {
                "equals": date
                }
            }
            ]
        },
        "sorts": [
            {
            "property": "Name",
            "direction": "ascending"
            }
        ]
        })
        headers = {
        'Authorization': 'Bearer secret_9uwFowpYzgy98HEmbVKMJZp3xlkiuZTIGUcFFIcbHki',
        'Content-Type': 'application/json',
        'Notion-Version': '2022-02-22',
        'Cookie': '__cf_bm=8wPr6WVqi.EbsEsLGCIy0Asy6qYCoIxxO9zHimgaCf8-1705085775-1-ATOpC4eer2waXTPHOgsRcC7AQPdnEFIfQHbxPUOPLnt0B6868c9tOvvAmbYyxqpzb46kJj4/gYyc77DKMEfqaGk='
        }

        response = requests.request("POST", url, headers=headers, data=payload).json()
        
        for expense in response['results']:
            properties = expense['properties']
            
            date = properties['Date']['date']['start']
            payment = properties['Payment']['select']['name']
            amount = properties['Amount']['number']
            type = properties['Type']['select']['name']
            name = properties['Name']['title'][0]['plain_text']
            
            category = ExpenseCategory.objects.get(name=type)
            payment_type = PaymentType.objects.get(name=payment) 
            
            # TODO: find same expenses and evoid insert if exists
            
            new_expense = Expense(
                name = name,
                amount = amount,
                date = datetime.strptime(date, '%Y-%m-%d'),
                category = category,
                paymentType = payment_type
            )
            new_expense.save()
            
            pass
            
        automation = Automations(
            name = "import-expenses",
            start_time = start_time,
            end_time = datetime.now(),
            success = True
        )
        automation.save()
    except Exception as e:
        automation = Automations(
            name = "import-expenses",
            start_time = start_time,
            end_time = datetime.now(),
            success = False,
            exception = str(e)
        )
        automation.save()
