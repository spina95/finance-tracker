from django.db import models
from colorfield.fields import ColorField

# Create your models here.

class ExpenseCategory(models.Model):
 
    name = models.CharField(max_length = 50)
    color = ColorField(default='#FF0000', null=True)
 
    class Meta:
        db_table = "expense_categories"
        ordering = ['id']

        def __str__(self) -> str:
            return self.name
        
class PaymentType(models.Model):
 
    name = models.CharField(max_length = 50)
    color = ColorField(default='#FF0000', null=True)
 
    class Meta:
        db_table = "payment_types"
        ordering = ['id']

        def __str__(self) -> str:
            return self.name
class Expense(models.Model):
 
    name = models.CharField(max_length = 50)
    amount = models.DecimalField(max_digits = 7, decimal_places = 2) 
    date = models.DateField()
    category = models.ForeignKey(ExpenseCategory, null=True, on_delete=models.CASCADE)
    paymentType = models.ForeignKey(PaymentType, null=True, on_delete=models.CASCADE)
 
    class Meta:
        db_table = "expenses"
        ordering = ['date']

        def __str__(self) -> str:
            return self.name
        

        
