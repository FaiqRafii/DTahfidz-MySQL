import 'package:flutter/material.dart';
import 'package:project_uas/model/halaqohModel.dart';
import 'package:project_uas/model/quranModel.dart';
import 'package:project_uas/model/santriModel.dart';
import 'package:project_uas/view/components/tabLihat.dart';
import 'package:project_uas/view/components/tabTambah.dart';
import 'package:project_uas/viewmodel/quranViewModel.dart';
import 'package:project_uas/viewmodel/santriViewModel.dart';

class Setoran extends StatefulWidget {
  const Setoran({super.key});

  @override
  State<Setoran> createState() => _SetoranState();
}

class _SetoranState extends State<Setoran> with SingleTickerProviderStateMixin {
  late TabController tabController;
  Map<String, String> selectedSantri = {}; // Initialize selectedSantri

  List<Santri> santriList = [];
  List<Santri> filteredSantriList = [];

  Halaqoh? halaqoh;
  String idAwal = "";

  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  List<Quran> surahList = [];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    halaqoh = ModalRoute.of(context)?.settings.arguments as Halaqoh?;

    if (halaqoh != null) {
      setState(() {
        isLoading = true;
      });
      loadSantriList();
      setState(() {
        isLoading = false;
      });
    } else {
      // Handle error if halaqoh is null, e.g., show an error message
      print("Halaqoh is null");
    }
  }

  Future<void> loadSantriList() async {
    List<Santri> data = await SantriViewModel().getSantriByHalaqoh(
      halaqoh!.id_halaqoh,
    );

    setState(() {
      santriList = data;
      filteredSantriList = santriList;

      if (santriList.isNotEmpty) {
        idAwal = santriList.first.id_santri;

        // 💡 JANGAN overwrite jika user sudah memilih santri
        if (selectedSantri.isEmpty) {
          selectedSantri = {
            'id_user': santriList.first.id_santri,
            'nama': santriList.first.nama,
          };
        }
      }
    });
  }

  // Function to search surah based on the query
  void searchSurah(String query) {
    final results = santriList.where((santri) {
      return santri.nama.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredSantriList = results;
    });
  }

  void _showSantriDialog(BuildContext context) {
    searchController.clear();
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
                          hintText: 'Cari santri',
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
                    filteredSantriList.isEmpty
                        ? Center(
                            child: Text(
                              'No Santri Found',
                              style: TextStyle(fontFamily: 'Poppins'),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: filteredSantriList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    filteredSantriList[index].nama,
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedSantri = {
                                        'id_user':
                                            filteredSantriList[index].id_santri,
                                        'nama': filteredSantriList[index].nama,
                                      };
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green.shade700,
        title: Text(
          'Setoran Hafalan',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.green.shade700),
            )
          : Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    decoration: BoxDecoration(color: Colors.green.shade700),
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 56,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: GestureDetector(
                              onTap: () => _showSantriDialog(context),
                              child: Container(
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
                                        Icons.person,
                                        color: Colors.green.shade700,
                                        size: 25,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 5,
                                          ),
                                          child: Text(
                                            selectedSantri['nama'] ??
                                                (santriList.isNotEmpty
                                                    ? santriList.first.nama
                                                    : 'Memuat...'),
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
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
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.13,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: TabBar(
                                labelColor: Colors.white,
                                unselectedLabelColor: Colors.green.shade700,
                                indicatorColor: Colors.green.shade700,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorWeight: 2,
                                unselectedLabelStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                                dividerColor: Colors.grey.shade100,
                                labelStyle: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                indicator: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                controller: tabController,
                                tabs: [
                                  Tab(text: 'Tambah'),
                                  Tab(text: 'Lihat'),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: [
                                TabTambah(
                                  id_santri:
                                      selectedSantri['id_user'] ?? idAwal,
                                ),
                                TabLihat(
                                  selectedIdSantri:
                                      selectedSantri['id_user'] ?? idAwal,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
