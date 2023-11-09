import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/controllers/login_controller.dart';
import 'package:msku2209b/screens/home.dart';

class RootWrapper extends GetView<AuthController> {
  const RootWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: controller.user.value,
      stream: controller.user.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          EasyLoading.dismiss();
          Get.delete<LoginController>();
          return const HomeScreen();
        } else if (snapshot.hasError) {
          debugPrint("FIREBASE ERROR : ${snapshot.error}");
        }
        // return const LoginPage();
        return const HomeScreen();
      },
    );
  }
}
