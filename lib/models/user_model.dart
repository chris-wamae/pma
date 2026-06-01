class UserModel {
  final String uid;
  final String email;
  String? name;
  String role;
  String? phoneNumber;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.role = 'Owner',
    this.phoneNumber,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'role': role,
        'phoneNumber': phoneNumber,
        'createdAt': createdAt.toIso8601String(),
      };

  static UserModel fromJson(Map<String, dynamic> json) => UserModel(
        uid: json['uid'] as String,
        email: json['email'] as String,
        name: json['name'] as String?,
        role: json['role'] as String? ?? 'Owner',
        phoneNumber: json['phoneNumber'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'] as String)
            : null,
      );
}
