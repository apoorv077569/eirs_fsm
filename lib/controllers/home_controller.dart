import 'package:eirs_fsm/data/models/job_model.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isOnline = false.obs;

  var newRequests = <JobModel>[].obs;
  var myJobs = <JobModel>[].obs;
  

  @override
  void onInit() {
    super.onInit();
    loadMockData();
  }
  void toggleOnline(bool val){
    isOnline.value = val;
  }
  void loadMockData(){
    newRequests.addAll([
      JobModel(
        id: "101",
        customerName: "Rahul Sharma",
        customerPhone: "1234567890",
        serviceType: "AC Repair",
        address: "B-12 Sector 62 Noida",
        amount: 450.00,
        dateTime: DateTime.now(),
        lat: 28.6289,
        lng: 77.3723,
        jobStatus: JobStatus.pending
      ),
      JobModel(
        id: "102",
        customerName: "Aarya Yadav",
        customerPhone: "0987654321",
        serviceType: "Laptop Repair",
        address: "Indira Nagar Lucknow",
        amount: 1000.00,
        dateTime: DateTime.now().add(const Duration(hours: 1)),
        lat: 26.8594,
        lng: 80.9698,
        jobStatus: JobStatus.pending
      ),
    ]);
    myJobs.addAll([
      JobModel(
        id: "201",
        customerName: "Daini Daniels",
        serviceType: "Plumbuing",
        address: "Golf Course Road,New York",
        amount: 350.00,
        dateTime: DateTime.now().subtract(const Duration(hours: 2)),
        lat: 40.7831,
        lng: -73.9712,
        customerPhone: "1234567890",
        jobStatus: JobStatus.accepted
      ),
    ]);
  }
}