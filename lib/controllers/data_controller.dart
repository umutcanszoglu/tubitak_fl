import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:msku2209b/const.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/extensions.dart';
import 'package:msku2209b/helper.dart';
import 'package:msku2209b/models/data.dart';
import 'package:msku2209b/services/api.dart';
import '../mqtt/mqtt_manager.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }

class DataController extends GetxController {
  static DataController get to => Get.find();

  final _receivedText = ''.obs;
  final _historyText = ''.obs;

  void setReceivedText(String text) {
    _receivedText.value = text;
    _historyText.value = _historyText + '\n' + _receivedText.value;
  }

  String get getReceivedText => _receivedText.value;
  String get getHistoryText => _historyText.value;

  final data = <String, RxDouble>{}.obs;
  final anims = <String, AnimationController>{};
  final fanStatus = {"Fan1": true.obs, "Fan2": true.obs};
  final jsonData = {}.obs;
  String hostText = "";
  String topicText = "";

  late MQTTManager manager;

  final isLoading = true.obs;
  final apiIsOpen = true.obs;
  final currentState = MQTTAppConnectionState.disconnected.obs;

  final duration = 5.obs;
  late Timer timer;

  @override
  void onInit() async {
    ever(data, (_) {
      startTimer;
      getData;
    });

    //Burada okuma işlemi yapılacak.
    configureAndConnect();

    final box = Hive.box('config');

    final time = await box.get('duration');
    if (time != null) {
      duration.value = int.parse(time);
    }

    getData;
    isLoading.value = false;

    super.onInit();
  }

  @override
  void onClose() {
    timer.cancel();
    manager.disconnect();
    super.onClose();
  }

  void get getData {
    if (apiIsOpen.value && data.isNotEmpty) {
      anims["%Fan1"]?.animateTo(data["%Fan1"]!.value / 100);
      anims["%Fan2"]?.animateTo(data["%Fan2"]!.value / 100);

      final items = data.entries.map((e) => {e.key: e.value.value});

      if (AuthController.to.profile.value != null) {
        final data =
            Data(date: DateTime.now(), items: items.map((e) => e).toList());
        Api.setData(data);
      }
    }
  }

  void get startTimer => timer =
      Timer.periodic(Duration(seconds: duration.value), (timer) => getData);

  String convertExt(String text, RxDouble value) {
    final val = value.toString();
    if (Const.cList.contains(text)) return val.convertC;
    if (Const.pList.contains(text)) return val.convertP;
    if (Const.msList.contains(text)) return val.convertMS;
    if (Const.barList.contains(text)) return val.convertBar;
    if (Const.gsList.contains(text)) return val.convertGs;
    if (Const.ddList.contains(text)) return val.convertdd;
    if (Const.wList.contains(text)) return val.convertW;
    return "$val ITH";
  }

  void changeDuration(int time) {
    timer.cancel();
    duration.value = time;
    startTimer;
    Helper.showToast("Duration is changed.");
  }

  void changeApiStatus() {
    String msg = "";
    if (apiIsOpen.value) {
      msg = "API is closed.";
    } else {
      msg = "API is opened.";
    }
    apiIsOpen.value = !apiIsOpen.value;
    Helper.showToast(msg);
    HapticFeedback.heavyImpact();
  }

  void onChanged(String title, double value) {
    data[title]!.value = value * 100;
    anims[title]!.value = value;
  }

  void configureAndConnect() {
    String osPrefix = 'NODE-RED';
    if (defaultTargetPlatform == TargetPlatform.android) {
      osPrefix = 'Flutter_Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      osPrefix = 'Flutter_IOS';
    }
    manager = MQTTManager(
      host: "test.mosquitto.org", //broker.hivemq.com
      topic: "kofikofik",
      identifier: osPrefix,
    );
    currentState.value = MQTTAppConnectionState.connecting;
    manager.initializeMQTTClient();
    manager.connect();
  }

  void publishMessage(String text) {
    String osPrefix = 'NODE-RED';
    if (defaultTargetPlatform == TargetPlatform.android) {
      osPrefix = 'Flutter_Android';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      osPrefix = 'Flutter_IOS';
    }
    final String message = '$osPrefix says: $text';

    try {
      manager.publish(message);
    } catch (e) {}
  }
}
