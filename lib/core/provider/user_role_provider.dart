import 'package:flutter/material.dart';

class UserRoleProvider with ChangeNotifier {
  bool isAdmin = false;
  bool isSuperAdmin = false;

  void changeAdmin(bool isAdmin) {
    this.isAdmin = isAdmin;
    notifyListeners();
  }

  void changeSuperAdmin(bool isSuperAdmin) {
    this.isSuperAdmin = isSuperAdmin;
    notifyListeners();
  }
}
