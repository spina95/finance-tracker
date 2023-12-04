from rest_framework.exceptions import NotFound

from data.firebase import FirebaseClient
from data.serializers import ExpenseSerializer, CategorySerializer
from rest_framework import viewsets, status
from rest_framework.response import Response


class ExpensesViewSet(viewsets.ViewSet):
    client = FirebaseClient()
    collection = 'expenses'

    def create(self, request, *args, **kwargs):
        serializer = ExpenseSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        self.client.create(self.collection, serializer.data)

        return Response(
            serializer.data,
            status=status.HTTP_201_CREATED
        )

    def list(self, request):
        sort_by = request.GET.get("sort-by")
        order = request.GET.get("order")
        page = int(request.GET.get("page"))
        limit = int(request.GET.get("limit"))
        filters = [
            ['amount', '>=', int(request.GET.get("min_price", 0))],
            ['amount', '<=', int(request.GET.get("max_price", 2000))],
        ]
        instances = self.client.filter(self.collection, sort_by=sort_by, order=order, page=page, limit=limit, filters=filters)
        count = self.client.count(self.collection)
        serializer = ExpenseSerializer(instances, many=True)
        data = {
            "data": serializer.data,
            "total_count": count
        }
        return Response(data)

    def retrieve(self, request, pk=None):
        todo = self.client.get_by_id(self.collection, pk)

        if todo:
            serializer = ExpenseSerializer(todo)
            return Response(serializer.data)

        raise NotFound(detail="Todo Not Found", code=404)

    def destroy(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        self.client.delete_by_id(self.collection, pk)
        return Response(status=status.HTTP_204_NO_CONTENT)

    def update(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        serializer = ExpenseSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        self.client.update(self.collection, pk, serializer.data)

        return Response(serializer.data)

class CategoriesViewSet(viewsets.ViewSet):
    client = FirebaseClient()
    collection = 'categories'
    
    def list(self, request):
        sort_by = request.GET.get("sort-by", 'color')
        order = request.GET.get("order", 'asc')
        page = int(request.GET.get("page", 0))
        limit = int(request.GET.get("limit", 10))
        instances = self.client.all(self.collection, sort_by=sort_by, order=order, page=page, limit=limit)
        data = {x['id']: x for x in instances}
        data = {
            "data": data,
        }
        return Response(data)