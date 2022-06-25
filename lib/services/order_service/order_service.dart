import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/cart_model.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

import '../http/http_api.dart';

class OrderService {
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
}

OrderService orderService = OrderService();
