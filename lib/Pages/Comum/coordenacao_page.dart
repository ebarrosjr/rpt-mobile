import 'package:flutter/material.dart';
import 'package:rptmobile/Models/coordenacao.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:rptmobile/widgets/card_usuario.dart';

class CoordenacaoPage extends StatefulWidget {
  const CoordenacaoPage({super.key});

  @override
  State<CoordenacaoPage> createState() => _CoordenacaoPageState();
}

class _CoordenacaoPageState extends State<CoordenacaoPage> {
  List<Coordenacao> _coordenacao = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCoordenacao();
  }

  Future<void> _loadCoordenacao() async {
    setState(() {
      loading = true;
    });

    final coordenacaoList = await Api.getCoordenacao();
    if (mounted) {
      setState(() {
        _coordenacao = coordenacaoList;
        loading = false;
      });
      debugPrint('Estado atualizado com ${_coordenacao.length} membros');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossa equipe de coordenação'),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.only(bottom: 20),
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              'A operação da RPT-Fiocruz é conduzida por uma equipe técnica de mais de 200 profissionais altamente especializados composta por mestres e doutores nas mais diversas áreas de conhecimento.',
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
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.count(
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      childAspectRatio: 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: _coordenacao.map((coordenacao) {
                        return CardUsuario(membro: coordenacao);
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
