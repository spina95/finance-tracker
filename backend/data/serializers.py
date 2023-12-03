from rest_framework import serializers

class TodoSerializer(serializers.Serializer):
    name = serializers.CharField(max_length=200)
    amount = serializers.DecimalField(max_digits=5, decimal_places=2) 
    date = serializers.DateTimeField()
    payment = serializers.CharField(max_length=200)
    type = serializers.CharField(max_length=200)