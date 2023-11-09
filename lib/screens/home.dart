import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:msku2209b/controllers/data_controller.dart';
import 'package:msku2209b/theme.dart';
import 'package:msku2209b/widgets/custom_slider.dart';
import 'package:msku2209b/widgets/double_circular_notched_button.dart';
import 'package:msku2209b/widgets/drawer_menu.dart';
import 'package:msku2209b/widgets/gauge_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DataController());
    return Scaffold(
      drawer: const DrawerMenu(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              onPressed: controller.changeApiStatus,
              heroTag: 1,
              child: Obx(
                () => Icon(
                  controller.apiIsOpen.value
                      ? FontAwesomeIcons.solidCirclePlay
                      : FontAwesomeIcons.solidCirclePause,
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () => controller.publishMessage("TEST MESSAGE"),
              // onPressed: () => Get.dialog(const SetDuration()),
              heroTag: 2,
              child: const Icon(FontAwesomeIcons.stopwatch),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: CColors.mainColor,
        shape: const DoubleCircularNotchedButton(),
        child: Container(height: 70.0),
      ),
      appBar: AppBar(
        title: const Text("Tubitak 2209-B"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Obx(
            () => !controller.isLoading.value
                ? controller.data.isEmpty
                    ? const Center(
                        child: Text("Data Waiting..."),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        children: [
                            const SizedBox(height: 16),
                            CustomSlider(
                                title: "Fan1",
                                value: controller.data["%Fan1"]!),
                            CustomSlider(
                                title: "Fan2",
                                value: controller.data["%Fan2"]!),
                            GridView.count(
                              padding: const EdgeInsets.all(32),
                              shrinkWrap: true,
                              primary: false,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              crossAxisCount: 2,
                              children: controller.data.entries
                                  .where((e) =>
                                      e.key != "%Fan1" && e.key != "%Fan2")
                                  .map(
                                    (e) => GaugeBar(
                                      value: e.value,
                                      title: e.key,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ])
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Center(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.1,
                child: Image.asset(
                  "assets/logo.png",
                  width: Get.width / 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
