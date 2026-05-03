import 'package:eirs_fsm/controllers/job_detail_controller.dart';
import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/data/models/job_model.dart';
import 'package:eirs_fsm/views/widgets/otp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:eirs_fsm/views/widgets/photo_upload_card.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JobDetailController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text("Job Details", style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Job Header Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Job #${controller.job.value.id}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                controller.job.value.jobStatus,
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _getStatusColor(
                                  controller.job.value.jobStatus,
                                ),
                              ),
                            ),
                            child: Text(
                              controller.job.value.jobStatus.name.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: _getStatusColor(
                                  controller.job.value.jobStatus,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.job.value.serviceType,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "₹${controller.job.value.amount.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat(
                              "dd MMM yyyy, hh:mm a",
                            ).format(controller.job.value.dateTime),
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Customer Details Card
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Customer Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.person,
                        controller.job.value.customerName,
                      ),
                      _buildInfoRow(
                        Icons.phone,
                        "98****${controller.job.value.customerName.substring(0, 4)}",
                      ), // Masked number
                      _buildInfoRow(
                        Icons.location_on,
                        controller.job.value.address,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 👇 YAHAN MAP ADD KIYA HAI 👇
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Icons.map, size: 60, color: Colors.grey),
                    Positioned(
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "📍 Lat: ${controller.job.value.lat}, Lng: ${controller.job.value.lng}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ═══════════════════════════════════════
              // 📸 BEFORE PHOTOS - Job In Progress ke time
              // ═══════════════════════════════════════
              if (controller.job.value.jobStatus == JobStatus.inProgress ||
                  controller.job.value.jobStatus == JobStatus.completed)
                PhotoUploadCard(
                  title: "Before Photos",
                  subtitle:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? "Capture photos of current condition"
                          : "Photos captured before work",
                  icon: Icons.camera_alt,
                  color: Colors.orange,
                  photos: controller.beforePhotos,
                  onCapture:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? () => controller.addBeforePhoto()
                          : () {},
                  onRemove:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? (index) => controller.removeBeforePhoto(index)
                          : (index) {},
                ),

              const SizedBox(height: 12),

              // ═══════════════════════════════════════
              // 📸 AFTER PHOTOS - Complete button se pehle
              // ═══════════════════════════════════════
              if (controller.job.value.jobStatus == JobStatus.inProgress ||
                  controller.job.value.jobStatus == JobStatus.completed)
                PhotoUploadCard(
                  title: "After Photos",
                  subtitle:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? "Capture photos after completing work"
                          : "Photos captured after work",
                  icon: Icons.camera_enhance,
                  color: Colors.green,
                  photos: controller.afterPhotos,
                  onCapture:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? () => controller.addAfterPhoto()
                          : () {},
                  onRemove:
                      controller.job.value.jobStatus == JobStatus.inProgress
                          ? (index) => controller.removeAfterPhoto(index)
                          : (index) {},
                ),

              const SizedBox(height: 16),

              // Action Buttons
              _buildActionButtons(controller),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(JobDetailController controller) {
    switch (controller.job.value.jobStatus) {
      case JobStatus.pending:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            controller.updateStatus(JobStatus.accepted);
            Get.back();
          },
          child: const Text(
            "Accept Job",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case JobStatus.accepted:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.inProgress,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text("Start Job Verification"),
                content: OtpDialog(
                  title: "Start Job",
                  subtitle: "Enter the OTP received from customer",
                  onVerify: (pin) => controller.verifyStartOtp(pin),
                  isLoading: controller.isDialogLoading.value,
                ),
              ),
            );
          },
          child: const Text(
            "Start Service",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case JobStatus.inProgress:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.completed,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: const Text("Complete Job Verification"),
                content: OtpDialog(
                  title: "Complete Job",
                  subtitle: "Enter the OTP received from customer",
                  onVerify: (pin) => controller.verifyEndOtp(pin),
                  isLoading: controller.isDialogLoading.value,
                ),
              ),
            );
          },
          child: const Text(
            "Complete Job",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      case JobStatus.completed:
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.completed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.completed),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppColors.completed),
              SizedBox(width: 8),
              Text(
                "Job Completed Successfully!",
                style: TextStyle(
                  color: AppColors.completed,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
    }
  }

  Color _getStatusColor(JobStatus status) {
    switch (status) {
      case JobStatus.pending:
        return AppColors.pending;
      case JobStatus.accepted:
        return AppColors.accepted;
      case JobStatus.inProgress:
        return AppColors.inProgress;
      case JobStatus.completed:
        return AppColors.completed;
    }
  }
}
