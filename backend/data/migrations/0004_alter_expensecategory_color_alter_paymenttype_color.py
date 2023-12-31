# Generated by Django 4.2.7 on 2023-12-09 19:02

import colorfield.fields
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('data', '0003_expensecategory_color_paymenttype_color'),
    ]

    operations = [
        migrations.AlterField(
            model_name='expensecategory',
            name='color',
            field=colorfield.fields.ColorField(blank=True, default='#FF0000', image_field=None, max_length=25, null=True, samples=None),
        ),
        migrations.AlterField(
            model_name='paymenttype',
            name='color',
            field=colorfield.fields.ColorField(blank=True, default='#FF0000', image_field=None, max_length=25, null=True, samples=None),
        ),
    ]
