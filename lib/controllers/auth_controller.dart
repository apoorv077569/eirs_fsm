
import 'package:eirs_fsm/views/auth/otp_screen.dart';
import 'package:eirs_fsm/views/dashboard/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  void sendOtp() async{
    if(phoneController.text.isEmpty){
      Get.snackbar("Error", "Enter phone number");
      return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;

    Get.to(()=> const OtpScreen());
  }
  void verifyOtp() async{
    if(otpController.text.isEmpty){
        Get.snackbar("Error", "Please Enter an otp");
        return;
    }
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 2));
    isLoading.value = false;
    Get.offAll(()=> const HomeScreen());
  }
}
