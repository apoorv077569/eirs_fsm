
import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpDialog extends StatelessWidget {

  final String title;
  final String subtitle;
  final Function(String) onVerify;
  final bool isLoading;

  const OtpDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onVerify,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController pinController = TextEditingController();

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
    );
    return Column(
      children: [
        Text(subtitle,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[600])),
        const SizedBox(height: 20),

        Pinput(
          length: 4,
          controller: pinController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: defaultPinTheme.copyDecorationWith(
            border: Border.all(color: AppColors.primary),
            color: Colors.white,
          ),
          onCompleted: (pin){

          },
        ),
        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null:() => onVerify(pinController.text),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: isLoading?const SizedBox(height: 20,width: 20,child: CircularProgressIndicator(color: Colors.white))
            : const Text("Verify",style: TextStyle(color: Colors.white)),
            
          ),
        )
      ],
    );
  }
}