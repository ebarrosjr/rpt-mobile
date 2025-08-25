import 'package:flutter/material.dart';
import 'package:rptmobile/Pages/Comum/drawer_screen.dart';
import 'package:rptmobile/Pages/Comum/home_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          HomeScreen(),
        ],
      ),
    );
  }
}
