import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:flutter/material.dart';

class UserModelProvider with ChangeNotifier {
  UserModel? userModel;

  void setUserModel(UserModel model) {
    userModel = model;
    notifyListeners();
  }
}
