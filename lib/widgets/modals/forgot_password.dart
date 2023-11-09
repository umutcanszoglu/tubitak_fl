import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/theme.dart';
import 'package:msku2209b/widgets/buttons/big_button.dart';
import 'package:msku2209b/widgets/custom_text_field.dart';

class ForgotPasswordModal extends GetView<AuthController> {
  ForgotPasswordModal({Key? key}) : super(key: key);

  final email = "".obs;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Center(
        child: Text("Forgot Password",
            style: TextStyle(fontSize: 21, letterSpacing: 1.1)),
      ),
      elevation: 10,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "You can reset send email",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            onChanged: (text) {
              email.value = text.trim();
            },
            validator: (text) {
              if (!GetUtils.isEmail((text ?? "").trim())) {
                return "Invalid Email";
              }
              return null;
            },
            labelText: "Your Email",
          ),
        ],
      ),
      actions: [
        Obx(() => BigButton(
              diasbledColor: CColors.iconColor,
              color: CColors.mainColor,
              onPressed: email.value.isEmail
                  ? () => Get.back(result: email.value)
                  : null,
              child: const Text(
                "Send",
                style: TextStyle(color: CColors.white),
              ),
            ))
      ],
    );
  }
}
