class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UserModel(
      id: documentId,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
