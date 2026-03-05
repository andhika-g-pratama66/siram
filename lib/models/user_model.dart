import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final int? id;
  final String fullName;
  final String email;
  final String password;
  final String? location;
  final String? dob;
  final String? gender;
  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.location,
    this.dob,
    this.gender,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'location': location,
      'dob': dob,
      'gender': gender,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as int : null,
      fullName: map['fullName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      location: map['location'] != null ? map['location'] as String : null,
      dob: map['dob'] != null ? map['dob'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
