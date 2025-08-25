import 'package:flutter/material.dart';
import 'package:rptmobile/Models/noticias.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:rptmobile/widgets/noticias_card.dart';

class ComunicadosPage extends StatefulWidget {
  const ComunicadosPage({super.key});

  @override
  State<ComunicadosPage> createState() => _ComunicadosPageState();
}

class _ComunicadosPageState extends State<ComunicadosPage> {
  List<Noticia> noticias = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadNoticias();
  }

  Future<void> _loadNoticias() async {
    setState(() {
      loading = true;
    });

    final noticiasList = await Api.getNoticias();
    if (mounted) {
      setState(() {
        noticias = noticiasList;
        loading = false;
      });
      debugPrint('Estado atualizado com ${noticias.length} membros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avisos, Notícias e Comunicados'),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(left: 20, bottom: 10),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'Informações sobre funcionamento de equipamentos, plataformas e avisos da coordenação.',
            ),
          ),
          Expanded(
            child: loading
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: Color(0xFF1a456d)),
                        SizedBox(height: 8),
                        Text('Carregando ...'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: noticias.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          NoticiasCard(noticia: noticias[index]),
                          const SizedBox(height: 15), // espaço entre os cards
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
