import 'package:cloud_firestore/cloud_firestore.dart';

class TrickerFirebaseService {
  var firebase = FirebaseFirestore.instance;
  void trickerAddNewProduct() {
    firebase.collection('products').doc().set({'value': 1});
  }

  void trickerAddOrder(String userName, String phone) {
    firebase.collection('orders').doc().set({
      'name': userName,
      'phone': phone,
    });
  }
}

TrickerFirebaseService trickerFirebaseService = TrickerFirebaseService();
