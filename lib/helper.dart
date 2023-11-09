import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Helper {
  static String getLastText(String text) => text.split(".").last;

  static void showToast(String msg) => EasyLoading.showToast(msg,
      toastPosition: EasyLoadingToastPosition.bottom);

  static void showErrorToast(String msg) => EasyLoading.showError(msg);
}

class ValidEditingController {
  TextEditingController controller = TextEditingController();
  String? Function(String? txt) validFn;
  ValidEditingController({
    required this.validFn,
  });

  void dispose() => controller.dispose();
}
