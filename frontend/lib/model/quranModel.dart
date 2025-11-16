class Quran {
  final String id_surah;
  final String nama_surah;

  Quran({required this.id_surah, required this.nama_surah});

  factory Quran.fromJson(Map<String, dynamic> json) {
    return Quran(
      id_surah: json['nomor'].toString(),
      nama_surah: json['nama_latin'],
    );
  }
}
