import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
  }
}
