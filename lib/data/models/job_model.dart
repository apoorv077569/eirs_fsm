enum JobStatus { pending, accepted, inProgress, completed }

class JobModel {
  final String id;
  final String customerName;
  final String customerPhone;
  final String serviceType;
  final String address;
  final double amount;
  final DateTime dateTime;
  final double lat;
  final double lng;
  JobStatus jobStatus;

  JobModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.address,
    required this.amount,
    required this.dateTime,
    required this.lat,
    required this.lng,
    this.jobStatus = JobStatus.pending,
  });
}
