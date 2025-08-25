import 'package:flutter/material.dart';

class ARedePage extends StatelessWidget {
  const ARedePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A nossa rede'),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(left: 20, bottom: 40),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.blue[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 100),
              SizedBox(height: 30),
              Text(
                'A Rede de Plataformas Tecnológicas da Fiocruz é um conjunto de tecnologias e equipamentos destinados à pesquisa, desenvolvimento tecnológico, inovação, vigilância e assistência disponível para atender as demandas de instituições públicas e privadas.',
              ),
              SizedBox(height: 15),
              Text(
                'Sua operação é conduzida por uma equipe técnica de mais de 200 profissionais altamente especializados composta por mestres e doutores nas mais diversas áreas de conhecimento.',
              ),
              SizedBox(height: 15),
              Text(
                'Possuímos um parque tecnológico com equipamentos aptos para uso, com manutenção garantida e confiabilidade nos resultados.',
              ),
              SizedBox(height: 15),
              Text(
                'Os espaços tecnológicos da Rede de Plataformas estão presentes em nove estados do Brasil, compreendendo as regiões Sul, Sudeste, Norte e Nordeste.',
              ),
              SizedBox(height: 15),
              Text(
                'A Rede está alinhada à missão institucional da Fiocruz na promoção da Saúde e no fortalecimento do ambiente de Ciência Tecnologia e Inovação do país.',
              ),
              SizedBox(height: 15),
              Text(
                'Maiores informações sobre a gestão, governança e utilização da rede estão disponíveis no documento de Normas e Diretrizes e sua portaria correlata.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
