import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrecoContainer extends StatelessWidget {
  final String label;
  final double preco;
  PrecoContainer({super.key, required this.preco, required this.label});

  final realBrasileiro = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
    name: 'BRL',
  );

  // @123Pibic2023

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(color: Color(0xFF1a456d)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Color(0xFF1a456d),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Text(label, style: TextStyle(color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              preco == 0
                  ? 'Sob consulta'
                  : realBrasileiro.format(preco).toString(),
            ),
          ),
        ],
      ),
    );
  }
}
