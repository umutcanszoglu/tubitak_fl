import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:msku2209b/controllers/data_controller.dart';
import 'package:msku2209b/theme.dart';

class GaugeBar extends GetView<DataController> {
  const GaugeBar({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);
  final String title;
  final RxDouble value;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(
        title: GaugeTitle(
            text: title,
            textStyle:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 100, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 50, color: CColors.circleGreen),
            GaugeRange(
                startValue: 50, endValue: 80, color: CColors.circleOrange),
            GaugeRange(startValue: 80, endValue: 100, color: CColors.circleRed)
          ], pointers: <GaugePointer>[
            NeedlePointer(
              needleEndWidth: 2,
              value: value.value,
              enableAnimation: true,
              animationDuration: 3000,
              animationType: AnimationType.elasticOut,
            ),
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
              widget: Text(
                controller.convertExt(title, value),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              angle: 90,
              positionFactor: 0.8,
            ),
          ])
        ]);
  }
}
