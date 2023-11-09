import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/instance_manager.dart';
import 'package:msku2209b/controllers/auth_controller.dart';
import 'package:msku2209b/models/data.dart';

import '../const.dart';

class Api {
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<void> setData(Data data) async {
    await firestore
        .collection(Const.collOne)
        .doc(Get.find<AuthController>().profile.value!.mail)
        .collection(Const.collTwo)
        .add(data.toJson());
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getData(Data data) async {
    return await firestore
        .collection(Const.collOne)
        .doc(Get.find<AuthController>().profile.value!.mail)
        .collection(Const.collTwo)
        .get();
  }
}
