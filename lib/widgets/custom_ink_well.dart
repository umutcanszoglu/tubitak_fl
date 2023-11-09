import 'package:flutter/material.dart';
import 'package:msku2209b/theme.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({
    Key? key,
    required this.child,
    this.onTap,
    this.radius = 20,
  }) : super(key: key);

  final Widget child;
  final void Function()? onTap;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned.fill(
          child: Material(
            color: CColors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
            ),
          ),
        ),
      ],
    );
  }
}
