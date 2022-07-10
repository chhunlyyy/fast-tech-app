import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/public/public_variable.dart';
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

  Future<Map<String, dynamic>> login({Map<String, dynamic> params = const {}}) async {
    try {
      return await httpApiService.post(HttpApi.API_LOGIN, null, params, Options(headers: HttpConfig.headers)).then((value) {
        if (value.data[0]["status"] == "200") {
          return {"user": value.data[0]["user"], "status": value.data[0]["status"]};
        } else {
          return {"status": value.data[0]["status"]};
        }
      });
    } catch (e) {
      return {'status': "400"};
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

  Future<void> checkAdmin(String phoneNumber) async {
    Map<String, dynamic> params = {'phone': phoneNumber};
    await httpApiService.post(HttpApi.API_ADMIN_USER, params, null, Options(headers: HttpConfig.headers)).then((value) {
      if (value.data['status'] == '200') {
        IS_ADMIN = false;
        IS_SUPER_ADMIN = true;
      } else if (value.data['status'] == '201') {
        IS_ADMIN = true;
        IS_SUPER_ADMIN = false;
      } else {
        IS_ADMIN = false;
        IS_SUPER_ADMIN = false;
      }
    });
  }

  Future<void> logout(String phoneNumber, String token) async {
    Map<String, dynamic> params = {'phone': phoneNumber, 'token': token};
    await httpApiService.post(HttpApi.API_LOG_OUT, params, null, Options(headers: HttpConfig.headers));
  }

  Future<List<UserModel>> getAllAdminUser() async {
    return await httpApiService.get(HttpApi.API_ADMIN_USER, null, Options(headers: HttpConfig.headers)).then((value) {
      return List<UserModel>.from(value.data.map((x) => UserModel.fromJson(x)));
    });
  }

  Future<String> addRole(String phoneNumber, String role) async {
    Map<String, dynamic> params = {'phone': phoneNumber, 'role': role};
    return await httpApiService.post(HttpApi.API_ROLE, params, null, Options(headers: HttpConfig.headers)).then((value) {
      return value.data['status'];
    });
  }

  Future<String> deleteRole(String phoneNumber) async {
    Map<String, dynamic> params = {'phone': phoneNumber};
    return await httpApiService.delete(HttpApi.API_ROLE, params, {}, Options(headers: HttpConfig.headers)).then((value) {
      return value.data['status'];
    });
  }
}

UserService userService = UserService();
