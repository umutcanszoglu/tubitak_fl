import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final Widget? icon;
  final IconData? iconData;
  final Color color;
  final Color? splashColor;
  final Color? iconColor;
  final Color? textColor;

  const LoginButton({
    Key? key,
    this.onPressed,
    required this.buttonText,
    this.icon,
    required this.color,
    this.splashColor,
    this.iconData,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: splashColor,
        backgroundColor: color,
        minimumSize: const Size(0, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null || iconData != null)
            Positioned(
              left: 8,
              child: icon != null
                  ? icon!
                  : FaIcon(
                      iconData,
                      size: 24,
                      color: iconColor,
                    ),
            ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: textColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
