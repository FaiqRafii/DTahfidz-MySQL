import 'package:flutter/services.dart';
import 'package:project_uas/model/userModel.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginViewModel {
  Future<List<User>> loadUsers() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/user.json',
      );
      final data = json.decode(response);

      if (data is List) {
        return data.map((userJson) => User.fromJson(userJson)).toList();
      } else {
        throw Exception("Data format tidak sesuai");
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> login(String email, String password) async {
    Map<String, String> headers = {'Content-Type': 'application/json'};

    Map<String, dynamic> body = {'email': email, 'password': password};

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.10:4000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return User.fromJson(data);
      }

      return null; // <-- WAJIB ADA
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null; // <-- supaya Flutter tidak menggantung
    }

    // List<User> users = await loadUsers();

    // for (var user in users) {
    //   if (user.email == email && user.password == password) {
    //     return user;
    //   }
    // }
    // return null;
  }
}
