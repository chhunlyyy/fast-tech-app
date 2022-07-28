import 'package:cloud_firestore/cloud_firestore.dart';

class TrickerFirebaseService {
  var firebase = FirebaseFirestore.instance;
  void trickerAddNewProduct() {
    firebase.collection('NEW_PRODUCT').doc().set({'value': 1});
  }
}

TrickerFirebaseService trickerFirebaseService = TrickerFirebaseService();
