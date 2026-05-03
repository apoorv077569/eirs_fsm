import 'package:eirs_fsm/core/constants/colors.dart';
import 'package:eirs_fsm/views/auth/login_screen.dart';
import 'package:eirs_fsm/views/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController _lottieController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Lottie animation controller
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Fade animation for text
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    // Start animations
    _lottieController.forward();

    // Text fade in after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      _fadeController.forward();
    });

    // Navigate after animation
    _checkLoginAndNavigate();
  }

  Future<void> _checkLoginAndNavigate() async {
    await Future.delayed(const Duration(seconds: 4));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      Get.offAll(() => const MainScreen());
    } else {
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  void dispose() {
    _lottieController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation
            SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(
                'assets/loading.json',
                controller: _lottieController,
                fit: BoxFit.contain,
                onLoaded: (composition) {
                  _lottieController.duration = composition.duration;
                  _lottieController.forward();
                },
              ),
            ),
            const SizedBox(height: 30),

            // App Name with fade
            FadeTransition(
              opacity: _fadeAnimation,
              child: const Column(
                children: [
                  Text(
                    'EIRS',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 3,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Field Service Management',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // Loading indicator
            FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}