import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenHelper {
  SharedPreferences pref;
  PackageInfo packageInfo;

  TokenHelper._(this.pref, this.packageInfo);

  static TokenHelper? _instance;
  static TokenHelper getInstance() {
    return _instance!;
  }

  static void init(SharedPreferences pref, packageInfo) {
    _instance = TokenHelper._(pref, packageInfo);
  }

  bool isFirstLogin() {
    bool isFirstLogin = pref.getBool("isFirstLogin") == null;
    return isFirstLogin;
  }

  void setLogin() {
    pref.setBool('isFirstLogin', false);
  }

  String get getLanguageCode {
    return pref.getString('languageCode')!;
  }

  void setLanguageCode(code) {
    pref.setString('languageCode', code);
  }
}
