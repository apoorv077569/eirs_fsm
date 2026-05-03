import 'package:eirs_fsm/controllers/notification_controller.dart';
import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:eirs_fsm/views/job_details/job_details_screen.dart';
import 'package:eirs_fsm/views/notification/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';
import '../../core/constants/colors.dart';
import '../widgets/job_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return DefaultTabController(
      length: 2, // Two tabs
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5), // Light background
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.dashboard,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppStrings.partnerApp,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          actions: [
            Obx(() {
              final notifCtrl = Get.put(NotificationController());
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () => Get.to(() => const NotificationScreen()),
                  ),
                  if (notifCtrl.unreadCount.value > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${notifCtrl.unreadCount.value}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),

            // ONLINE / OFFLINE TOGGLE
            Obx(
              () => Row(
                children: [
                  Text(
                    controller.isOnline.value
                        ? AppStrings.online
                        : AppStrings.offline,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          controller.isOnline.value
                              ? Colors.green
                              : Colors.grey,
                    ),
                  ),
                  Switch(
                    value: controller.isOnline.value,
                    activeThumbColor: Colors.green,
                    onChanged: (val) => controller.toggleOnline(val),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            tabs: [Tab(text: "New Requests"), Tab(text: "My Jobs")],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: New Requests
            Obx(() => _buildList(controller.newRequests)),

            // TAB 2: My Jobs
            Obx(() => _buildList(controller.myJobs)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List jobs) {
    if (jobs.isEmpty) {
      return const Center(child: Text(AppStrings.noJobsAvailable));
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        return JobCard(
          job: jobs[index],
          onTap: () {
            Get.toNamed(AppRoutes.jobDetail, arguments: jobs[index]);
          },
        );
      },
    );
  }
}
