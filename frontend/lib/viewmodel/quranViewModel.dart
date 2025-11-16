import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:project_uas/model/quranModel.dart';

class QuranViewModel {
  Future<List<Quran>> fetchData() async {
    final response = await http.get(
      Uri.parse('https://quran-api.santrikoding.com/api/surah'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((data) => Quran.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
