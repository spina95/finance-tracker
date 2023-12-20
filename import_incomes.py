import csv
import requests
import json
categories = requests.get("http://127.0.0.1:8000/api/v1/income-categories/").json()
categories = {x['name']: x for x in categories['results']}

payments = requests.get("http://127.0.0.1:8000/api/v1/payments/").json()
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
        
        expense = requests.post("http://127.0.0.1:8000/api/v1/incomes/", json=data)