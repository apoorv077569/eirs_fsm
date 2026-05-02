enum JobStatus { pending, accepted, inProgress, completed }

class JobModel {
  final String id;
  final String customerName;
  final String serviceType;
  final String address;
  final double amount;
  final DateTime dateTime;
  JobStatus jobStatus;

  JobModel({
    required this.id,
    required this.customerName,
    required this.serviceType,
    required this.address,
    required this.amount,
    required this.dateTime,
    this.jobStatus = JobStatus.pending,
  });
}
