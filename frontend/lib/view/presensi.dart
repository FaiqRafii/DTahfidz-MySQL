import 'package:flutter/material.dart';
import 'package:project_uas/model/halaqohModel.dart';
import 'package:project_uas/model/userModel.dart';
import 'package:project_uas/model/waktuModel.dart';
import 'package:project_uas/view/components/presensiList.dart';
import 'package:project_uas/viewmodel/waktuViewModel.dart';

class Presensi extends StatefulWidget {
  const Presensi({super.key});

  @override
  State<Presensi> createState() => _PresensiState();
}

class _PresensiState extends State<Presensi> {
  DateTime selectedDate = DateTime.now();
  Waktu waktu = Waktu(waktu: 'subuh');

  String get formattedDate {
    return "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cekWaktU();
  }

  void _cekWaktU() {
    Waktu waktuDariModel = WaktuViewModel().cekWaktu();
    setState(() {
      waktu = waktuDariModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Halaqoh halaqoh =
        ModalRoute.of(context)?.settings.arguments as Halaqoh;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Presensi Santri',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.15,
              color: Colors.green.shade700,
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 4),
                        Icon(Icons.person, color: Colors.white, size: 20),
                        Text(
                          halaqoh.jumlah_santri,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _selectDate(context),
                      child: Container(
                        width: 165,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
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
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          waktu = Waktu(waktu: 'subuh');
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: waktu.waktu == 'subuh'
                              ? Colors.white
                              : Colors.green.shade700,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.wb_sunny_rounded,
                              size: 17,
                              color: waktu.waktu == 'subuh'
                                  ? Colors.green.shade700
                                  : Colors.white,
                            ),
                            Text(
                              'Subuh',
                              style: TextStyle(
                                fontSize: 8,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: waktu.waktu == 'subuh'
                                    ? Colors.green.shade700
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          waktu = Waktu(waktu: 'malam');
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          color: waktu.waktu == 'malam'
                              ? Colors.white
                              : Colors.green.shade700,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.nights_stay,
                                size: 17,
                                color: waktu.waktu == 'malam'
                                    ? Colors.green.shade700
                                    : Colors.white,
                              ),
                              Text(
                                'Malam',
                                style: TextStyle(
                                  fontSize: 8,
                                  fontFamily: 'Poppins',
                                  color: waktu.waktu == 'malam'
                                      ? Colors.green.shade700
                                      : Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
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
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: PresensiList(
                halaqoh: halaqoh,
                selectedDate: selectedDate,
                waktu: waktu,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
