import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:switcher_button/switcher_button.dart';
import 'package:msku2209b/controllers/data_controller.dart';
import 'package:msku2209b/helper.dart';
import 'package:msku2209b/theme.dart';

class CustomSlider extends HookWidget {
  const CustomSlider({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final RxDouble value;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DataController>();
    final anim = useAnimationController(duration: const Duration(seconds: 1));

    useEffect(() {
      controller.anims[title] = anim;
      anim.value = (value.value) / 100;
      return null;
    }, const []);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Obx(
        () => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "🌬️ $title",
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.1),
                ),
                Text(
                  "% ${value.floor()}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic, fontSize: 15),
                )
              ],
            ),
            Row(
              children: [
                Flexible(
                  flex: 5,
                  child: AnimatedBuilder(
                      animation: anim,
                      builder: (context, Widget? child) {
                        return Slider(
                          value: controller.anims[title]!.value,
                          onChanged: (val) => controller.onChanged(title, val),
                        );
                      }),
                ),
                Flexible(
                  child: Obx(
                    () => Stack(
                      children: [
                        SwitcherButton(
                          onColor: CColors.circleGreen,
                          offColor: CColors.circleOrange,
                          value: controller.fanStatus[title]!.value,
                          onChange: (value) {
                            controller.fanStatus[title]!.value = value;
                            if (value) {
                              Helper.showToast("$title is opened.");
                            } else {
                              Helper.showToast("$title is closed.");
                            }
                          },
                        ),
                        controller.fanStatus[title]!.value
                            ? const Positioned(
                                top: 8,
                                left: 8,
                                child: Text(
                                  "ON",
                                  style: TextStyle(
                                    color: CColors.white,
                                  ),
                                ),
                              )
                            : const Positioned(
                                top: 8,
                                right: 8,
                                child: Text(
                                  "OFF",
                                  style: TextStyle(
                                    color: CColors.white,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
