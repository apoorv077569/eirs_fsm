enum NotificationType { jobAssigned, jobUpdate, wallet, otp, leave, general, walletDebit, leaveApproved, walletCredit, leaveRejected, otpStart, otpComplete }

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime dateTime;
  final NotificationType type;
  final bool isRead;
  final String? jobId;
  final String? customerName;
  final double? amount;
  final String? transactionId;
  final String? leaveId;
  final String? otpCode;
  final String? status;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    required this.type,
    this.isRead = false,
    this.jobId,
    this.customerName,
    this.amount,
    this.transactionId,
    this.leaveId,
    this.otpCode,
    this.status,
  });
}