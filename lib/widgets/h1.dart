import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String titulo;
  final Color cor;
  const H1({
    super.key,
    required this.titulo,
    this.cor = const Color.fromARGB(255, 4, 43, 75),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Text(
        titulo,
        style: TextStyle(fontWeight: FontWeight.w800, color: cor),
      ),
    );
  }
}
