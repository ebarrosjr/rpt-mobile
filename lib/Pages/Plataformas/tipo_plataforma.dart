import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rptmobile/Models/plataformas.dart';
import 'package:rptmobile/Models/servicos.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:rptmobile/widgets/card_servico.dart';

class TipoPlataformaPage extends StatefulWidget {
  final Plataforma plataforma;
  const TipoPlataformaPage({super.key, required this.plataforma});

  @override
  State<TipoPlataformaPage> createState() => _TipoPlataformaPageState();
}

class _TipoPlataformaPageState extends State<TipoPlataformaPage> {
  bool _isExpanded = false;
  final double _collapsedHeight = 120;
  double _expandedHeight = 200; // Valor inicial, será calculado
  List<Servico> servicos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadServicos();
  }

  Future<void> _loadServicos() async {
    setState(() {
      loading = true;
    });

    final servicosList = await Api.getServicos(
      tipoPlataformaId: widget.plataforma.id!,
    );
    if (mounted) {
      setState(() {
        servicos = servicosList;
        loading = false;
      });
      debugPrint('Estado atualizado com ${servicos.length} servicos');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calcula a altura necessária para o texto expandido
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: widget.plataforma.descricao!,
        style: TextStyle(fontSize: 16), // Use o estilo padrão do texto
      ),
      textDirection: TextDirection.ltr,
      maxLines: null,
    );
    textPainter.layout(
      maxWidth: MediaQuery.of(context).size.width * 0.9 - 32,
    ); // Largura - padding
    _expandedHeight =
        textPainter.size.height +
        50; // Altura do texto + espaço para o indicador

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plataforma.nome!),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                SvgPicture.network(
                  "https://plataformas.fiocruz.br/img/${(widget.plataforma.icone ?? 'ico_rpt.svg')}",
                  width: 40,
                  height: 40,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 20,
                        top: 20,
                        right: 20,
                      ),
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: _isExpanded ? _expandedHeight : _collapsedHeight,
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        physics:
                            NeverScrollableScrollPhysics(), // Desabilita scroll interno
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.plataforma.descricao!,
                              maxLines: _isExpanded ? null : 3,
                              overflow: _isExpanded
                                  ? null
                                  : TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                _isExpanded
                                    ? 'Clique para recolher'
                                    : 'Clique para expandir',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[700],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '${servicos.length.toString()} serviços prestados',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  loading
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF1a456d),
                              ),
                              SizedBox(height: 8),
                              Text('Carregando ...'),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true, // ✅ deixa o ListView se ajustar
                          physics:
                              NeverScrollableScrollPhysics(), // ✅ evita conflito de scroll
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: servicos.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                CardServico(servico: servicos[index]),
                                const SizedBox(height: 15),
                              ],
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
