import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:msku2209b/helper.dart';
import 'package:msku2209b/models/profile.dart';
import 'package:msku2209b/widgets/modals/verify_modal.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = Rxn<User>();
  final profile = Rxn<Profile>();

  @override
  void onInit() async {
    user.bindStream(_auth.authStateChanges());
    ever(user, (User? newUser) async {
      if (user.value == null) {
        profile.value = null;
        return;
      }
      profile.value = Profile(mail: newUser!.email!);
      if (!newUser.emailVerified) {
        Helper.showToast("Email not verified.");
        await signOut();
        return;
      }
    });
    super.onInit();
  }

  Future<void> signOut() async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.black);
      try {
        await GoogleSignIn().disconnect();
      } catch (_) {}
      await _auth.signOut();
    } catch (err) {
      debugPrint("Signout error : $err");
    }
    resetProfileControllers(false);
    await FirebaseMessaging.instance.deleteToken();
    EasyLoading.dismiss();
  }

  Future<void> signIn(
    String platform, {
    String? email,
    String? password,
  }) async {
    try {
      EasyLoading.show(maskType: EasyLoadingMaskType.clear);
      switch (platform) {
        case "google":
          await signInWithGoogle();
          break;
        case "emailSignIn":
          await signInWithEmail(email!, password!);
          break;
        case "emailSignUp":
          await signUpWithEmail(email!, password!);
          break;
        default:
          Helper.showErrorToast(
              "${platform.toUpperCase()} sign in is not implemented yet.");
          EasyLoading.dismiss();
          break;
      }
    } catch (err) {
      EasyLoading.dismiss();
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (_) {
      Helper.showErrorToast("Password reset link not send");

      return false;
    } catch (_) {
      Helper.showErrorToast("Password reset link not send");
      return false;
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (_auth.currentUser!.emailVerified) {
        Get.back();
      } else {
        final result = await Get.dialog(VerifyModal(user: _auth.currentUser!));
        signOut();

        if (result != null) {
          Helper.showToast("Verification link sent.");
        }
        return;
      }
    } on FirebaseAuthException catch (_) {
      Helper.showErrorToast("There is no such account.");
      rethrow;
    } catch (_) {
      Helper.showErrorToast("Failed to login");
      rethrow;
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      await signOut();
      Get.back();

      Helper.showToast("Registration successful");
    } on FirebaseAuthException catch (_) {
      Helper.showErrorToast("Registration failed");
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (err) {
      Helper.showErrorToast("Failed to login");
      debugPrint(err.message);
      rethrow;
    } catch (err) {
      Helper.showErrorToast("Failed to login");
      debugPrint(err.toString());

      rethrow;
    }
  }

  void resetProfileControllers(bool init) {
    if (!init) profile.value = null;
  }
}
