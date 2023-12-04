import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter

from django.conf import settings


class FirebaseClient:

    def __init__(self):
        try:
            firebase_admin.get_app()
        except ValueError:
            firebase_admin.initialize_app(
                credentials.Certificate(settings.FIREBASE_ADMIN_CERT)
            )

        self._db = firestore.client()
        self._collection = self._db.collection(u'expenses')

    def create(self, collection, data):
        """Create todo in firestore database"""
        doc_ref = self._db.collection(collection).document()
        doc_ref.set(data)

    def update(self, collection, id, data):
        """Update todo on firestore database using document id"""
        doc_ref = self._db.collection(collection).document(id)
        doc_ref.update(data)

    def delete_by_id(self, collection, id):
        """Delete todo on firestore database using document id"""
        self._db.collection(collection).document(id).delete()

    def get_by_id(self, collection, id):
        """Get todo on firestore database using document id"""
        doc_ref = self._db.collection(collection).document(id)
        doc = doc_ref.get()

        if doc.exists:
            return {**doc.to_dict(), "id": doc.id}
        return

    def all(self, collection, sort_by, order, page, limit):
        """Get all todo from firestore database"""
        order = firestore.Query.ASCENDING if order == 'asc' else firestore.Query.DESCENDING
        docs = self._db.collection(collection).order_by(sort_by, direction=order).offset(page).limit(limit).stream()
        return [{**doc.to_dict(), "id": doc.id} for doc in docs]

    def filter(self, collection, sort_by, order, page, limit, filters):
        """Filter todo using conditions on firestore database"""
        order = firestore.Query.ASCENDING if order == 'asc' else firestore.Query.DESCENDING
        docs = docs = self._db.collection(collection).order_by(sort_by, direction=order).offset(page).limit(limit)
        if filters:
            for filter in filters:
                docs = docs.where(filter=FieldFilter(filter[0], filter[1], filter[2]))
        
        docs = docs.stream()
        return [{**doc.to_dict(), "id": doc.id} for doc in docs]
    
    def count(self, collection):
        """Count instances in firestore database"""
        count = self._db.collection(collection).count().get()[0][0].value
        print(count)
        return count
