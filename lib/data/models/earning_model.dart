class EarningModel {
  final String jobId;
  final String customer;
  final String service;
  final DateTime date;
  final double amount;

  EarningModel({
    required this.jobId,
    required this.customer,
    required this.service,
    required this.date,
    required this.amount,
  });
}