import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:cardia_watch/service/utils_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:hive/hive.dart';

class LoginPageController extends GetxController {
  final UtilService utilService = UtilService();
  Duration get loginTime => const Duration(milliseconds: 5000);
  final isSuccess = false.obs;

  Future<String?> onLogin(LoginData data) {
    loginPost(data);
    return Future.delayed(loginTime).then((_) {
      if(isSuccess.value){
        return null;
      }
      return 'Login Gagal';
    });
  }

  loginPost(LoginData data) async {
    final connect = GetConnect();
    await connect.post(
        '${utilService.url}/api/auth',
        {
          'email' : data.name,
          'password' : data.password
        },
    ).then((response) async {
      if(response.statusCode == 200){
         if (Hive.isBoxOpen('token')) {
           var box = await Hive.openBox('token');
           box.add(response.body['access_token']);
         }
         if (Hive.isBoxOpen('user')) {
           var box = await Hive.openBox('user');
           box.add(response.body['user']);
         }
         isSuccess.value = true;
      }
    });
  }
}
