
import 'package:eirs_fsm/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailController extends GetxController {
  
  late Rx<JobModel> job;
  var isDialogLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    job = (Get.arguments as JobModel).obs;
  }

  Future<bool> verifyStartOtp(String enteredPin) async{
    isDialogLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isDialogLoading.value = false;

    if(enteredPin == "1234"){
      updateStatus(JobStatus.inProgress);
      Get.back();
      Get.snackbar("Success", "Job Started Successfully!",backgroundColor: Colors.green,colorText: Colors.white);
      return true;
    }else{
      Get.snackbar("Error", "Invalid OTP. Try 1234",backgroundColor: Colors.red,colorText: Colors.white);
      return false;
    }
  }

  Future<bool> verifyEndOtp(String enteredPin) async{
    isDialogLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isDialogLoading.value = false;

    if(enteredPin == "5678"){
      updateStatus(JobStatus.completed);
      Get.back();
      Get.back();
      Get.snackbar("Great Job!", "Job Completed. Wallet updated",backgroundColor: Colors.green,colorText: Colors.white);
      return true;
    }else{
      Get.snackbar("Error", "Invalid OTP. Try 5678",backgroundColor: Colors.red,colorText: Colors.white);
      return false;
    }
  }

  void callCustomer() async{
    final Uri launchUri = Uri(scheme:'tel',path:'1234567890');
    await launchUrl(launchUri);
  }

  void openMap() async{
    // Mock Coordinates

    const double lat = 28.6139;
    const double lng = 77.2090;

    final Uri googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng&mode=d");

    if(!await launchUrl(googleMapsUrl)){
      Get.snackbar("Error","Could not open Maps");
    }
  }

  void updateStatus(JobStatus newStatus){
    job.update((val) {
      val?.jobStatus = newStatus;
    });
    Get.snackbar("Suceess", "Status updated to ${newStatus.name}");
  }
}