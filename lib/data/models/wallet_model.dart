class WalletTransaction {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime dateTime;
  final TransactionType type;
  final String? jobId;

  WalletTransaction({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.dateTime,
    required this.type,
    this.jobId,
  });
}

enum TransactionType { credit, debit }