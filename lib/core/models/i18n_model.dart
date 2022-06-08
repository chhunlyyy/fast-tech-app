import 'package:flutter/material.dart';

class I18nModel with ChangeNotifier {
  static final List<String> supportedLanguagesCodes = ["en", "km"];
  late String languageCode = "km";

  void setLanguageCode(String code) {
    languageCode = code;
    notifyListeners();
  }
}
