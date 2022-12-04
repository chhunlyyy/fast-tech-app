class HttpConfig {
  static Map<String, String> headers = {'Content-Type': 'application/x-www-form-urlencoded', 'Cache-Control': 'no-cache'};

  static const String CLIENT_CODE = "CLIENT-CODE";
  static const String CLIENT_NAME = "CLIENT-NAME";
  static const String CLIENT_NAME_EN = "CLIENT-NAME-EN";
  static const String CLIENT_SECRET = "CLIENT-SECRET";
  static const String CLIENT_BASE_URL = "http://192.168.0.21:8000"; // local host
  static const String CLIENT_LOGO_URL = "CLIENT-LOGO-URL";
  static const String CLIENT_BACKGROUND_MOBILE_URL = "CLIENT-BACKGROUND-MOBILE-URL";
  static const String CLIENT_BACKGROUND_WEB_URL = "CLIENT-BACKGROUND-WEB-URL";
  static const String CLIENT_PRIMARY_COLOR = "CLIENT-PRIMARY-COLOR";
  static const String CLIENT_GATEWAY_CODE = "CLIENT-GATEWAY-CODE";

  Map<String, dynamic> configPreference = {};

  static final HttpConfig _instance = HttpConfig();

  static HttpConfig getInstance() {
    return _instance;
  }

  void setConfigPreference(String clientCode, Map<String, dynamic> pConfigPreference) {
    configPreference = pConfigPreference;
  }

  String getBaseUrl() {
    String baseUrl = configPreference[CLIENT_BASE_URL];
    return baseUrl;
  }

  String getBaseApiClientUrl() {
    String baseUrl = configPreference[CLIENT_BASE_URL];

    return baseUrl + "/api";
  }

  String getPrefixCode(String fullText) {
    return configPreference[HttpConfig.CLIENT_GATEWAY_CODE];
  }
}
