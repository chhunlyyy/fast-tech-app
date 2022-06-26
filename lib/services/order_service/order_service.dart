import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:fast_tech_app/core/models/delivery_order_model.dart';
import 'package:fast_tech_app/core/models/pickup_order_model.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

import '../http/http_api.dart';

class OrderService {
  Future<List<DeliveryOrderModel>> getDeliveryOrder(int userID) async {
    try {
      Map<String, dynamic> params = {'user_id': userID};
      return await httpApiService.get(HttpApi.API_DELIVERY_ORDER, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<DeliveryOrderModel>.from(value.data.map((x) => DeliveryOrderModel.fromJson(x)));
      });
    } catch (e) {
      return [];
    }
  }

  Future<List<PickupOrderModel>> getPickupOrder(int userID) async {
    try {
      Map<String, dynamic> params = {'user_id': userID};
      return await httpApiService.get(HttpApi.API_PICKUP_ORDER, params, Options(headers: HttpConfig.headers)).then((value) {
        return List<PickupOrderModel>.from(value.data.map((x) => PickupOrderModel.fromJson(x)));
      });
    } catch (e) {
      return [];
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
