import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:msku2209b/controllers/data_controller.dart';

class SetDuration extends HookWidget {
  const SetDuration({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataController>();
    final duration =
        useTextEditingController(text: controller.duration.toString());

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("Set Api Duration"),
      content: TextField(
        controller: duration,
        decoration: const InputDecoration(
          hintText: "Duration",
          hintStyle: TextStyle(fontSize: 16),
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 12),
          prefixIcon: Icon(
            FontAwesomeIcons.stopwatch,
            size: 20,
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            try {
              final text = duration.text.trim();
              final val = int.parse(text);
              final value = max(val, 2);

              controller.changeDuration(value);
              final box = Hive.box('config');

              await box.put('duration', text);
            } catch (e) {
              EasyLoading.showError("Invalid value");
            }
            Get.back();
          },
          child: const Text("Okey"),
        ),
      ],
    );
  }
}
