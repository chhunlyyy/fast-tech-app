import 'package:fast_tech_app/core/models/package_order_model.dart';
import 'package:flutter/material.dart';

class PackageOrderModelProvider with ChangeNotifier {
  List<PackageOrderModel> packageOrderModelList = [];

  void setPackageupOrderModel(List<PackageOrderModel> models) {
    packageOrderModelList = models;
    notifyListeners();
  }
}
