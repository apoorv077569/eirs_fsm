import 'package:eirs_fsm/data/models/notification_model.dart';
import 'package:eirs_fsm/data/services/notification_service.dart';
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
      ),
      NotificationModel(
        id: "N002",
        title: "💰 Money Received!",
        body: "₹450 added to your wallet for Job #101",
        dateTime: DateTime.now().subtract(const Duration(hours: 1)),
        type: NotificationType.wallet,
      ),
      NotificationModel(
        id: "N003",
        title: "🆕 New Job Assigned!",
        body: "Laptop Repair - Aarya Yadav, Indira Nagar Lucknow",
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.jobAssigned,
        jobId: "102",
      ),
      NotificationModel(
        id: "N004",
        title: "✅ Leave Approved",
        body: "Your leave for 5 Jan - 7 Jan has been approved",
        dateTime: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.leave,
        isRead: true,
      ),
      NotificationModel(
        id: "N005",
        title: "🎉 Job Completed!",
        body: "Job #201 Plumbing completed successfully",
        dateTime: DateTime.now().subtract(const Duration(days: 2)),
        type: NotificationType.jobUpdate,
        jobId: "201",
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
      final notification = notifications[index];
      notifications[index] = NotificationModel(
        id: notification.id,
        title: notification.title,
        body: notification.body,
        dateTime: notification.dateTime,
        type: notification.type,
        isRead: true,
        jobId: notification.jobId,
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
      );
    }
    notifications.refresh();
    _updateUnreadCount();
  }

  void clearAll() {
    notifications.clear();
    _updateUnreadCount();
  }

  // Push notification trigger karo
  void triggerNotification(String title, String body) {
    _notificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
    );

    notifications.insert(
      0,
      NotificationModel(
        id: "N${DateTime.now().millisecondsSinceEpoch}",
        title: title,
        body: body,
        dateTime: DateTime.now(),
        type: NotificationType.general,
      ),
    );
    _updateUnreadCount();
  }
}