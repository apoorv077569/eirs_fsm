import 'package:eirs_fsm/data/models/notification_model.dart';
import 'package:eirs_fsm/data/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var notifications = <NotificationModel>[].obs;
  var unreadCount = 0.obs;

  final NotificationService _notificationService = NotificationService();

  @override
  void onInit() {
    super.onInit();
    loadMockNotifications();
    _updateUnreadCount();

    // ─── Callback Connect (Sab notifications yahan aayengi) ───
    _notificationService.onNotificationReceived = (title, body, type, data) {
      _addNotification(title, body, type, data);
    };
  }

  // ─── Auto add from any event ───
  void _addNotification(
    String title,
    String body,
    String type,
    Map<String, dynamic> data,
  ) {
    NotificationType notifType;

    switch (type) {
      case 'job_assigned':
        notifType = NotificationType.jobAssigned;
        break;
      case 'job_update':
        notifType = NotificationType.jobUpdate;
        break;
      case 'wallet_credit':
        notifType = NotificationType.walletCredit;
        break;
      case 'wallet_debit':
        notifType = NotificationType.walletDebit;
        break;
      case 'leave_approved':
        notifType = NotificationType.leaveApproved;
        break;
      case 'leave_rejected':
        notifType = NotificationType.leaveRejected;
        break;
      case 'otp_start':
        notifType = NotificationType.otpStart;
        break;
      case 'otp_complete':
        notifType = NotificationType.otpComplete;
        break;
      default:
        notifType = NotificationType.general;
    }

    notifications.insert(
      0,
      NotificationModel(
        id: "N${DateTime.now().millisecondsSinceEpoch}",
        title: title,
        body: body,
        dateTime: DateTime.now(),
        type: notifType,
        jobId: data['job_id']?.toString(),
        customerName: data['customer_name']?.toString(),
        amount: double.tryParse(data['amount']?.toString() ?? ''),
        transactionId: data['transaction_id']?.toString(),
        leaveId: data['leave_id']?.toString(),
        otpCode: data['otp_code']?.toString(),
      ),
    );

    _updateUnreadCount();
    debugPrint("📋 Added to screen: $title");
  }

  void loadMockNotifications() {
    notifications.addAll([
      NotificationModel(
        id: "N001",
        title: "🆕 New Job Assigned!",
        body: "AC Repair - Rahul Sharma, Sector 62 Noida",
        dateTime: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.jobAssigned,
        jobId: "101",
        customerName: "Rahul Sharma",
      ),
      NotificationModel(
        id: "N002",
        title: "💰 Money Received!",
        body: "₹450 added for Job #101",
        dateTime: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.walletCredit,
        amount: 450.0,
        jobId: "101",
      ),
      NotificationModel(
        id: "N003",
        title: "🆕 New Job Assigned!",
        body: "Laptop Repair - Aarya Yadav",
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.jobAssigned,
        jobId: "102",
        customerName: "Aarya Yadav",
      ),
      NotificationModel(
        id: "N004",
        title: "✅ Leave Approved",
        body: "Leave for 5 Jan - 7 Jan approved",
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.leaveApproved,
        leaveId: "L001",
        isRead: true,
      ),
      NotificationModel(
        id: "N005",
        title: "🎉 Job Completed!",
        body: "Job #201 completed",
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.jobUpdate,
        jobId: "201",
        isRead: true,
      ),
      NotificationModel(
        id: "N006",
        title: "💸 Money Withdrawn",
        body: "₹500 withdrawn",
        dateTime: DateTime.now().subtract(const Duration(days: 3)),
        type: NotificationType.walletDebit,
        amount: 500.0,
        isRead: true,
      ),
    ]);
  }

  void _updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      final n = notifications[index];
      notifications[index] = NotificationModel(
        id: n.id,
        title: n.title,
        body: n.body,
        dateTime: n.dateTime,
        type: n.type,
        isRead: true,
        jobId: n.jobId,
        customerName: n.customerName,
        amount: n.amount,
        transactionId: n.transactionId,
        leaveId: n.leaveId,
        otpCode: n.otpCode,
      );
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      final n = notifications[i];
      notifications[i] = NotificationModel(
        id: n.id,
        title: n.title,
        body: n.body,
        dateTime: n.dateTime,
        type: n.type,
        isRead: true,
        jobId: n.jobId,
        customerName: n.customerName,
        amount: n.amount,
        transactionId: n.transactionId,
        leaveId: n.leaveId,
        otpCode: n.otpCode,
      );
    }
    notifications.refresh();
    _updateUnreadCount();
  }

  void clearAll() {
    notifications.clear();
    _updateUnreadCount();
  }
}
