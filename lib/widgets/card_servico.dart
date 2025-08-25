import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rptmobile/Models/servicos.dart';
import 'package:rptmobile/widgets/preco_container.dart';

class CardServico extends StatelessWidget {
  final Servico servico;
  const CardServico({super.key, required this.servico});

  Future<void> _baixarArquivo(BuildContext context, String url) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/${url.split('/').last}";
      await Dio().download(url, filePath);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Arquivo salvo em ${filePath}")));

      await OpenFile.open(filePath); // abre o PDF no app padrão
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao baixar arquivo: $e")));
    }
  }

  Future<void> _abrirOuBaixar(BuildContext context, String url) async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Norma de Utilização"),
        content: const Text("Deseja abrir o PDF ou baixar para o aparelho?"),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Não foi possível abrir o link"),
                  ),
                );
              }
            },
            child: const Text("Abrir"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _baixarArquivo(context, url);
            },
            child: const Text("Baixar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text(servico.sigla), Text(servico.plataforma)],
          ),
          Text(
            servico.servico,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1a456d),
            ),
          ),
          AutoSizeText(
            servico.equipamento,
            maxLines: 2,
            style: TextStyle(color: Colors.blueGrey[400]),
          ),
          if (servico.modelo != '') Text(servico.modelo),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Descrição do serviço'),
                        content: SingleChildScrollView(
                          child: Html(data: servico.descricaoServico),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Fechar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              if (servico.normaUtilizacao != null &&
                  servico.normaUtilizacao!.isNotEmpty)
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf, color: Colors.red),
                      onPressed: () => _abrirOuBaixar(
                        context,
                        'https://plataformas.fiocruz.br/documentos/${servico.normaUtilizacao!}',
                      ),
                    ),
                    const Text('Normas de utilização'),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PrecoContainer(
                preco: servico.precoFiocruz,
                label: 'R\$ Fiocruz',
              ),
              PrecoContainer(
                preco: servico.precoPublico,
                label: 'R\$ Público',
              ),
              PrecoContainer(
                preco: servico.precoPrivado,
                label: 'R\$ Privado',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
