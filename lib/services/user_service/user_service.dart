import 'package:dio/dio.dart';
import 'package:fast_tech_app/core/models/user_model.dart';
import 'package:fast_tech_app/core/provider/user_role_provider.dart';
import 'package:fast_tech_app/services/firebase_service/firebase_service.dart';
import 'package:fast_tech_app/services/http/http_api.dart';
import 'package:fast_tech_app/services/http/http_api_service.dart';
import 'package:fast_tech_app/services/http/http_config.dart';
import 'package:fast_tech_app/services/tricker_firebase_service/tricker_firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> checkAdmin(BuildContext context, String phoneNumber) async {
    Map<String, dynamic> params = {'phone': phoneNumber};
    await httpApiService.post(HttpApi.API_ADMIN_USER, params, null, Options(headers: HttpConfig.headers)).then((value) {
      if (value.data['status'] == '200') {
        Provider.of<UserRoleProvider>(context, listen: false).changeAdmin(false);
        Provider.of<UserRoleProvider>(context, listen: false).changeSuperAdmin(true);
        firebaseNotifications.subscribeTopic('admin');
      } else if (value.data['status'] == '201') {
        Provider.of<UserRoleProvider>(context, listen: false).changeAdmin(true);
        Provider.of<UserRoleProvider>(context, listen: false).changeSuperAdmin(false);
        firebaseNotifications.subscribeTopic('admin');
      } else {
        Provider.of<UserRoleProvider>(context, listen: false).changeAdmin(false);
        Provider.of<UserRoleProvider>(context, listen: false).changeSuperAdmin(false);
      }
    });
  }

  Future<void> getToken(String phoneNumber, int status) async {
    Map<String, dynamic> params = {'phone': phoneNumber};
    await httpApiService.get(HttpApi.API_TOKEN, params, Options(headers: HttpConfig.headers)).then((value) {
      trickerFirebaseService.trickerChangeOrderStatus(value.data['token'].toString(), status.toString());
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
