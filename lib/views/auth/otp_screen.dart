import 'package:eirs_fsm/controllers/auth_controller.dart';
import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();

    // Define Pin Theme
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0), // Light Grey
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.transparent),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.primary, width: 2),
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      // 1. WRAP IN SCROLL VIEW (Prevents keyboard overflow)
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Align to top, not center
            crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
            children: [
              const SizedBox(height: 20), // Top spacing
              
              // 2. FIXED LOGO SIZE (Square aspect ratio looks better usually)
              Image.asset(
                "assets/app_logo.png", 
                height: 80, 
                width: 80, 
                fit: BoxFit.contain
              ),
              
              const SizedBox(height: 30),
              
              const Text(
                "Verify Otp",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              
              const SizedBox(height: 10),
              
              Text(
                "Enter the code sent to the number",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              
              const SizedBox(height: 5),
              
              Text(
                authCtrl.phoneController.text,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              
              const SizedBox(height: 40), // Gap before Input
              
              // OTP INPUT
              Pinput(
                length: 4,
                controller: authCtrl.otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                // Optional: Make pinput fill width nicely
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, 
                onCompleted: (pin) => authCtrl.verifyOtp(),
              ),
              
              const SizedBox(height: 40), // Gap before Button

              // VERIFY BUTTON
              SizedBox(
                width: 200,
                child: Obx(
                  () => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0), // Grey
                      foregroundColor: Colors.black54, 
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: authCtrl.isLoading.value
                        ? null
                        : () => authCtrl.verifyOtp(),
                    child: authCtrl.isLoading.value
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "Verify Otp",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // 3. ADDED RESEND OTP TEXT
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Logic to resend OTP
                      Get.snackbar("Sent", "OTP Resent successfully");
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(
                        color: AppColors.primary, // Use your Blue color
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}