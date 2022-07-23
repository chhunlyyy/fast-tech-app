import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/product_insert_model.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/services/http/http_api.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';
import 'package:path/path.dart';

class ProductService {
  Future<String> insertImage(List<File> files, String imageIdRef) async {
    String result = '';
    Map<String, dynamic> postData = {
      'product_id_ref': imageIdRef,
    };

    if (files.isNotEmpty) {
      for (File file in files) {
        postData['image'] = await MultipartFile.fromFile(file.path, filename: basename(file.path));
        try {
          return await httpApiService.post(HttpApi.API_IMAGE, FormData.fromMap(postData), null, Options(headers: HttpConfig.headers)).then((value) {
            result = value.data['status'];

            return result;
          });
        } catch (e) {
          result = '402';
        }
      }
    }

    return result;
  }

  Future<String> insertDetail(String idRef, String detail, String descs) async {
    try {
      Map<String, dynamic> params = {
        'product_id_ref': idRef,
        'detail': detail,
        'descs': descs,
      };
      return await httpApiService.post(HttpApi.API_DETAIL, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> insertColor(String idRef, String color, String colorCode) async {
    try {
      Map<String, dynamic> params = {
        'product_id_ref': idRef,
        'color': color,
        'color_code': colorCode,
      };
      return await httpApiService.post(HttpApi.API_COLOR, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> insertProduct(ProductInsertModel productInsertModel) async {
    try {
      Map<String, dynamic> params = {
        'id_ref': productInsertModel.id_ref,
        'name': productInsertModel.name,
        'price': productInsertModel.price,
        'discount': productInsertModel.discount,
        'price_after_discount': productInsertModel.price_after_discount,
        'is_warranty': productInsertModel.is_warranty,
        'warranty_period': productInsertModel.warranty_period,
        'min_qty': productInsertModel.min_qty,
        'is_camera': productInsertModel.is_camera,
      };
      print(params);
      return await httpApiService.post(HttpApi.API_PRODUCT, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

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
