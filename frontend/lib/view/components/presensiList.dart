import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_uas/model/halaqohModel.dart';
import 'package:project_uas/model/presensiSantriModel.dart';
import 'package:project_uas/model/santriModel.dart';
import 'package:project_uas/model/waktuModel.dart';
import 'package:project_uas/viewmodel/presensiSantriViewModel.dart';
import 'package:project_uas/viewmodel/santriViewModel.dart';

class PresensiList extends StatefulWidget {
  final Halaqoh halaqoh;
  final DateTime selectedDate;
  final Waktu waktu;

  const PresensiList({
    super.key,
    required this.halaqoh,
    required this.selectedDate,
    required this.waktu,
  });

  @override
  State<PresensiList> createState() => _PresensiListState();
}

class _PresensiListState extends State<PresensiList> {
  late Future<List<Santri>> santriList;
  late Future<List<PresensiSantri>> presensiList;
  bool isLoading = false;

  // Menggunakan ValueNotifier untuk status presensi
  Map<String, ValueNotifier<String>> presensiStatuses = {}; // Tipe yang benar

  @override
  void initState() {
    super.initState();
    print("Halaqoh ID passed to PresensiList: ${widget.halaqoh.id_halaqoh}");

    String formattedDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);

    santriList = SantriViewModel().getSantriByHalaqoh(
      widget.halaqoh.id_halaqoh,
    );
    presensiList = PresensiSantriViewModel().getPresensiSantri(
      widget.halaqoh.id_halaqoh,
      formattedDate,
      widget.waktu.waktu,
    );
  }

  @override
  void didUpdateWidget(PresensiList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.waktu.waktu != widget.waktu.waktu ||
        oldWidget.selectedDate != widget.selectedDate) {
      String formattedDate = DateFormat(
        'dd-MM-yyyy',
      ).format(widget.selectedDate);

      // Update the presensiList when waktu changes
      setState(() {
        presensiList = PresensiSantriViewModel().getPresensiSantri(
          widget.halaqoh.id_halaqoh,
          formattedDate,
          widget.waktu.waktu, // Time updated here
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              children: [
                Text(
                  "Hadir",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
                Text(
                  "Izin",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
                Text(
                  "Sakit",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
                Text(
                  "Alfa",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 12),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: 24,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Santri>>(
              future: santriList,
              builder: (context, santriSnapshot) {
                if (santriSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (santriSnapshot.hasError) {
                  return Center(child: Text('Error ${santriSnapshot.error}'));
                } else if (!santriSnapshot.hasData ||
                    santriSnapshot.data!.isEmpty) {
                  return Center(child: Text('No Santri Found'));
                }

                return FutureBuilder<List<PresensiSantri>>(
                  future: presensiList,
                  builder: (context, presensiSnapshot) {
                    if (presensiSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (presensiSnapshot.hasError) {
                      return Center(
                        child: Text('Error ${presensiSnapshot.error}'),
                      );
                    }

                    List<PresensiSantri> presensiData = presensiSnapshot.data!;

                    // Initialize presensiStatuses with ValueNotifier
                    presensiStatuses.clear();
                    for (var santri in santriSnapshot.data!) {
                      PresensiSantri? presensi = presensiData.firstWhere(
                        (presensi) => presensi.id_santri == santri.id_santri,
                        orElse: () => PresensiSantri(
                          id_presensi: '',
                          nama: santri.nama,
                          id_santri: santri.id_santri,
                          tanggal: widget.selectedDate.day.toString(),
                          jam: widget.waktu.waktu,
                          status: '',
                        ),
                      );

                      presensiStatuses[santri.id_santri] = ValueNotifier(
                        presensi.status,
                      );
                    }

                    return ListView.builder(
                      itemCount: santriSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        Santri santri = santriSnapshot.data![index];
                        ValueNotifier<String> statusNotifier =
                            presensiStatuses[santri.id_santri]!;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                santri.nama,
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                // Radio untuk Hadir
                                ValueListenableBuilder<String>(
                                  valueListenable: statusNotifier,
                                  builder: (context, status, child) {
                                    return Radio<String>(
                                      value: 'hadir',
                                      groupValue: status,
                                      activeColor: Colors.green.shade700,
                                      onChanged: (String? value) {
                                        statusNotifier.value = value!;
                                        print(
                                          "Presensi Statuses: ${presensiStatuses}",
                                        );
                                      },
                                    );
                                  },
                                ),
                                // Radio untuk Izin
                                ValueListenableBuilder<String>(
                                  valueListenable: statusNotifier,
                                  builder: (context, status, child) {
                                    return Radio<String>(
                                      value: 'izin',
                                      groupValue: status,
                                      activeColor: Colors.green.shade700,
                                      onChanged: (String? value) {
                                        statusNotifier.value = value!;
                                        print(
                                          "Presensi Statuses: ${presensiStatuses}",
                                        );
                                      },
                                    );
                                  },
                                ),
                                // Radio untuk Sakit
                                ValueListenableBuilder<String>(
                                  valueListenable: statusNotifier,
                                  builder: (context, status, child) {
                                    return Radio<String>(
                                      value: 'sakit',
                                      groupValue: status,
                                      activeColor: Colors.green.shade700,
                                      onChanged: (String? value) {
                                        statusNotifier.value = value!;
                                        print(
                                          "Presensi Statuses: ${presensiStatuses}",
                                        );
                                      },
                                    );
                                  },
                                ),
                                ValueListenableBuilder<String>(
                                  valueListenable: statusNotifier,
                                  builder: (context, status, child) {
                                    return Radio<String>(
                                      value: 'alfa',
                                      groupValue: status,
                                      activeColor: Colors.green.shade700,
                                      onChanged: (String? value) {
                                        statusNotifier.value = value!;
                                        print(
                                          "Presensi Statuses: ${presensiStatuses}",
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                // setState(() {
                //   isLoading = true;
                // });
                bool send = await PresensiSantriViewModel().addPresensiSantri(
                  presensiStatuses,
                  DateFormat('dd-MM-yyyy').format(widget.selectedDate),
                  widget.waktu.waktu,
                );

                // setState(() {
                //   isLoading = false;
                // });

                if (send) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Presensi berhasil disimpan')),
                  );
                  String formattedDate = DateFormat(
                    'dd-MM-yyyy',
                  ).format(widget.selectedDate);
                  setState(() {
                    // Re-fetch santriList and presensiList
                    santriList = SantriViewModel().getSantriByHalaqoh(
                      widget.halaqoh.id_halaqoh,
                    );
                    presensiList = PresensiSantriViewModel().getPresensiSantri(
                      widget.halaqoh.id_halaqoh,
                      formattedDate,
                      widget.waktu.waktu,
                    );
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal menyimpan presensi")),
                  );
                }
              },
              child: isLoading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      'Simpan',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
