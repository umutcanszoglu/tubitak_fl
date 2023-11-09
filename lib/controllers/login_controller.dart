import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/helper.dart';

class LoginController extends GetxController {
  LoginController(bool isLogin) {
    validators["password"]!.controller.addListener(() {
      passwordAgain.value = (p0) {
        if (validators["password"]!.controller.text != p0) {
          return "Passwords is not same";
        }
        return null;
      };
    });
  }

  Rxn<String? Function(String?)?> passwordAgain =
      Rxn<String? Function(String?)?>();

  Map<String, ValidEditingController> validators = {
    "email": ValidEditingController(
      validFn: (txt) {
        if (!GetUtils.isEmail((txt ?? "").trim())) {
          return "Invalid Email";
        }
        return null;
      },
    ),
    "password": ValidEditingController(validFn: (txt) {
      if (!GetUtils.isLengthGreaterOrEqual(txt ?? "", 6)) {
        return "Invalid Password";
      }
      return null;
    }),
    "passwordConfirm": ValidEditingController(validFn: (txt) {
      return null;
    }),
  };

  String? isValid(bool isLogin) {
    for (final validator in validators.entries) {
      if (isLogin && validator.key == "passwordConfirm") continue;
      final err = validator.value.validFn(validator.value.controller.text);
      if (err != null) {
        return err;
      }
    }
    return null;
  }

  final obscureText = true.obs;
  @override
  void onClose() {
    for (final validator in validators.values) {
      validator.controller.dispose();
    }
    super.onClose();
  }

  void logIn() {
    final err = isValid(true);
    if (err != null) {
      Helper.showErrorToast(err);
    } else {
      Get.find<AuthController>().signIn('emailSignIn',
          email: validators["email"]!.controller.text.trim(),
          password: validators["password"]!.controller.text);
    }
  }

  Future<void> signUp() async {
    final err = isValid(false);
    if (err != null) {
      Helper.showErrorToast(err);
    } else {
      Get.find<AuthController>().signIn('emailSignUp',
          email: validators["email"]!.controller.text.trim(),
          password: validators["password"]!.controller.text);
    }
  }

  void get toggleObscureIcon => obscureText.value = !obscureText.value;
}
