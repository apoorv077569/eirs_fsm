import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:eirs_fsm/core/routes/app_pages.dart';
import 'package:eirs_fsm/core/theme/app_theme.dart';
import 'package:eirs_fsm/data/services/network_service.dart';
import 'package:eirs_fsm/data/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:eirs_fsm/firebase_options.dart';  // ← Auto generate ho gaya
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Firebase Initialize (Sabse pehle) ───
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ─── Firebase Connection Check ───
  try {
    final app = Firebase.app();
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
    debugPrint("✅ Firebase Connected!");
    debugPrint("✅ Project: ${app.options.projectId}");

    final token = await FirebaseMessaging.instance.getToken();
    debugPrint("🔑 FCM TOKEN: $token");
    debugPrint("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
  } catch (e) {
    debugPrint("❌ Firebase Error: $e");
  }

  await Get.putAsync(() => NetworkService().init());

  // ─── Notification Service ───
  await NotificationService().initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      initialRoute: AppPages.initial,
      getPages: AppPages.pages,
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(child: Text("Page Not Found")),
        ),
      ),
    );
  }
}