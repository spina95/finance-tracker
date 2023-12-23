from django.db import models
from colorfield.fields import ColorField

# Create your models here.

class ProductCategory(models.Model):
 
    name = models.CharField(max_length = 50)
    color = ColorField(default='#FF0000', null = True)
    icon = models.CharField(max_length = 50, null = True)
 
    class Meta:
        db_table = "product_categories"
        ordering = ['id']

        def __str__(self) -> str:
            return self.name
        
class Product(models.Model):
 
    name = models.CharField(max_length = 50)
    ticker = models.CharField(max_length = 50, null=True)
    link = models.URLField(null=True)
    category = models.ForeignKey(ProductCategory, null=True, on_delete=models.CASCADE)
 
    class Meta:
        db_table = "products"
        ordering = ['name']

        def __str__(self) -> str:
            return self.name