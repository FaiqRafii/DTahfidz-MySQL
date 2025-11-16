import 'package:flutter/foundation.dart';

class Santri {
  final String id_santri;
  final String id_halaqoh;
  final String nama;
  final String kelas;
  final String jns_kel;

  Santri({
    required this.id_santri,
    required this.id_halaqoh,
    required this.nama,
    required this.kelas,
    required this.jns_kel,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id_santri: json['id_santri'].toString(),
      id_halaqoh: json['id_halaqoh'].toString(),
      nama: json['nama'],
      kelas: json['kelas'],
      jns_kel: json['jns_kel'],
    );
  }
}
