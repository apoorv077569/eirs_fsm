enum UserRole{serviceStaff,deliveryStaff}

class UserModel {
  final String id;
  final String name;
  final String phone;
  final UserRole role;
  bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.isOnline = true,
  });
}