import 'package:flutter/material.dart';
import 'package:rptmobile/Models/unidades.dart';
import 'package:rptmobile/Services/api.dart';

class UnidadesPage extends StatefulWidget {
  const UnidadesPage({super.key});

  @override
  State<UnidadesPage> createState() => _UnidadesPageState();
}

class _UnidadesPageState extends State<UnidadesPage> {
  late Future<List<Unidade>> _futureUnidades;

  @override
  void initState() {
    super.initState();
    _futureUnidades = Api.getUnidades();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nossas unidades'),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Column(
                children: [
                  Text(
                    'Os espaços tecnológicos da Rede de Plataformas estão presentes em nove estados do Brasil, compreendendo as regiões Sul, Sudeste, Norte e Nordeste.',
                  ),
                  SizedBox(height: 15),
                  Text(
                    "A Rede está alinhada à missão institucional da Fiocruz na promoção da Saúde e no fortalecimento do ambiente de Ciência Tecnologia e Inovação do país.",
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Unidade>>(
                future: _futureUnidades,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Erro: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("Nenhuma unidade encontrada"),
                    );
                  }

                  final unidades = snapshot.data!;

                  // Agrupar por estado
                  final estados = <String, List<Unidade>>{};
                  for (var u in unidades) {
                    estados.putIfAbsent(u.estado.nome, () => []).add(u);
                  }

                  return ListView(
                    children: estados.entries.map((estadoEntry) {
                      final estadoNome = estadoEntry.key;
                      final unidadesDoEstado = estadoEntry.value;

                      // Agrupar por unidade dentro do estado
                      final unidadesMap = <String, List<Unidade>>{};
                      for (var u in unidadesDoEstado) {
                        unidadesMap
                            .putIfAbsent(u.unidade.nome, () => [])
                            .add(u);
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Cabeçalho do estado
                          Container(
                            margin: const EdgeInsets.only(top: 12, bottom: 6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF1a456d),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              estadoNome,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Lista das unidades dentro do estado
                          ...unidadesMap.entries.map((unidadeEntry) {
                            final unidadeNome = unidadeEntry.key;
                            final plataformas = unidadeEntry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                    top: 6,
                                    bottom: 4,
                                    left: 4,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    unidadeNome,
                                    style: const TextStyle(
                                      color: Color(0xFF1a456d),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                // Lista de plataformas
                                ...plataformas.map(
                                  (p) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 2,
                                      bottom: 2,
                                    ),
                                    child: Text(
                                      "${p.sigla} - ${p.nome}",
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
