import 'package:intl/intl.dart';

class Setoran {
  final String id_setoran;
  final String id_santri;
  final String tanggal;
  final String waktu;
  String id_surah_mulai;
  final String ayat_mulai;
  String id_surah_akhir;
  final String ayat_akhir;

  Setoran({
    required this.id_setoran,
    required this.id_santri,
    required this.tanggal,
    required this.waktu,
    required this.id_surah_mulai,
    required this.ayat_mulai,
    required this.id_surah_akhir,
    required this.ayat_akhir,
  });

  factory Setoran.fromJson(Map<String, dynamic> json) {
    String formattedDate = DateFormat(
      'dd-MM-yyyy',
    ).format(DateTime.parse(json['tanggal']));

    return Setoran(
      id_setoran: json['id_setoran'].toString(),
      id_santri: json['id_santri'].toString(),
      tanggal: formattedDate,
      waktu: json['jam'],
      id_surah_mulai: json['id_surah_mulai'].toString(),
      ayat_mulai: json['ayat_mulai'].toString(),
      id_surah_akhir: json['id_surah_akhir'].toString(),
      ayat_akhir: json['ayat_akhir'].toString(),
    );
  }
}
