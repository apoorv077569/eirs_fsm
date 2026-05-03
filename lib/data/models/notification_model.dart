enum NotificationType { jobAssigned, jobUpdate, wallet, otp, leave, general }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime dateTime;
  final NotificationType type;
  final bool isRead;
  final String? jobId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.type,
    this.isRead = false,
    this.jobId,
  });
}