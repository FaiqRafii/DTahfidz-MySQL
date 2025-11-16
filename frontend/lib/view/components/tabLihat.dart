import 'package:flutter/material.dart';
import 'package:project_uas/model/quranModel.dart';
import 'package:project_uas/model/setoranSantriModel.dart';
import 'package:project_uas/viewmodel/quranViewModel.dart';
import 'package:project_uas/viewmodel/setoranSantriViewModel.dart';
import 'package:intl/intl.dart';

class TabLihat extends StatefulWidget {
  final String selectedIdSantri;
  const TabLihat({super.key, required this.selectedIdSantri});

  @override
  State<TabLihat> createState() => _TabLihatState();
}

class _TabLihatState extends State<TabLihat> {
  late Future<List<Setoran>> setoranList;

  // Declare missing variables
  TextEditingController searchController = TextEditingController();
  List<Quran> surahList = [];
  List<Quran> filteredSurahList = [];
  Map<String, String> selectedSurahAwal = {'id_surah': '', 'nama_surah': ''};
  Map<String, String> selectedSurahAkhir = {'id_surah': '', 'nama_surah': ''};
  bool isLoading = false;
  bool isLoadingUpdate = false;
  bool isLoadingHapus = false;

  @override
  void didUpdateWidget(TabLihat oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedIdSantri != widget.selectedIdSantri) {
      setoranList = SetoranSantriViewModel().getSetoranSantriByIdSantri(
        widget.selectedIdSantri,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    setoranList = SetoranSantriViewModel().getSetoranSantriByIdSantri(
      widget.selectedIdSantri,
    );
    loadSurahList(); // Load Surah List when widget is initialized
  }

  // Function to load Surah data
  Future<void> loadSurahList() async {
    List<Quran> data = await QuranViewModel().fetchData();
    setState(() {
      surahList = data;
      filteredSurahList = surahList;
      selectedSurahAwal = {};
      selectedSurahAkhir = {};
    });
  }

  // Function to search Surah based on the query
  void searchSurah(String query) {
    final results = surahList.where((surah) {
      return surah.nama_surah.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSurahList = results;
    });
  }

  Future<Map<String, String>?> _showSurahDialog(
    BuildContext context,
    String posisi,
  ) {
    return showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade700),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari Surah',
                          hintStyle: TextStyle(fontFamily: 'Poppins'),
                          prefixIcon: Icon(Icons.search),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade700,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade100),
                          ),
                        ),
                        onChanged: (query) {
                          searchSurah(query); // Panggil pencarian saat mengetik
                          setState(() {});
                        },
                      ),
                    ),
                    // Add a check to see if filteredSurahList is empty or not
                    filteredSurahList.isEmpty
                        ? Center(
                            child: Text(
                              'No Surah Found',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredSurahList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    filteredSurahList[index].nama_surah,
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      if (posisi == 'mulai') {
                                        selectedSurahAwal = {
                                          'id_surah':
                                              filteredSurahList[index].id_surah,
                                          'nama_surah': filteredSurahList[index]
                                              .nama_surah,
                                        };
                                      } else {
                                        selectedSurahAkhir = {
                                          'id_surah':
                                              filteredSurahList[index].id_surah,
                                          'nama_surah': filteredSurahList[index]
                                              .nama_surah,
                                        };
                                      }
                                    });

                                    Navigator.of(context).pop({
                                      'id_surah':
                                          filteredSurahList[index].id_surah,
                                      'nama_surah':
                                          filteredSurahList[index].nama_surah,
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showUpdateSetoranDialog(BuildContext context, Setoran setoran) {
    TextEditingController ayatMulaiController = TextEditingController(
      text: setoran.ayat_mulai,
    );
    TextEditingController ayatAkhirController = TextEditingController(
      text: setoran.ayat_akhir,
    );
    DateTime selectedDate = DateFormat('dd-MM-yyyy').parse(setoran.tanggal);

    TextEditingController tanggalController = TextEditingController(
      text: DateFormat('dd-MM-yyyy').format(selectedDate),
    );

    String selectedWaktu = setoran.waktu;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 15,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Update Setoran',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          onPressed: () {
                            Navigator.of(context).pop();

                            selectedSurahAwal.clear();
                            selectedSurahAkhir.clear();
                          },
                          icon: Icon(Icons.close_rounded),
                        ),
                      ],
                    ),

                    // Tanggal (Date)
                    Row(
                      spacing: 10,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime? picked = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(21001),
                                    locale: const Locale('id', 'ID'),
                                  );
                                  if (picked != null &&
                                      picked != selectedDate) {
                                    setStateDialog(() {
                                      selectedDate = picked;
                                      tanggalController.text = DateFormat(
                                        'dd-MM-yyyy',
                                      ).format(selectedDate);
                                    });
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        SizedBox(width: 10),
                                        //datepicker
                                        Text(
                                          tanggalController.text,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.green.shade700,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // child: TextField(
                          //   controller: tanggalController,
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //     labelText: 'Tanggal',
                          //     hintText: 'Select Tanggal',
                          //     border: OutlineInputBorder(),
                          //   ),
                          //   onTap: () async {
                          //     final DateTime? picked = await showDatePicker(
                          //       context: context,
                          //       initialDate: selectedDate,
                          //       firstDate: DateTime(2000),
                          //       lastDate: DateTime(2101),
                          //       locale: const Locale('id', 'ID'),
                          //     );
                          //     if (picked != null && picked != selectedDate) {
                          //       setStateDialog(() {
                          //         selectedDate = picked;
                          //         tanggalController.text = DateFormat(
                          //           'dd-MM-yyyy',
                          //         ).format(selectedDate);
                          //       });
                          //     }
                          //   },
                          // ),
                        ),
                        Flexible(
                          flex: 5,
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Waktu',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                              Container(
                                height: 56,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                                child: DropdownButton<String>(
                                  underline: SizedBox.shrink(),
                                  dropdownColor: Colors.white,
                                  value: selectedWaktu,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors
                                        .green
                                        .shade700, // Ganti warna panah di sini
                                  ),
                                  iconSize: 30,
                                  isExpanded: true,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  onChanged: (String? value) {
                                    setStateDialog(() {
                                      selectedWaktu = value!;
                                    });
                                  },
                                  items: [
                                    DropdownMenuItem<String>(
                                      value: 'subuh',
                                      child: Text('Subuh'),
                                    ),
                                    DropdownMenuItem<String>(
                                      value: 'malam',
                                      child: Text('Malam'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Waktu (Subuh/Malam)
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: ListTile(
                    //         title: Text(
                    //           'Subuh',
                    //           style: TextStyle(
                    //             fontFamily: 'Poppins',
                    //             fontSize: 13,
                    //           ),
                    //         ),
                    //         leading: Radio<String>(
                    //           value: 'subuh',
                    //           groupValue: selectedWaktu,
                    //           onChanged: (String? value) {
                    //             setStateDialog(() {
                    //               selectedWaktu = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: ListTile(
                    //         title: Text('Malam'),
                    //         leading: Radio<String>(
                    //           value: 'malam',
                    //           groupValue: selectedWaktu,
                    //           onChanged: (String? value) {
                    //             setStateDialog(() {
                    //               selectedWaktu = value!;
                    //             });
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // Surah Mulai
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayat Mulai',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Flexible(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await _showSurahDialog(
                                    context,
                                    'mulai',
                                  );
                                  if (result != null) {
                                    setStateDialog(() {
                                      selectedSurahAwal = result;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.book,
                                          color: Colors.green.shade700,
                                          size: 25,
                                        ),
                                        //datepicker
                                        Text(
                                          selectedSurahAwal['nama_surah'] ??
                                              setoran.id_surah_mulai,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.green.shade700,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                controller: ayatMulaiController,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  hintText: 'Ayat Mulai',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Surah Akhir
                    Column(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ayat Akhir',
                          style: TextStyle(fontFamily: 'Poppins'),
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Flexible(
                              flex: 7,
                              child: GestureDetector(
                                onTap: () async {
                                  final result = await _showSurahDialog(
                                    context,
                                    'akhir',
                                  );
                                  if (result != null) {
                                    setStateDialog(() {
                                      selectedSurahAkhir = result;
                                    });
                                  }
                                },
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.book,
                                          color: Colors.green.shade700,
                                          size: 25,
                                        ),
                                        //datepicker
                                        Text(
                                          selectedSurahAkhir['nama_surah'] ??
                                              setoran.id_surah_akhir,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down_rounded,
                                          color: Colors.green.shade700,
                                          size: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: TextField(
                                controller: ayatAkhirController,
                                keyboardType: TextInputType.numberWithOptions(),
                                decoration: InputDecoration(
                                  hintText: 'Ayat Akhir',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Action buttons (Update or Cancel)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Row(
                          spacing: 10,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                setStateDialog(() {
                                  isLoadingHapus = true;
                                });
                                bool success = await SetoranSantriViewModel()
                                    .deleteSetoran(setoran.id_setoran);

                                setStateDialog(() {
                                  isLoadingHapus = false;
                                });

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Berhasil menghapus setoran',
                                      ),
                                    ),
                                  );
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog

                                  setState(() {
                                    setoranList = SetoranSantriViewModel()
                                        .getSetoranSantriByIdSantri(
                                          widget.selectedIdSantri,
                                        );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Gagal menghapus setoran'),
                                    ),
                                  );
                                }
                              },
                              child: isLoadingHapus
                                  ? SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : Text(
                                      'Hapus',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                setStateDialog(() {
                                  isLoadingUpdate = true;
                                });
                                bool success = await SetoranSantriViewModel()
                                    .updateSetoran(
                                      setoran
                                          .id_setoran, // The ID of the setoran to be updated
                                      tanggalController.text,
                                      selectedWaktu,
                                      selectedSurahAwal['nama_surah'] ??
                                          setoran.id_surah_mulai,
                                      ayatMulaiController
                                          .text, // The new Ayat Mulai
                                      selectedSurahAkhir['nama_surah'] ??
                                          setoran.id_surah_akhir,
                                      ayatAkhirController.text,
                                    );

                                setStateDialog(() {
                                  isLoadingUpdate = false;
                                  selectedSurahAwal.clear();
                                  selectedSurahAkhir.clear();
                                });

                                if (success) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Setoran updated successfully',
                                      ),
                                    ),
                                  );
                                  Navigator.of(
                                    context,
                                  ).pop(); // Close the dialog

                                  setState(() {
                                    setoranList = SetoranSantriViewModel()
                                        .getSetoranSantriByIdSantri(
                                          widget.selectedIdSantri,
                                        );
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to update setoran'),
                                    ),
                                  );
                                }
                              },
                              child: isLoadingUpdate
                                  ? SizedBox(
                                      width: 10,
                                      height: 10,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : Text(
                                      'Update',
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
                                  borderRadius: BorderRadiusGeometry.circular(
                                    10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    ).then((value) {
      setState(() {
        selectedSurahAwal.clear();
        selectedSurahAkhir.clear();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Expanded(
        child: FutureBuilder<List<Setoran>>(
          future: setoranList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No Setoran Found, selected id santri: ${widget.selectedIdSantri}',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
              );
            }

            List<Setoran> setoran = snapshot.data!;

            return ListView.builder(
              itemCount: setoran.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showUpdateSetoranDialog(context, setoran[index]);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  setoran[index].tanggal,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: setoran[index].waktu == 'subuh'
                                        ? Colors.amber.shade100
                                        : Colors.blue.shade100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Text(
                                      setoran[index].waktu == 'subuh'
                                          ? 'Subuh'
                                          : 'Malam',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: setoran[index].waktu == 'subuh'
                                            ? Colors.amber.shade700
                                            : Colors.blue.shade700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Table(
                              border: TableBorder(
                                verticalInside: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ayat Mulai',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                            color: Colors.grey.shade500,
                                          ),
                                        ),
                                        Text(
                                          '${setoran[index].id_surah_mulai} : ${setoran[index].ayat_mulai}',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Ayat Akhir',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                              color: Colors.grey.shade500,
                                            ),
                                          ),
                                          Text(
                                            '${setoran[index].id_surah_akhir} : ${setoran[index].ayat_akhir}',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
