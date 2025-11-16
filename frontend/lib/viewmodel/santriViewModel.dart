import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:project_uas/model/santriModel.dart';
import 'package:http/http.dart' as http;

class SantriViewModel {
  Future<List<Santri>> getSantriByHalaqoh(String id_halaqoh) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:4000/santri?id_halaqoh=${id_halaqoh}'),
    );

    // print("masuk santri halaqoh ${id_halaqoh}");
    // print("after response");

    final List<dynamic> data = jsonDecode(response.body);
    // print("after data");

    List<Santri> santriList = data
        .map((item) => Santri.fromJson(item))
        .toList();

    // Debugging log
    print("Loaded Santri List: $santriList");
    return santriList;
  }
}
