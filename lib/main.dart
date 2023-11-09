import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:msku2209b/controllers/global_bingings.dart';
import 'package:msku2209b/firebase_options.dart';
import 'package:msku2209b/theme.dart';
import 'package:msku2209b/widgets/root_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox("config");

  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.hourGlass;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tubitak 2209-B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: CColors.mainColor),
      initialBinding: GlobalBindings(),
      home: const RootWrapper(),
      builder: (BuildContext context, Widget? child) {
        return FlutterEasyLoading(child: child);
      },
    );
  }
}
