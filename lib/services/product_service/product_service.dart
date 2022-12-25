import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/camera_type_model.dart';
import 'package:fast_tech_app/core/models/product_insert_model.dart';
import 'package:fast_tech_app/core/models/product_model.dart';
import 'package:fast_tech_app/services/http/http_api.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';
import 'package:path/path.dart';

class ProductService {
  Future<String> deleteDetail(String id) async {
    Map<String, dynamic> postData = {
      'id': id,
    };

    try {
      return await httpApiService.delete(HttpApi.API_DELETE_DETAIL, postData, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> deleteColor(String id) async {
    Map<String, dynamic> postData = {
      'id': id,
    };

    try {
      return await httpApiService.delete(HttpApi.API_DELETE_COLOR, postData, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> deleteImage(String id) async {
    Map<String, dynamic> postData = {
      'id': id,
    };

    try {
      return await httpApiService.delete(HttpApi.API_DELETE_IMAGE, postData, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '402';
    }
  }

  Future<String> delete(String idRef) async {
    Map<String, dynamic> postData = {
      'id_ref': idRef,
    };

    try {
      return await httpApiService.delete(HttpApi.API_DELETE, postData, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> insertImage(List<File> files, String imageIdRef) async {
    String result = '';
    Map<String, dynamic> postData = {
      'product_id_ref': imageIdRef,
    };

    if (files.isNotEmpty) {
      for (File file in files) {
        postData['image'] = await MultipartFile.fromFile(file.path, filename: basename(file.path));
        try {
          await httpApiService.post(HttpApi.API_IMAGE, FormData.fromMap(postData), null, Options(headers: HttpConfig.headers)).then((value) {
            result = value.data['status'];

            result;
          });
        } catch (e) {
          result = '402';
        }
      }
    }

    return result;
  }

  Future<String> insertDetail(String? id, String idRef, String detail, String descs, int isEdit) async {
    try {
      Map<String, dynamic> params = {'product_id_ref': idRef, 'detail': detail, 'descs': descs, 'id': id, 'is_edit': isEdit};
      return await httpApiService.post(HttpApi.API_DETAIL, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> insertColor(int? id, String idRef, String color, String colorCode, int isEdit) async {
    try {
      Map<String, dynamic> params = {
        'id': id,
        'product_id_ref': idRef,
        'color': color,
        'color_code': colorCode,
        'is_edit': isEdit,
      };
      return await httpApiService.post(HttpApi.API_COLOR, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> insertProduct(int isEdit, ProductInsertModel productInsertModel) async {
    try {
      Map<String, dynamic> params = {
        'is_edit': isEdit,
        'id_ref': productInsertModel.id_ref,
        'name': productInsertModel.name,
        'price': productInsertModel.price,
        'discount': productInsertModel.discount,
        'price_after_discount': productInsertModel.price_after_discount,
        'is_warranty': productInsertModel.is_warranty,
        'warranty_period': productInsertModel.warranty_period,
        'min_qty': productInsertModel.min_qty,
        'is_camera': productInsertModel.is_camera,
        'camera_type_id': productInsertModel.camera_type_id,
      };
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

  Future<ProductModel> getProductById(int id) async {
    Map<String, dynamic> params = {
      'id': id,
    };
    return await httpApiService.get(HttpApi.API_PRODUCT_BY_ID, params, Options(headers: HttpConfig.headers)).then((value) {
      return ProductModel.fromJson(value.data);
    });
  }

  Future<List<ProductModel>> search({
    int pageSize = 10,
    int pageIndex = 0,
    String productName = '',
    String startPrice = '',
    String toPrice = '',
  }) async {
    try {
      Map<String, dynamic> params = {
        'pageSize': pageSize,
        'pageIndex': pageIndex,
        'product_name': productName,
        'start_price': startPrice,
        'to_price': toPrice,
      };
      return await httpApiService.get(HttpApi.API_SEARCH, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<ProductModel>.from(value.data.map((x) => ProductModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<CameraTypeModel>> getCameraTypeModels() async {
    try {
      return await httpApiService.get(HttpApi.API_CAMERAY_TYPE, null, Options(headers: HttpConfig.headers)).then((value) {
        return List<CameraTypeModel>.from(value.data.map((x) => CameraTypeModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<String> insertCameraType(String type) async {
    try {
      Map<String, dynamic> params = {'type': type};
      return await httpApiService.post(HttpApi.API_CAMERAY_TYPE, params, null, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }
}

ProductService productService = ProductService();
