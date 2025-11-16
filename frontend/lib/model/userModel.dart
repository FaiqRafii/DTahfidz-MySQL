import 'package:flutter/services.dart';

class User {
  final String email;
  final String nama;
  final String id_user;
  final String level;

  User({
    required this.email,
    required this.nama,
    required this.id_user,
    required this.level,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      nama: json['nama'],
      id_user: json['id_user'].toString(),
      level: json['level'],
    );
  }
}
