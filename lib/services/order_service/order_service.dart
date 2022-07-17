import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:fast_tech_app/core/models/delivery_order_model.dart';
import 'package:fast_tech_app/core/models/package_order_model.dart';
import 'package:fast_tech_app/core/models/pickup_order_model.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

import '../http/http_api.dart';

class OrderService {
  Future<dynamic> getOrderStatistic(int userId) async {
    Map<String, dynamic> params = {'user_id': userId};
    try {
      return await httpApiService.get(HttpApi.API_ORDER_STATISTIC, params, Options(headers: HttpConfig.headers)).then((value) {
        return value;
      });
    } catch (e) {
      return [];
    }
  }

  Future<String> updateOrderStatus(String orderId, int status, int isPackage) async {
    try {
      Map<String, dynamic> params = {'order_id': orderId, 'status': status, 'is_package': isPackage};
      return await httpApiService.post(HttpApi.API_ORDER_STATUS, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<List<DeliveryOrderModel>> getDeliveryOrder(
    int userID,
    bool isDone, {
    int pageSize = 10,
    int pageIndex = 0,
  }) async {
    try {
      Map<String, dynamic> params = {'user_id': userID, 'is_done': isDone ? 1 : 0, 'pageSize': pageSize, 'pageIndex': pageIndex};
      return await httpApiService.get(HttpApi.API_DELIVERY_ORDER, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<DeliveryOrderModel>.from(value.data.map((x) => DeliveryOrderModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<PackageOrderModel>> getPackageOrder(
    int userID,
    bool isDone, {
    int pageSize = 10,
    int pageIndex = 0,
  }) async {
    try {
      Map<String, dynamic> params = {'user_id': userID, 'is_done': isDone ? 1 : 0, 'pageSize': pageSize, 'pageIndex': pageIndex};
      return await httpApiService.get(HttpApi.API_PACKAGE_ORDER, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<PackageOrderModel>.from(value.data.map((x) => PackageOrderModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<PickupOrderModel>> getPickupOrder(
    int userID,
    bool isDone, {
    int pageSize = 10,
    int pageIndex = 0,
  }) async {
    try {
      Map<String, dynamic> params = {'user_id': userID, 'is_done': isDone ? 1 : 0, 'pageSize': pageSize, 'pageIndex': pageIndex};
      return await httpApiService.get(HttpApi.API_PICKUP_ORDER, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<PickupOrderModel>.from(value.data.map((x) => PickupOrderModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<String> packageOrder(Map<String, dynamic> params) async {
    try {
      return await httpApiService.post(HttpApi.API_PACKAGE_ORDER, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> deliveryOrder(Map<String, dynamic> params) async {
    try {
      return await httpApiService.post(HttpApi.API_DELIVERY_ORDER, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> order(Map<String, dynamic> params) async {
    try {
      return await httpApiService.post(HttpApi.API_ORDER, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<String> addToCart(int productId, int userId, int qty, int colorId) async {
    try {
      Map<String, dynamic> params = {
        'product_id': productId,
        'user_id': userId,
        'qty': qty,
        'color_id': colorId,
      };
      return await httpApiService.post(HttpApi.API_CART, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '400';
    }
  }

  Future<List<CartModel>> getProductInCart(int userID) async {
    try {
      Map<String, dynamic> params = {'user_id': userID};
      return await httpApiService.get(HttpApi.API_CART, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<CartModel>.from(value.data.map((x) => CartModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<String> removeCart(int cartId) async {
    try {
      Map<String, dynamic> params = {'id': cartId};
      return await httpApiService.post(HttpApi.API_REMOVE_CART, null, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data[0]['status'];
      });
    } catch (e) {
      return '400';
    }
  }
}

OrderService orderService = OrderService();
