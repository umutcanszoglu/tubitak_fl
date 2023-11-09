import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/controllers/login_controller.dart';
import 'package:msku2209b/widgets/buttons/back_button.dart';
import 'package:msku2209b/widgets/buttons/big_button.dart';
import 'package:msku2209b/widgets/custom_text_field.dart';

class SignUp extends GetView<AuthController> {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController(false));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Sign Up"),
        titleSpacing: 0,
        leading: const CustomBackButton(),
        elevation: 0,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.asset(
                      "assets/logo.png",
                      height: Get.height / 3,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      prefixIcon: const Icon(FontAwesomeIcons.solidEnvelope),
                      validator: controller.validators["email"]!.validFn,
                      controller: controller.validators["email"]!.controller,
                      labelText: "Email",
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.obscureText.value =
                                !controller.obscureText.value;
                          },
                          icon: controller.obscureText.value
                              ? const Icon(FontAwesomeIcons.eye)
                              : const Icon(FontAwesomeIcons.eyeSlash),
                        ),
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        obscureText: controller.obscureText.value,
                        validator: controller.validators["password"]!.validFn,
                        controller:
                            controller.validators["password"]!.controller,
                        labelText: "Password",
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        obscureText: controller.obscureText.value,
                        validator: controller.passwordAgain.value,
                        controller: controller
                            .validators["passwordConfirm"]!.controller,
                        labelText: "Password Again",
                      ),
                    ),
                    const SizedBox(height: 32),
                    BigButton(
                      onPressed: controller.signUp,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.person),
                          SizedBox(width: 8),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
