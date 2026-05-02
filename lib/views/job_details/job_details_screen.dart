import 'package:eirs_fsm/views/widgets/otp_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/job_detail_controller.dart';
import '../../core/constants/colors.dart';
import '../../data/models/job_model.dart';

class JobDetailScreen extends StatelessWidget {
  const JobDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize Controller
    final controller = Get.put(JobDetailController());

    return Scaffold(
      body: Stack(
        children: [
          // 1. THE MAP HEADER (Top 35%)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.35,
            child: Container(
              color: Colors.grey[300],
              child: Stack(
                children: [
                  // Placeholder Image (Use Google Maps widget here later)
                  const Center(child: Icon(Icons.map, size: 50, color: Colors.grey)),
                  
                  // Back Button
                  Positioned(
                    top: 40,
                    left: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Get.back(),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          // 2. THE CONTENT SHEET (Bottom 70%)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 5)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle Bar
                  Center(child: Container(width: 40, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)))),
                  const SizedBox(height: 20),

                  // Customer Info Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(
                            controller.job.value.customerName,
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          )),
                          const Text("Customer", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      // Call Button
                      InkWell(
                        onTap: () => controller.callCustomer(),
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.green, // WhatsApp/Phone Green
                          child: Icon(Icons.phone, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                  const Divider(height: 40),

                  // Address Section
                  const Text("Address", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Obx(() => Text(
                          controller.job.value.address,
                          style: const TextStyle(fontSize: 14, height: 1.4, color: Colors.black87),
                        )),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  
                  // Job Info
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Service Type", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Obx(() => Text(
                              controller.job.value.serviceType,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            )),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text("Earnings", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            const SizedBox(height: 4),
                            Obx(() => Text(
                              "\₹${controller.job.value.amount}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 3. DYNAMIC ACTION BUTTONS
                  Obx(() => _buildActionButtons(controller)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Logic to switch buttons based on status
  Widget _buildActionButtons(JobDetailController ctrl) {
    JobStatus status = ctrl.job.value.jobStatus;

    switch (status) {
      case JobStatus.pending:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text("Reject", style: TextStyle(color: Colors.red)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Get.defaultDialog(
                    title: "Start Job",
                    content: Obx(() => OtpDialog(
                      title: "Start Code",
                      subtitle: "Ask Customer for the 4-digit START Code",
                      isLoading: ctrl.isDialogLoading.value,
                      onVerify: (code) => ctrl.verifyStartOtp(code),
                    )),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Accept Job", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );

      case JobStatus.accepted:
        return Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => ctrl.openMap(),
                icon: const Icon(Icons.navigation, color: Colors.white),
                label: const Text("Navigate", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Trigger Start OTP Modal (We will build this next)
                  ctrl.updateStatus(JobStatus.inProgress);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Start Job", style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        );

      case JobStatus.inProgress:
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Complete Job",
                content: Obx(() => OtpDialog(
                  title: "End Code",
                  subtitle: "Ask Customer for the 4-digit END code to confirm payment.",
                  isLoading: ctrl.isDialogLoading.value,
                  onVerify: (code) => ctrl.verifyEndOtp(code),
                )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, // Dark color for completion
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text("Complete Job", style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
        );

      case JobStatus.completed:
        return const Center(child: Text("Job Completed", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)));
    }
  }
}