import 'package:flutter/material.dart';
import 'package:project_uas/model/halaqohModel.dart';
import 'package:project_uas/model/presensiMusyrifModel.dart';
import 'package:project_uas/model/userModel.dart';
import 'package:project_uas/model/waktuModel.dart';
import 'package:project_uas/viewmodel/halaqohViewModel.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/viewmodel/presensiMusyrifViewModel.dart';
import 'package:project_uas/viewmodel/waktuViewModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user;
  HalaqohViewModel halaqohViewModel = HalaqohViewModel();
  Halaqoh? halaqoh;
  late Future<List<PresensiMusyrif>> presensiMusyrif;
  bool isLoading = true;
  bool isLoadingHadir = false;
  WaktuViewModel waktuViewModel = WaktuViewModel();
  String? waktuStatus;
  String isFull = '';

  Future<void> loadHalaqohHome(User user) async {
    final Halaqoh filteredHalaqoh = await halaqohViewModel.loadHalaqoh(
      user!.id_user,
    );

    setState(() {
      halaqoh = filteredHalaqoh;
      isLoading = false;
    });
    // print("masuk loadhalaqohhome");
    // final User user = ModalRoute.of(context)?.settings.arguments as User;
    // final List<Halaqoh> allHalaqoh = await halaqohViewModel.loadHalaqoh();
    // print("Semua Halaqoh: $allHalaqoh"); // Debugging: Print semua data halaqoh

    // final filteredHalaqoh = allHalaqoh.firstWhere(
    //   (halaqoh) => halaqoh.id_user == user.id_user,
    //   orElse: () => Halaqoh(
    //     id_halaqoh: '',
    //     id_user: 'Not Found',
    //     halaqoh: 'Not Found',
    //     jumlah_santri: '0',
    //     lokasi_halaqoh: 'Not Found',
    //   ),
    // );
    // print(
    //   "Filtered Halaqoh: $filteredHalaqoh",
    // ); // Debugging: Print halaqoh yang difilter

    // setState(() {
    //   halaqoh = filteredHalaqoh;
    //   isLoading = false;
    // });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    user = ModalRoute.of(context)?.settings.arguments as User?;

    loadHalaqohHome(user!);

    Waktu WaktuChecked = waktuViewModel.cekWaktu();
    setState(() {
      presensiMusyrif = PresensiMusyrifViewModel().fetchPresensiById(
        user!.id_user,
        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
      );
      waktuStatus = WaktuChecked.waktu;
    });
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)?.settings.arguments as User;

    bool isSubuhPresensi = false;
    bool isMalamPresensi = false;

    DateTime sekarang = DateTime.now();
    String tanggalFormatted = DateFormat(
      "d MMMM yyyy",
      "id_ID",
    ).format(sekarang);
    String tanggalAngka = '${sekarang.day}-${sekarang.month}-${sekarang.year}';
    String hari = DateFormat("EEEE", "id_ID").format(sekarang);
    String jam = DateFormat("HH:mm:ss").format(sekarang);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade100,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 20,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile', arguments: user);
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.grey.shade100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.green.shade100,
                              child: Text(
                                this.user!.nama.isNotEmpty
                                    ? this.user!.nama[0].toUpperCase()
                                    : '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${this.user!.nama}',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
                child: Column(
                  spacing: 20,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.green.shade700,
                      ),
                      child: Column(
                        spacing: 20,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              isLoading
                                  ? Container(
                                      height: 25,
                                      width: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    )
                                  : Text(
                                      halaqoh?.halaqoh ?? 'Not Found',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 17,
                                      ),
                                    ),

                              Row(
                                spacing: 5,
                                children: [
                                  Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 17,
                                  ),
                                  Text(
                                    halaqoh?.jumlah_santri == null
                                        ? ''
                                        : '${halaqoh?.jumlah_santri} Santri',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 5,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  halaqoh?.lokasi_halaqoh ?? 'Not Found',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      spacing: 20,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          spacing: 20,
                          children: [
                            Column(
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/presensi',
                                        arguments: halaqoh,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.co_present,
                                      color: Colors.green.shade700,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    color: Colors.green.shade100,
                                  ),
                                ),
                                Text(
                                  'Presensi\nSantri',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/setoran',
                                        arguments: halaqoh,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.post_add_rounded,
                                      color: Colors.green.shade700,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    color: Colors.green.shade100,
                                  ),
                                ),
                                Text(
                                  'Setoran\nHafalan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          hari,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Text(
                                          tanggalFormatted,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    waktuStatus == 'subuh'
                                        ? JamTahfidz('subuh')
                                        : waktuStatus == 'malam'
                                        ? JamTahfidz('malam')
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                FutureBuilder(
                                  future: presensiMusyrif,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Center(
                                        child: Text('Error: ${snapshot.error}'),
                                      );
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      return Table(
                                        border: TableBorder.symmetric(
                                          inside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        children: [
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Waktu',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Subuh',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  isSubuhPresensi
                                                      ? 'Hadir'
                                                      : 'Belum Presensi',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Malam',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  isMalamPresensi
                                                      ? 'Hadir'
                                                      : 'Belum Presensi',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      List<PresensiMusyrif> presensiList =
                                          snapshot.data!;

                                      if (presensiList.isNotEmpty) {
                                        // Iterate through the presensiList to check for specific times
                                        for (var presensi in presensiList) {
                                          if (presensi.jam == 'subuh') {
                                            isSubuhPresensi = true;
                                          } else if (presensi.jam == 'malam') {
                                            isMalamPresensi = true;
                                          }
                                        }
                                      } else {
                                        isSubuhPresensi = false;
                                        isMalamPresensi = false;
                                      }

                                      if (isSubuhPresensi && isSubuhPresensi) {
                                        isFull = 'yes';
                                      }

                                      return Table(
                                        border: TableBorder.symmetric(
                                          inside: BorderSide(
                                            width: 1,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                        children: [
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Waktu',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Status',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Subuh',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  isSubuhPresensi
                                                      ? 'Hadir'
                                                      : 'Belum Presensi',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          TableRow(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  'Malam',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.all(8),
                                                child: Text(
                                                  isMalamPresensi
                                                      ? 'Hadir'
                                                      : 'Belum Presensi',
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                ),

                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed:
                                        isFull == "yes" || waktuStatus == 'none'
                                        ? null
                                        : () async {
                                            setState(() {
                                              isLoadingHadir = true;
                                            });
                                            final add =
                                                await PresensiMusyrifViewModel()
                                                    .addPresensiMusyrif(
                                                      user!.id_user,
                                                      tanggalAngka,
                                                      waktuStatus!,
                                                    );
                                            if (add) {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    "Berhasil Absen",
                                                  ),
                                                ),
                                              );

                                              setState(() {
                                                presensiMusyrif =
                                                    PresensiMusyrifViewModel()
                                                        .fetchPresensiById(
                                                          user!.id_user,
                                                          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                                                        );
                                                isLoadingHadir = false;
                                              });
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text("Gagal Absen"),
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.green.shade700,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: isLoadingHadir
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1,
                                            ),
                                          )
                                        : Text('Hadir'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget JamTahfidz(String waktu) {
    if (waktu == 'subuh') {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          spacing: 5,
          children: [
            Icon(Icons.wb_sunny_rounded, color: Colors.amber.shade900),
            Text(
              'Subuh',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Colors.amber.shade900,
              ),
            ),
          ],
        ),
      );
    } else if (waktu == 'malam') {
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          spacing: 5,
          children: [
            // Icon(Icons.wb_sunn)
            Icon(Icons.nights_stay, color: Colors.blue.shade900),
            Text(
              'Malam',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); // Jika waktu tidak valid, tampilkan widget kosong
    }
  }
}
