from django.shortcuts import render
from rest_framework.decorators import api_view
from rest_framework.response import Response
from .tasks import import_expenses
# Register the task to be executed

'''
Import expenses from Notion
'''
@api_view(['POST',])
def import_notion_expenses(request):
    date = request.GET.get('date-import', None)
    if not date:
        today = date.today()
        date =  today.strftime('%Y-%m-%d')

    import_expenses(date)
    return Response("ok") 