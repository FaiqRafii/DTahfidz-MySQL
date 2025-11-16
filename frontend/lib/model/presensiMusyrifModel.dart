class PresensiMusyrif {
  final String id_presensi;
  final String id_user;
  final String tanggal;
  final String jam;
  final String status;

  PresensiMusyrif({
    required this.id_presensi,
    required this.id_user,
    required this.tanggal,
    required this.jam,
    required this.status,
  });

  factory PresensiMusyrif.fromJson(Map<String, dynamic> json) {
    return PresensiMusyrif(
      id_presensi: json['id_presensi'].toString(),
      id_user: json['id_user'].toString(),
      tanggal: json['tanggal'],
      jam: json['jam'],
      status: json['status'],
    );
  }
}
