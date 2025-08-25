import 'package:flutter/material.dart';
import 'package:rptmobile/Pages/Usuarios/login_page.dart';

void main() {
  runApp(const RptApp());
}

class RptApp extends StatelessWidget {
  const RptApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RPT Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
