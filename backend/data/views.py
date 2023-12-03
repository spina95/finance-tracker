from rest_framework.exceptions import NotFound

from data.firebase import FirebaseClient
from data.serializers import TodoSerializer
from rest_framework import viewsets, status
from rest_framework.response import Response


class ExpensesViewSet(viewsets.ViewSet):
    client = FirebaseClient()
    collection = 'expenses'

    def create(self, request, *args, **kwargs):
        serializer = TodoSerializer(data=request.data)
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
        instances = self.client.all(self.collection, sort_by=sort_by, order=order, page=page, limit=limit)
        count = self.client.count(self.collection)
        serializer = TodoSerializer(instances, many=True)
        data = {
            "data": serializer.data,
            "total_count": count
        }
        return Response(data)

    def retrieve(self, request, pk=None):
        todo = self.client.get_by_id(self.collection, pk)

        if todo:
            serializer = TodoSerializer(todo)
            return Response(serializer.data)

        raise NotFound(detail="Todo Not Found", code=404)

    def destroy(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        self.client.delete_by_id(self.collection, pk)
        return Response(status=status.HTTP_204_NO_CONTENT)

    def update(self, request, *args, **kwargs):
        pk = kwargs.get('pk')
        serializer = TodoSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        self.client.update(self.collection, pk, serializer.data)

        return Response(serializer.data)
