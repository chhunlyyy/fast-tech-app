import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:flutter/material.dart';

class CartModelProvider with ChangeNotifier {
  List<CartModel> cartModelList = [];

  void setCartModel(List<CartModel> models) {
    cartModelList = models;
    notifyListeners();
  }
}
