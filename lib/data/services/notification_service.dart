import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ─── Initialize ───
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
        debugPrint("🔔 Notification tapped: ${response.payload}");
        _handleNotificationTap(response.payload);
      },
    );

    // Android 13+ ke liye permission request
    await _requestPermission();

    debugPrint("✅ Notification Service initialized");
  }

  // ─── Request Permission ───
  Future<void> _requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }
  }

  // ─── Show Notification ───
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'eirs_channel',
      'EIRS Notifications',
      channelDescription: 'EIRS Field Service Notifications',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
      color: Color(0xFF2563EB),
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _plugin.show(id, title, body, details, payload: payload);
    debugPrint("🔔 Notification shown: $title");
  }

  // ─── Job Assigned Notification ───
  Future<void> showJobAssigned({
    required String jobId,
    required String serviceType,
    required String customerName,
  }) async {
    await showNotification(
      id: int.tryParse(jobId) ?? 0,
      title: "🆕 New Job Assigned!",
      body: "$serviceType - $customerName",
      payload: "job_$jobId",
    );
  }

  // ─── Job Status Update Notification ───
  Future<void> showJobStatusUpdate({
    required String jobId,
    required String status,
  }) async {
    String title;
    String body;

    switch (status) {
      case 'accepted':
        title = "✅ Job Accepted";
        body = "Job #$jobId has been accepted";
        break;
      case 'inProgress':
        title = "🔧 Job In Progress";
        body = "Job #$jobId is now in progress";
        break;
      case 'completed':
        title = "🎉 Job Completed!";
        body = "Job #$jobId completed successfully";
        break;
      default:
        title = "Job Update";
        body = "Job #$jobId status: $status";
    }

    await showNotification(
      id: int.tryParse(jobId) ?? 0,
      title: title,
      body: body,
      payload: "job_$jobId",
    );
  }

  // ─── Wallet Update Notification ───
  Future<void> showWalletUpdate({
    required double amount,
    required String type,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: type == 'credit' ? "💰 Money Received!" : "💸 Money Withdrawn",
      body: type == 'credit'
          ? "₹${amount.toStringAsFixed(0)} added to your wallet"
          : "₹${amount.toStringAsFixed(0)} withdrawn from wallet",
      payload: "wallet",
    );
  }

  // ─── OTP Notification ───
  Future<void> showOtpNotification({
    required String jobId,
    required String otpType,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: otpType == 'start' ? "🔐 Start OTP" : "✅ Completion OTP",
      body: "Enter OTP to ${otpType == 'start' ? 'start' : 'complete'} Job #$jobId",
      payload: "otp_$jobId",
    );
  }

  // ─── Leave Notification ───
  Future<void> showLeaveNotification({
    required String status,
  }) async {
    await showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: status == 'approved' ? "✅ Leave Approved" : "❌ Leave Rejected",
      body: status == 'approved'
          ? "Your leave request has been approved"
          : "Your leave request has been rejected",
      payload: "leave",
    );
  }

  // ─── Handle Notification Tap ───
  void _handleNotificationTap(String? payload) {
    if (payload == null) return;

    debugPrint("🔔 Handling tap: $payload");

    if (payload.startsWith('job_')) {
      debugPrint("Navigate to job: $payload");
    } else if (payload == 'wallet') {
      debugPrint("Navigate to wallet");
    } else if (payload == 'leave') {
      debugPrint("Navigate to leave");
    }
  }

  // ─── Cancel Notification ───
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  // ─── Cancel All ───
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}