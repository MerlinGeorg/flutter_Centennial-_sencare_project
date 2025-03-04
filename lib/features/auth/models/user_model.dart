

class UserModel {
  final String id;
  final String name;
  final String email;
 // final String password;

  UserModel({
    required this.id,
    required this.name,
    required this.email
  });

  // Create a UserModel from a map (useful when parsing JSON)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'] ?? '', name: json['name'] ?? '', email: json['email'] ?? '');
  }

  // Convert UserModel to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email
    };
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }

}