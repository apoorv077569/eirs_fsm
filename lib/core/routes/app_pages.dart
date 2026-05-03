import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:eirs_fsm/views/auth/login_screen.dart';
import 'package:eirs_fsm/views/auth/otp_screen.dart';
import 'package:eirs_fsm/views/dashboard/home_screen.dart';
import 'package:eirs_fsm/views/earnings/earning_screen.dart';
import 'package:eirs_fsm/views/job_details/job_details_screen.dart';
import 'package:eirs_fsm/views/main_screen.dart';
import 'package:eirs_fsm/views/notification/notification_screen.dart';
import 'package:eirs_fsm/views/profile/profile_screen.dart';
import 'package:eirs_fsm/views/splash/splash_screen.dart'; // ← ADD
import 'package:eirs_fsm/views/wallet/wallet_screen.dart'; // ← ADD
import 'package:get/get.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),

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

    GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
      transition: Transition.fadeIn,
    ),

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

    // Wallet
    GetPage(
      name: AppRoutes.wallet,
      page: () => const WalletScreen(),
      transition: Transition.rightToLeft,
    ),

    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationScreen(),
      transition: Transition.rightToLeft,
    ),
  ];
}
