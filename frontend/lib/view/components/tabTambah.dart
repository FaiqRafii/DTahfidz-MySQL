import 'package:flutter/material.dart';
import 'package:project_uas/model/quranModel.dart';
import 'package:project_uas/viewmodel/quranViewModel.dart';
import 'package:project_uas/viewmodel/setoranSantriViewModel.dart';

class TabTambah extends StatefulWidget {
  final String id_santri;
  const TabTambah({super.key, required this.id_santri});

  @override
  State<TabTambah> createState() => _TabTambahState();
}

class _TabTambahState extends State<TabTambah> {
  DateTime selectedDate = DateTime.now();
  final TextEditingController ayatAkhirController = TextEditingController();
  final TextEditingController ayatMulaiController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  String selectedWaktu = 'subuh';
  bool isLoading = false;

  Map<String, String> selectedSurahAwal = {};
  Map<String, String> selectedSurahAkhir = {};
  String? selectedIdSurahMulai;
  String? selectedIdSurahAkhir;

  List<Quran> surahList = [];
  List<Quran> filteredSurahList = [];

  String get formattedDate {
    return "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
  }

  @override
  void initState() {
    super.initState();
    // surahList = widget.surahList;
    // print("tab tambah surah list: ${widget.surahList}");
    // filteredSurahList = List.from(surahList);
    loadSurahList();
    print("filtered surah list: ${filteredSurahList}");
  }

  // Function to load Surah data
  Future<void> loadSurahList() async {
    List<Quran> data = await QuranViewModel().fetchData();
    setState(() {
      surahList = data;
      filteredSurahList = surahList;
      selectedSurahAwal = {
        'id_surah': surahList.first.id_surah,
        'nama_surah': surahList.first.nama_surah,
      };
      selectedSurahAkhir = {
        'id_surah': surahList.first.id_surah,
        'nama_surah': surahList.first.nama_surah,
      };
      print("surah list: ${surahList}");
    });
  }

  // Function to search surah based on the query
  void searchSurah(String query) {
    final results = surahList.where((surah) {
      return surah.nama_surah.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSurahList = results;
    });

    print('Filtered Surahs: ${filteredSurahList.length}');
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('id', 'ID'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.green.shade700, // Warna tombol dan aksen
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Function to show Surah dialog
  void _showSurahDialog(BuildContext context, String posisi) {
    showDialog(
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

                                    Navigator.of(
                                      context,
                                    ).pop(); // Close dialog after selecting
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

  @override
  Widget build(BuildContext context) {
    if (filteredSurahList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Column(
              spacing: 20,
              children: [
                Row(
                  spacing: 20,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.shade700),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.green.shade700,
                                  size: 25,
                                ),
                                SizedBox(width: 10),
                                //datepicker
                                Text(
                                  formattedDate,
                                  style: TextStyle(fontFamily: 'Poppins'),
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
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          initialSelection: selectedWaktu,
                          leadingIcon: Icon(
                            Icons.watch_later_outlined,
                            color: Colors.green.shade700,
                          ),
                          textStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),

                          dropdownMenuEntries: [
                            DropdownMenuEntry<String>(
                              value: 'subuh',
                              label: 'Subuh',
                            ),
                            DropdownMenuEntry<String>(
                              value: 'malam',
                              label: 'Malam',
                            ),
                          ],
                          onSelected: (String? value) {
                            setState(() {
                              selectedWaktu = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Ayat Mulai',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 17),
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: GestureDetector(
                            onTap: () => _showSurahDialog(context, 'mulai'),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade700),
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
                                          surahList.first.nama_surah,
                                      style: TextStyle(fontFamily: 'Poppins'),
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
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.black,
                            controller: ayatMulaiController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: 'Ayat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      'Ayat Akhir',
                      style: TextStyle(fontFamily: 'Poppins', fontSize: 17),
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),

                          child: GestureDetector(
                            onTap: () => _showSurahDialog(context, 'akhir'),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade700),
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
                                          surahList.first.nama_surah,
                                      style: TextStyle(fontFamily: 'Poppins'),
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
                        Expanded(
                          child: TextField(
                            cursorColor: Colors.black,
                            controller: ayatAkhirController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              hintText: 'Ayat',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              hintStyle: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade700,
                                ),
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
            SizedBox(height: 80),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (selectedWaktu != null &&
                      selectedSurahAwal['id_surah'] != null &&
                      selectedSurahAkhir['id_surah'] != null &&
                      ayatMulaiController.text.isNotEmpty &&
                      ayatAkhirController.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                    final add = await SetoranSantriViewModel().addSetoran(
                      widget.id_santri,
                      formattedDate,
                      selectedWaktu!,
                      selectedSurahAwal['id_surah']!,
                      ayatMulaiController.value.text,
                      selectedSurahAkhir['id_surah']!,
                      ayatAkhirController.value.text,
                    );

                    if (add) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Berhasil Menyimpan Setoran")),
                      );
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal Menyimpan Setoran")),
                      );
                    }
                  } else {
                    // Show an error or validation message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Pastikan semua data terisi dengan benar",
                        ),
                      ),
                    );
                  }
                },
                child: isLoading
                    ? SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1,
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
      ),
    );
  }
}
