class Waktu {
  final String waktu;

  Waktu({required this.waktu});

  cekWaktu() {
    DateTime sekarang = DateTime.now();

    DateTime jamMulaiSubuh = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
      4,
      30,
    );
    DateTime jamSelesaiSubuh = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
      05,
      30,
    );

    DateTime jamMulaiMalam = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
      18,
      30,
    );
    DateTime jamSelesaiMalam = DateTime(
      sekarang.year,
      sekarang.month,
      sekarang.day,
      19,
      30,
    );

    if (sekarang.isAfter(jamMulaiSubuh) && sekarang.isBefore(jamSelesaiSubuh)) {
      return Waktu(waktu: 'subuh');
    } else if (sekarang.isAfter(jamMulaiMalam) &&
        sekarang.isBefore(jamSelesaiMalam)) {
      return Waktu(waktu: 'malam');
    } else {
      return Waktu(waktu: 'none');
    }
  }
}
