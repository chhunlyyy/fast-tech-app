import 'package:fast_tech_app/core/models/pickup_order_model.dart';
import 'package:flutter/material.dart';

class PickupOrderModelProvider with ChangeNotifier {
  List<PickupOrderModel> pickupOrderModelList = [];

  void setPickupOrderModel(List<PickupOrderModel> models) {
    pickupOrderModelList = models;
    notifyListeners();
  }
}
