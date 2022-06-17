import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/services/http/http_api.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';

class UserService {
  Future<UserModel?> getUser({
    String token = '',
  }) async {
    try {
      Map<String, dynamic> params = {
        'token': token,
      };

      return await httpApiService.get(HttpApi.API_USER, params, Options(headers: HttpConfig.headers)).then((value) {
        return value.data.isEmpty ? null : UserModel.fromJson(value.data[0]);
      });
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> register({Map<String, dynamic> params = const {}}) async {
    try {
      return await httpApiService.post(HttpApi.API_REGISTER, null, params, Options(headers: HttpConfig.headers)).then((value) {
        if (value.data[0]["status"] == "200") {
          return {"user": value.data[0]["user"][0], "status": value.data[0]["status"]};
        } else {
          return {"status": value.data[0]["status"]};
        }
      });
    } catch (e) {
      return {'status': "400"};
    }
  }
}

UserService userService = UserService();
