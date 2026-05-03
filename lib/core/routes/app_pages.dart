import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:eirs_fsm/views/auth/login_screen.dart';
import 'package:eirs_fsm/views/auth/otp_screen.dart';
import 'package:eirs_fsm/views/dashboard/home_screen.dart';
import 'package:eirs_fsm/views/earnings/earning_screen.dart';
import 'package:eirs_fsm/views/job_details/job_details_screen.dart';
import 'package:eirs_fsm/views/main_screen.dart';
import 'package:eirs_fsm/views/profile/profile_screen.dart';
import 'package:get/get.dart';

class AppPages {
  // ─── Initial Route ───
  static const String initial = AppRoutes.login;

  // ─── All Pages ───
  static final List<GetPage> pages = [

    // Auth
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      transition: Transition.fadeIn,
    ),

    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      transition: Transition.rightToLeft,
    ),

    // Main (Bottom Navigation)
    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      transition: Transition.fadeIn,
    ),

    // Dashboard
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const HomeScreen(),
      transition: Transition.fadeIn,
    ),

    // Job Detail
    GetPage(
      name: AppRoutes.jobDetail,
      page: () => const JobDetailScreen(),
      transition: Transition.rightToLeftWithFade,
    ),

    // Earnings
    GetPage(
      name: AppRoutes.earnings,
      page: () => const EarningsScreen(),
      transition: Transition.fadeIn,
    ),

    // Profile
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}