import 'package:eirs_fsm/controllers/auth_controller.dart';
import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget{

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.put(AuthController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset("assets/app_logo.png",width: 50,height: 100),
            const SizedBox(height: 20),
            const Text(
              AppStrings.appName,
              style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold,color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextField(
              controller: authCtrl.phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: AppStrings.enterPhoneNumber,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 20),

               Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: authCtrl.isLoading.value 
                  ? null 
                  : () {
                      authCtrl.sendOtp(); 
                    },
              child: authCtrl.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(AppStrings.login, style: TextStyle(color: Colors.white)),
            ))
           
          ],
        ),
      ),

    );
  }
}