import 'package:flutter/material.dart';
import 'package:msku2209b/theme.dart';

class BigButton extends StatelessWidget {
  final Widget child;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color color;
  final Color diasbledColor;
  final double borderRadius;

  const BigButton({
    Key? key,
    required this.child,
    this.onPressed,
    this.height = 60,
    this.color = CColors.mainColor,
    this.diasbledColor = CColors.foregroundBlack,
    this.width = double.infinity,
    this.borderRadius = 30.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
              onPressed != null ? color : diasbledColor),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
