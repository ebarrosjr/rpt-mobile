import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rptmobile/widgets/h1.dart';

class CreditosPage extends StatelessWidget {
  CreditosPage({super.key});

  final List<String> _imageAssets = [
    'assets/logo_fiocruz.svg',
    'assets/finep.svg',
    'assets/logo_gov.svg',
    'assets/logo_sus.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a456d),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Image.asset('assets/logo_branco.png', height: 80),
                ],
              ),

              H1(titulo: 'Apoio e cooperação', cor: Colors.white),

              // Grid de logos (funciona dentro do SingleChildScrollView)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _imageAssets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5, // ajuste conforme o formato dos logos
                ),
                itemBuilder: (context, index) {
                  final path = _imageAssets[index];
                  final isSvg = path.toLowerCase().endsWith('.svg');

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: isSvg
                        ? SvgPicture.asset(path, fit: BoxFit.contain)
                        : Image.asset(path, fit: BoxFit.contain),
                  );
                },
              ),

              const SizedBox(height: 24),
              H1(titulo: 'Desenvolvimento', cor: Colors.white),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _CreditLine(
                      name: 'ELIANE CAMPAGNUCCI',
                      area: 'VPPCB - RPT',
                      role: 'Conmsultoria técnica',
                    ),
                    SizedBox(height: 15),
                    _CreditLine(
                      name: 'EVERTON C B JÚNIOR',
                      area: 'VPPCB - RPT',
                      role: 'Projeto e desenvolvimento',
                    ),
                    SizedBox(height: 15),
                    _CreditLine(
                      name: 'VICTOR REIS',
                      area: 'VPPCB - RPT',
                      role: 'Desenvolvimento',
                    ),
                    SizedBox(height: 15),
                    _CreditLine(
                      name: 'LEANDRO RIBEIRO',
                      area: 'VPPCB - Comunicação',
                      role: 'Layout e UX (User Experience)',
                    ),
                    SizedBox(height: 15),
                    _CreditLine(
                      name: 'MARIA VERSIANI',
                      area: 'VPPCB - Fomento à Pesquisa',
                      role: 'Q&A e Testes integrados',
                    ),
                    SizedBox(height: 15),
                    _CreditLine(
                      name: 'ERICK RAIMONDI',
                      area: 'VPPCB - Comunicação',
                      role: 'Google App SEO e Apple SEOA',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditLine extends StatelessWidget {
  final String name;
  final String area;
  final String role;

  const _CreditLine({
    required this.name,
    required this.area,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        const SizedBox(height: 2),
        Text(
          area,
          style: const TextStyle(color: Color.fromARGB(255, 30, 184, 211)),
        ),
        Text(role, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}
