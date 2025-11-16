import 'package:flutter/foundation.dart';

class Santri {
  final String id_santri;
  final String id_halaqoh;
  final String nama;
  final String kelas;

  Santri({
    required this.id_santri,
    required this.id_halaqoh,
    required this.nama,
    required this.kelas,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id_santri: json['id_santri'].toString(),
      id_halaqoh: json['id_halaqoh'].toString(),
      nama: json['nama'],
      kelas: json['kelas'],
    );
  }
}
