import 'package:cloud_firestore/cloud_firestore.dart';

class UserService{
  Firestore _firestore = Firestore.instance;

  

  Future<List<DocumentSnapshot>> getUsers()
  {
   return _firestore.collection('users').getDocuments().then((snapshot)
   {
     return snapshot.documents;
   }); 
  }

  Future<List<DocumentSnapshot>> getProducts()
  {
   return _firestore.collection('products').getDocuments().then((snapshot)
   {
     return snapshot.documents;
   }); 
  }

  Future<List<DocumentSnapshot>> getOrders()
  {
   return _firestore.collection('orders').getDocuments().then((snapshot)
   {
     return snapshot.documents;
   }); 
  }

}