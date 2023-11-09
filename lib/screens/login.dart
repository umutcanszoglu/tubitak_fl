import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/controllers/login_controller.dart';
import 'package:msku2209b/helper.dart';
import 'package:msku2209b/screens/sign_up.dart';
import 'package:msku2209b/theme.dart';
import 'package:msku2209b/widgets/buttons/big_button.dart';
import 'package:msku2209b/widgets/custom_ink_well.dart';
import 'package:msku2209b/widgets/custom_text_field.dart';
import 'package:msku2209b/widgets/modals/forgot_password.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginController = Get.put(LoginController(true));

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Log In"),
        titleSpacing: 0,
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
                      controller:
                          loginController.validators["email"]!.controller,
                      validator: loginController.validators["email"]!.validFn,
                      prefixIcon: const Icon(FontAwesomeIcons.solidEnvelope),
                      labelText: "Email",
                    ),
                    const SizedBox(height: 16),
                    Obx(
                      () => CustomTextField(
                        validator:
                            loginController.validators["password"]!.validFn,
                        controller:
                            loginController.validators["password"]!.controller,
                        obscureText: loginController.obscureText.value,
                        prefixIcon: const Icon(FontAwesomeIcons.lock),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => loginController.toggleObscureIcon,
                          icon: loginController.obscureText.value
                              ? const Icon(
                                  FontAwesomeIcons.eye,
                                  color: CColors.iconColor,
                                )
                              : const Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  color: CColors.iconColor,
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomInkWell(
                          onTap: () =>
                              Get.find<AuthController>().signIn("google"),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  width: 2, color: CColors.mainColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(
                                  FontAwesomeIcons.google,
                                  color: CColors.mainColor,
                                ),
                                SizedBox(width: 8),
                                Text("Sign In Google"),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result =
                                await Get.dialog(ForgotPasswordModal());
                            if (result != null) {
                              final sent =
                                  await controller.resetPassword(result);
                              if (sent) {
                                Helper.showToast("Password reset link send");
                              } else {
                                Helper.showErrorToast(
                                    "Password reset link not send");
                              }
                            }
                          },
                          child: const Text("Forgot Password ?"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BigButton(
                        onPressed: loginController.logIn,
                        color: CColors.mainColor,
                        child: const Text("Log In",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 32),
                    TextButton(
                      onPressed: () => Get.to(const SignUp()),
                      child: const Text("Do you not have a account ?"),
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
