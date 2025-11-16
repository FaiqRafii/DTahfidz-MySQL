import 'package:flutter/services.dart';

class Halaqoh {
  final String id_halaqoh;
  final String id_user;
  final String halaqoh;
  final String jumlah_santri;
  final String lokasi_halaqoh;

  Halaqoh({
    required this.id_halaqoh,
    required this.id_user,
    required this.halaqoh,
    required this.jumlah_santri,
    required this.lokasi_halaqoh,
  });

  factory Halaqoh.fromJson(Map<String, dynamic> json) {
    return Halaqoh(
      id_halaqoh: json['id_halaqoh'].toString(),
      id_user: json['id_user'].toString(),
      halaqoh: json['halaqoh'],
      jumlah_santri: json['jumlah_santri'].toString(),
      lokasi_halaqoh: json['lokasi_halaqoh'],
    );
  }
}
