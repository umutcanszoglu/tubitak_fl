import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/controllers/data_controller.dart';
import 'package:msku2209b/helper.dart';
import 'package:msku2209b/widgets/buttons/back_button.dart';

class DrawerMenu extends GetView<DataController> {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: const CustomBackButton(),
        title: const Center(
          child: Text(
            "Profile",
            style: TextStyle(fontSize: 17),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.powerOff),
            onPressed: authController.signOut,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Obx(
              () => _buildConnectionStateText(
                  Helper.getLastText(controller.currentState.value.toString())),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: SingleChildScrollView(
                      child: Text(controller.getHistoryText),
                    ),
                  ),
                )),
            Text(authController.profile.value?.mail ?? ""),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStateText(String status) => Row(
        children: <Widget>[
          Expanded(
            child: Container(
                color: Colors.deepOrangeAccent,
                child: Text(status, textAlign: TextAlign.center)),
          ),
        ],
      );
}
