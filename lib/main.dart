import 'package:eirs_fsm/core/constants/strings.dart';
import 'package:eirs_fsm/core/routes/app_pages.dart';
import 'package:eirs_fsm/core/routes/app_routes.dart';
import 'package:eirs_fsm/core/theme/app_theme.dart';
import 'package:eirs_fsm/data/services/notification_service.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

      // ─── Routing ───
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