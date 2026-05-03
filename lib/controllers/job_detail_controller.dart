import 'package:eirs_fsm/data/models/job_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailController extends GetxController {
  late Rx<JobModel> job;
  var isDialogLoading = false.obs;
  var beforePhotos = <File>[].obs;
  var afterPhotos = <File>[].obs;

  @override
  void onInit() {
    super.onInit();
    job = (Get.arguments as JobModel).obs;
  }

  Future<bool> verifyStartOtp(String enteredPin) async {
    isDialogLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isDialogLoading.value = false;

    if (enteredPin == "1234") {
      updateStatus(JobStatus.inProgress);
      Get.back();
      Get.snackbar(
        "Success",
        "Job Started Successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
      Get.snackbar(
        "Error",
        "Invalid OTP. Try 1234",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> verifyEndOtp(String enteredPin) async {
    debugPrint("🔐 verifyEndOtp called");
    debugPrint("📸 Before photos: ${beforePhotos.length}");
    debugPrint("📸 After photos: ${afterPhotos.length}");

    // ✅ Before photo mandatory check
    if (beforePhotos.isEmpty) {
      Get.snackbar(
        "Photo Required",
        "Please capture at least 1 before photo",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    // ✅ After photo mandatory check
    if (afterPhotos.isEmpty) {
      Get.snackbar(
        "Photo Required",
        "Please capture at least 1 after photo",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return false;
    }

    isDialogLoading.value = true;
    await Future.delayed(const Duration(seconds: 1));
    isDialogLoading.value = false;

    if (enteredPin == "5678") {
      debugPrint("✅ End OTP verified - Job completing");
      updateStatus(JobStatus.completed);
      Get.back();
      Get.snackbar(
        "Great Job!",
        "Job Completed. Wallet updated",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return true;
    } else {
      debugPrint("❌ Wrong end OTP");
      Get.snackbar(
        "Error",
        "Invalid OTP. Try 5678",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  void callCustomer() async {
    final phone = job.value.customerPhone;
    if (phone.isEmpty) {
      Get.snackbar("Error", "Customer phone number not available");
      return;
    }
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        Get.snackbar("Error", "Could not launch phone dialer");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while trying to call");
    }
  }

  void openMap() async {
    // Mock Coordinates

    const double lat = 28.6139;
    const double lng = 77.2090;

    final Uri googleMapsUrl = Uri.parse("google.navigation:q=$lat,$lng&mode=d");

    if (!await launchUrl(googleMapsUrl)) {
      Get.snackbar("Error", "Could not open Maps");
    }
  }

  void updateStatus(JobStatus newStatus) {
    job.update((val) {
      val?.jobStatus = newStatus;
    });
    Get.snackbar("Suceess", "Status updated to ${newStatus.name}");
  }

  void addBeforePhoto() async {
    debugPrint("📸 addBeforePhoto() called");

    try {
      final source = await _showPhotoSourceDialog();
      debugPrint("📷 Source selected: $source");

      if (source == null) {
        debugPrint("⚠️ User cancelled photo source dialog");
        return;
      }

      final ImagePicker picker = ImagePicker();
      debugPrint("🔄 Opening picker with source: $source");

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        debugPrint("✅ Image picked: ${image.path}");
        final file = File(image.path);
        final exists = await file.exists();
        debugPrint("📁 File exists: $exists");

        beforePhotos.add(file);
        debugPrint("✅ Before photos count: ${beforePhotos.length}");

        Get.snackbar(
          "Success",
          "Before photo added ✅",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        debugPrint("⚠️ No image selected (null)");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ ERROR in addBeforePhoto: $e");
      debugPrint("📋 StackTrace: $stackTrace");
      Get.snackbar(
        "Error",
        "Failed to add photo: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void addAfterPhoto() async {
    debugPrint("📸 addAfterPhoto() called");

    try {
      final source = await _showPhotoSourceDialog();
      debugPrint("📷 Source selected: $source");

      if (source == null) {
        debugPrint("⚠️ User cancelled photo source dialog");
        return;
      }

      final ImagePicker picker = ImagePicker();
      debugPrint("🔄 Opening picker with source: $source");

      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        debugPrint("✅ Image picked: ${image.path}");
        final file = File(image.path);
        final exists = await file.exists();
        debugPrint("📁 File exists: $exists");

        afterPhotos.add(file);
        debugPrint("✅ After photos count: ${afterPhotos.length}");

        Get.snackbar(
          "Success",
          "After photo added ✅",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        debugPrint("⚠️ No image selected (null)");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ ERROR in addAfterPhoto: $e");
      debugPrint("📋 StackTrace: $stackTrace");
      Get.snackbar(
        "Error",
        "Failed to add photo: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void removeBeforePhoto(int index) {
    beforePhotos.removeAt(index);
    Get.snackbar(
      "Photo",
      "Before photo removed",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void removeAfterPhoto(int index) {
    afterPhotos.removeAt(index);
    Get.snackbar(
      "Photo",
      "After photo removed",
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  Future<ImageSource?> _showPhotoSourceDialog() async {
    return await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text("Select Photo Source"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.blue),
              ),
              title: const Text("Camera"),
              subtitle: const Text("Take a new photo"),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            const Divider(),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.photo_library, color: Colors.green),
              ),
              title: const Text("Gallery"),
              subtitle: const Text("Choose from gallery"),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
