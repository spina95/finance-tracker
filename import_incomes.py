import csv
import requests
import json
base_url = 'https://finance-tracker-567ntiy4ya-ew.a.run.app' # 'http://127.0.0.1:8000'
categories = requests.get(base_url + "/data/income-categories/").json()
categories = {x['name']: x for x in categories['results']}

payments = requests.get(base_url + "/data/payments/").json()
payments = {x['name']: x for x in payments['results']}

with open("incomes.csv", encoding="utf8") as csvfile:
    csvreader = csv.reader(csvfile, delimiter=",")
    next(csvreader, None)

    for row in csvreader:
        category = categories.get(row[2], None)
        
        payment = payments.get(row[3], None)
        
        data = {
            "name": row[0],
            "date": row[4],
            "amount": float(row[1].replace(',', '')),
            "category": category,
            "paymentType": payment
        }
        
        expense = requests.post(base_url + "/data/incomes/", json=data)