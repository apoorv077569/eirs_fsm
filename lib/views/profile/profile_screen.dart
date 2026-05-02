// ignore_for_file: deprecated_member_use

import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:eirs_fsm/views/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rajesh Kumar",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Service Staff",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const Text(
                          "+91 98765 43210",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Availability Toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.completed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.wifi_tethering, color: AppColors.completed),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.availability,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            AppStrings.youAreOnline,
                            style: TextStyle(
                              color: AppColors.completed,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: true,
                      onChanged: (val) {
                        Get.snackbar(
                          AppStrings.success,
                          val ? AppStrings.youAreOnline : AppStrings.youAreOffline,
                          backgroundColor: val ? AppColors.completed : Colors.red,
                          colorText: Colors.white,
                        );
                      },
                      activeColor: AppColors.completed,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Leave Request
            Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.event_busy, color: Colors.orange),
                ),
                title: const Text(AppStrings.requestLeave),
                subtitle: const Text("Apply for time off"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Get.dialog(
                    AlertDialog(
                      title: const Text(AppStrings.requestLeave),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "From Date",
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "To Date",
                              suffixIcon: Icon(Icons.calendar_today),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: "Reason",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Get.back();
                            Get.snackbar(
                              AppStrings.success,
                              AppStrings.leaveRequestSubmitted,
                              backgroundColor: AppColors.completed,
                              colorText: Colors.white,
                            );
                          },
                          child: const Text("Submit"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.offAllNamed(AppRoutes.login);
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  AppStrings.logout,
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}