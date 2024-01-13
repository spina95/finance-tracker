import requests
import json
from datetime import datetime

from data.models import Expense, ExpenseCategory, PaymentType

def import_expenses(date):
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
        
        
    
    pass
