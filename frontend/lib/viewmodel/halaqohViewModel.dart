import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:project_uas/model/halaqohModel.dart';

class HalaqohViewModel {
  Future<Halaqoh> loadHalaqoh(String id_user) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:4000/halaqoh?id_user=${id_user}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Halaqoh.fromJson(data);
      } else {
        throw Exception('Gagal memuat halaqoh, status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error load halaqoh from API: ${e.toString()}');
    }
  }
}
