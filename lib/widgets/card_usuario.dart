import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:rptmobile/Models/coordenacao.dart';
import 'package:url_launcher/url_launcher.dart';

class CardUsuario extends StatelessWidget {
  final Coordenacao membro;
  const CardUsuario({super.key, required this.membro});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              color: Color(0xFF1a456d),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
          ),
          Positioned(
            left: 11,
            top: 15,
            width: 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMemberImage(membro),
                    membro.lattes != null
                        ? GestureDetector(
                            onTap: () {
                              _launchURL(
                                "https://lattes.cnpq.br/${membro.lattes!}",
                              );
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage('assets/lattes.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : SizedBox(width: 1),
                  ],
                ),
                SizedBox(height: 10),
                AutoSizeText(
                  membro.nome!,
                  style: TextStyle(
                    color: Color(0xFF1a456d),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AutoSizeText(
                  membro.cargo ?? '',
                  style: TextStyle(color: Color(0xFF1a456d)),
                  softWrap: true,
                  wrapWords: true,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildPlaceholderIcon() {
  return Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      color: const Color(0xFFE2ECF5),
      borderRadius: BorderRadius.circular(40),
    ),
    child: const Icon(Icons.person, size: 40, color: Colors.grey),
  );
}

Widget _buildMemberImage(member) {
  if (member.foto != null && member.foto!.isNotEmpty) {
    // Verifica se é uma string base64
    if (member.foto!.startsWith('data:image/') ||
        member.foto!.contains('base64,')) {
      try {
        // Extrai a parte base64 da string
        final base64String = member.foto!.split('base64,').last;
        final imageBytes = base64.decode(base64String);

        return ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.memory(
            imageBytes,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholderIcon();
            },
          ),
        );
      } catch (e) {
        print('Erro ao decodificar base64: $e');
        return _buildPlaceholderIcon();
      }
    }
    // Verifica se é uma URL completa
    else if (member.foto!.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.network(
          member.foto!,
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE2ECF5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon();
          },
        ),
      );
    }
    // Verifica se é um caminho relativo
    else if (!member.foto!.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: Image.network(
          "https://plataformas.fiocruz.br/${member.foto}",
          width: 80,
          height: 80,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFE2ECF5),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderIcon();
          },
        ),
      );
    }
  }

  return _buildPlaceholderIcon();
}
