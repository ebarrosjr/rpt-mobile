import 'package:flutter/material.dart';
import 'package:rptmobile/Pages/Comum/a_rede_page.dart';
import 'package:rptmobile/Pages/Comum/comunicados.dart';
import 'package:rptmobile/Pages/Comum/coordenacao_page.dart';
import 'package:rptmobile/Pages/Comum/documentos.dart';
import 'package:rptmobile/Pages/Comum/fale_conosco.dart';
import 'package:rptmobile/Pages/Comum/unidades_page.dart';

class BotoesMenu extends StatelessWidget {
  const BotoesMenu({super.key});

  // Mapa que associa cada texto do botão com a página correspondente
  final Map<String, Widget> _botoesNavegacao = const {
    "A rede": ARedePage(), // Pode ser substituído por uma página real
    "Comunicados": ComunicadosPage(),
    "Unidades": UnidadesPage(),
    "Documentos": DocumentosPage(),
    "Fale Conosco": FaleConoscoPage(),
    "Coordenação": CoordenacaoPage(),
  };

  @override
  Widget build(BuildContext context) {
    final List<String> textos = _botoesNavegacao.keys.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: textos.sublist(0, 3).map((texto) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a456d),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _navegarParaPagina(context, texto);
                    },
                    child: Text(
                      texto,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: textos.sublist(3).map((texto) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a456d),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _navegarParaPagina(context, texto);
                    },
                    child: Text(
                      texto,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Função para navegar para a página correspondente
  void _navegarParaPagina(BuildContext context, String texto) {
    final pagina = _botoesNavegacao[texto];

    if (pagina != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => pagina));
    } else {
      // Para botões sem página definida (como placeholder)
      debugPrint("Clicou em $texto (página não implementada)");

      // Opcional: mostrar um snackbar informativo
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$texto - Funcionalidade em desenvolvimento'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
