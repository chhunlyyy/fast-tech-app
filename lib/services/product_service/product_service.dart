import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/services/http/http_api.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

class ProductService {
  Future<List<ProductModel>> getAllCamera({
    int pageSize = 10,
    int pageIndex = 0,
  }) async {
    try {
      Map<String, dynamic> params = {
        'pageSize': pageSize,
        'pageIndex': pageIndex,
      };
      return await httpApiService.get(HttpApi.API_CAMERA, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> getAllProduct({
    int pageSize = 10,
    int pageIndex = 0,
    int isGetCameraProduct = 0,
    int isGetElectronicProduct = 0,
    int isMinQtyOne = 1,
  }) async {
    try {
      Map<String, dynamic> params = {
        'pageSize': pageSize,
        'pageIndex': pageIndex,
        'isGetCameraProduct': isGetCameraProduct,
        'isGetElectronicProduct': isGetElectronicProduct,
        'isMinQtyOne': isMinQtyOne,
      };
      return await httpApiService.get(HttpApi.API_PRODUCT, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<ProductModel>> search({
    int pageSize = 10,
    int pageIndex = 0,
    String productName = '',
  }) async {
    try {
      Map<String, dynamic> params = {
        'pageSize': pageSize,
        'pageIndex': pageIndex,
        'product_name': productName,
      };
      return await httpApiService.get(HttpApi.API_SEARCH, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }
}

ProductService productService = ProductService();
