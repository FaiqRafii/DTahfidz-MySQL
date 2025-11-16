import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:project_uas/view/presensi.dart';
import 'package:project_uas/view/password.dart';
import 'package:project_uas/view/profile.dart';
import 'package:project_uas/view/setoran.dart';
import 'view/login.dart';
import 'package:intl/intl.dart';
import 'view/home.dart';

void main() {
  initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MainApp());
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('id', 'ID'), // Tentukan lokal Indonesia
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // Tambahkan delegate ini
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: Colors.green.shade700,
        ),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.green.shade700,
          cursorColor: Colors.black,
          selectionHandleColor: Colors.green.shade700,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/home': (context) => Home(),
        '/presensi': (context) => Presensi(),
        '/setoran': (context) => Setoran(),
        '/profile': (context) => Profile(),
        '/password': (context) => Password(),
      },
    );
  }
}
