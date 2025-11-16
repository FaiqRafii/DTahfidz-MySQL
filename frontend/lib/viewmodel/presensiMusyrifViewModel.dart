import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:project_uas/model/presensiMusyrifModel.dart';

class PresensiMusyrifViewModel {
  Future<bool> addPresensiMusyrif(
    String id_user,
    String tanggal,
    String jam,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:4000/presensi/musyrif'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_user': id_user, 'tanggal': tanggal, 'jam': jam}),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error add presensi musyrif: ${e}");
    }
  }

  Future<List<PresensiMusyrif>> fetchPresensiById(
    String id_user,
    String tanggal,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://10.0.2.2:4000/presensi/musyrif?id_user=${id_user}&tanggal=${tanggal}',
        ),
      );

      final data = jsonDecode(response.body);
      List<PresensiMusyrif> presensiList = (data as List)
          .map((item) => PresensiMusyrif.fromJson(item))
          .toList();

      return presensiList;

      // List<PresensiMusyrif> presensiList = data
      //     .map((item) => PresensiMusyrif.fromJson(item))
      //     .toList();

      // // Debugging the filtered data
      // print(
      //   'Filtered presensiList: ${presensiList.where((presensi) => presensi.id_user == id_user && presensi.tanggal == tanggal)}',
      // );

      // return presensiList
      //     .where(
      //       (presensi) =>
      //           presensi.id_user == id_user && presensi.tanggal == tanggal,
      //     )
      //     .toList();
    } catch (e) {
      throw Exception(
        'Error loading presensi musyrif from API: ${e.toString()}',
      );
    }
  }
}
