import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:msku2209b/helper.dart';

class VerifyModal extends StatelessWidget {
  final User user;
  const VerifyModal({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Email Verification"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: const Text(
        "Verify Your Email",
        style: TextStyle(fontSize: 18),
      ),
      actions: [
        ElevatedButton(
          child: const Text("Resend"),
          onPressed: () async {
            try {
              await user.sendEmailVerification();
              Get.back(result: true);
            } on FirebaseAuthException catch (err) {
              Get.back();
              Helper.showErrorToast(err.message!);
            } catch (err) {
              Get.back();
              Helper.showErrorToast(err.toString());
            }
          },
        ),
      ],
    );
  }
}
