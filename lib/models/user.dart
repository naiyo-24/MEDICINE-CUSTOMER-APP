import 'dart:convert';

class UserModel {
  final String? id;
  final String? phoneNumber;
  final String? name;
  final String? email;
  final String? token;

  UserModel({
    this.id,
    this.phoneNumber,
    this.name,
    this.email,
    this.token,
  });

  UserModel copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? token,
  }) {
    return UserModel(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'token': token,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      phoneNumber: map['phoneNumber'],
      name: map['name'],
      email: map['email'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, name: $name, email: $email, token: $token)';
  }
}
