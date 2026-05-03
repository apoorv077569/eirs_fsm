import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("🔔 Background: ${message.notification?.title}");
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final RxString fcmToken = ''.obs;

  Future<void> initialize() async {
    debugPrint("🔔 Initializing Notification Service");

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _handleNotificationTap(response.payload);
      },
    );

    await _requestPermission();

    // Firebase Push Setup
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _getFCMToken();
    _listenForegroundMessages();
    _listenNotificationOpenedApp();
    await _checkInitialMessage();

    // ─── Subscribe to Topic (Sab users ko include karo) ───
    await subscribeToTopic('all_users');

    debugPrint("✅ Notification Service initialized");
  }

  // ─── Topic Subscribe ───
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    debugPrint("✅ Subscribed to: $topic");
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    debugPrint("❌ Unsubscribed: $topic");
  }

  Future<void> _getFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    if (token != null) {
      fcmToken.value = token;
      debugPrint("🔑 FCM Token: $token");
    }
  }

  void _listenForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      _showPushAsLocal(message);
    });
  }

  void _listenNotificationOpenedApp() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handlePushData(message.data);
    });
  }

  Future<void> _checkInitialMessage() async {
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      _handlePushData(message.data);
    }
  }

  Future<void> _showPushAsLocal(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    await showNotification(
      id: message.hashCode,
      title: notification.title ?? 'Notification',
      body: notification.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  void _handlePushData(Map<String, dynamic> data) {
    final type = data['type'];
    debugPrint("🔔 Push type: $type");
  }

  Future<void> _requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }
  }

  // ─── EXISTING METHODS (UNCHANGED) ───
  Future<void> showNotification({required int id, required String title, required String body, String? payload}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'eirs_channel', 'EIRS Notifications',
      importance: Importance.max, priority: Priority.high,
      icon: '@mipmap/ic_launcher', color: Color(0xFF2563EB),
      enableVibration: true, playSound: true,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details, payload: payload);
  }

  Future<void> showJobAssigned({required String jobId, required String serviceType, required String customerName}) async {
    await showNotification(id: int.tryParse(jobId) ?? 0, title: "🆕 New Job Assigned!", body: "$serviceType - $customerName", payload: "job_$jobId");
  }

  Future<void> showJobStatusUpdate({required String jobId, required String status}) async {
    String title, body;
    switch (status) {
      case 'accepted': title = "✅ Job Accepted"; body = "Job #$jobId accepted"; break;
      case 'inProgress': title = "🔧 In Progress"; body = "Job #$jobId in progress"; break;
      case 'completed': title = "🎉 Completed!"; body = "Job #$jobId done"; break;
      default: title = "Job Update"; body = "Job #$jobId: $status";
    }
    await showNotification(id: int.tryParse(jobId) ?? 0, title: title, body: body, payload: "job_$jobId");
  }

  Future<void> showWalletUpdate({required double amount, required String type}) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: type == 'credit' ? "💰 Received!" : "💸 Withdrawn",
      body: type == 'credit' ? "₹${amount.toStringAsFixed(0)} added" : "₹${amount.toStringAsFixed(0)} withdrawn",
      payload: "wallet",
    );
  }

  Future<void> showOtpNotification({required String jobId, required String otpType}) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: otpType == 'start' ? "🔐 Start OTP" : "✅ Completion OTP",
      body: "Enter OTP for Job #$jobId",
      payload: "otp_$jobId",
    );
  }

  Future<void> showLeaveNotification({required String status}) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: status == 'approved' ? "✅ Leave Approved" : "❌ Leave Rejected",
      body: status == 'approved' ? "Leave approved" : "Leave rejected",
      payload: "leave",
    );
  }

  void _handleNotificationTap(String? payload) {
    if (payload == null) return;
    try {
      final data = jsonDecode(payload);
      _handlePushData(data);
      return;
    } catch (_) {}
    if (payload.startsWith('job_')) debugPrint("➡️ Go to Job");
    if (payload == 'wallet') debugPrint("➡️ Go to Wallet");
    if (payload == 'leave') debugPrint("➡️ Go to Leave");
    if (payload.startsWith('otp_')) debugPrint("➡️ Go to OTP");
  }

  Future<void> cancelNotification(int id) async => _plugin.cancel(id);
  Future<void> cancelAll() async => _plugin.cancelAll();
  String get currentFCMToken => fcmToken.value;
}