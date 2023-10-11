import 'package:cardia_watch/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

import '../controller/login_page_controller.dart';
import 'home_page.dart';

class LoginPage extends GetView<LoginPageController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Cardia Watch',
      onLogin: controller.onLogin,
      hideForgotPasswordButton: true,
      onSubmitAnimationCompleted: () {
        Get.to(() => const HomePage());
      },
      onRecoverPassword: (_) => Future.value(null),
    );
  }
}
