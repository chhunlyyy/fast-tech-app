import 'package:dio/dio.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

class HttpApiService {
  // base_url

  var url = 'http://192.168.43.44:8000/api'; // set local host
  // var url = 'http://192.168.70.227:8000/api'; // set local host

  ///
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: 500000,
      receiveTimeout: 500000,
      headers: HttpConfig.headers,
      followRedirects: false,
      validateStatus: (status) {
        return status! < 500;
      }));

  // Singleton Declaration
  static final HttpApiService _instance = HttpApiService._internal();
  factory HttpApiService() {
    return _instance;
  }

  HttpApiService._internal() {
    // _setupInterceptors();
  }

  Dio getDio() => _dio;

  /// Handy method to make http GET request, which is a alias of [Dio.request].
  Future get(String endpoint, Map<String, dynamic>? queryParams, Options options) async {
    String urlEndpoint = await _buildUrl(endpoint);
    Response response = await _dio.get(urlEndpoint, queryParameters: queryParams, options: options);
    return response;
  }

  /// Handy method to make http POST request, which is a alias of  [Dio.request].
  Future post(String endpoint, dynamic postData, Map<String, dynamic>? queryParams, Options options) async {
    String urlEndpoint = await _buildUrl(endpoint);
    Response response = await _dio.post(urlEndpoint, data: postData, queryParameters: queryParams, options: options);
    return response;
  }

  /// Handy method to make http PUT request, which is a alias of  [Dio.request].
  Future put(String endpoint, dynamic putData, Map<String, dynamic> queryParams, Options options) async {
    String urlEndpoint = await _buildUrl(endpoint);
    Response response = await _dio.put(urlEndpoint, data: putData, queryParameters: queryParams, options: options);
    return response;
  }

  Future patch(String endpoint, dynamic putData, Map<String, dynamic> queryParams, Options options) async {
    String urlEndpoint = await _buildUrl(endpoint);
    Response response = await _dio.patch(urlEndpoint, data: putData, queryParameters: queryParams, options: options);
    return response;
  }

  /// Handy method to make http DELETE request, which is a alias of  [Dio.request].
  Future delete(String endpoint, dynamic deleteData, Map<String, dynamic> queryParams, Options options) async {
    String urlEndpoint = await _buildUrl(endpoint);
    Response response = await _dio.delete(urlEndpoint, data: deleteData, queryParameters: queryParams, options: options);
    return response;
  }

  Future<String> _buildUrl(String endPoint) async {
    return url + endPoint;
  }
}

HttpApiService httpApiService = HttpApiService();
