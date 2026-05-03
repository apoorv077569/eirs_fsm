import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  void sendOtp() async {
    if (phoneController.text.isEmpty) {
      Get.snackbar("Error", "Enter phone number");
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // ✅ Route name use karo
    Get.toNamed(AppRoutes.otp);
  }

  void verifyOtp() async {
    if (otpController.text.isEmpty) {
      Get.snackbar("Error", "Please Enter an OTP");
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    // ✅ Route name use karo
    Get.offAllNamed(AppRoutes.main);
  }
}