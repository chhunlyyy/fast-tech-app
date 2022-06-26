import 'package:fast_tech_app/core/models/delivery_order_model.dart';
import 'package:flutter/material.dart';

class DeliveryOrderModelProvider with ChangeNotifier {
  List<DeliveryOrderModel> deliveryOrderModelList = [];

  void setDeliveryModel(List<DeliveryOrderModel> models) {
    deliveryOrderModelList = models;
    notifyListeners();
  }
}
