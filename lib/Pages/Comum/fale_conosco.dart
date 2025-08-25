import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class FaleConoscoPage extends StatefulWidget {
  const FaleConoscoPage({super.key});

  @override
  State<FaleConoscoPage> createState() => _FaleConoscoPageState();
}

class _FaleConoscoPageState extends State<FaleConoscoPage> {
  // Função genérica para lançar URLs com tratamento de erro
  Future<void> _launchUrl(
    String urlString, {
    LaunchMode mode = LaunchMode.platformDefault,
    String? fallbackUrl,
  }) async {
    try {
      final url = Uri.parse(urlString);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: mode);
      } else if (fallbackUrl != null) {
        final fallback = Uri.parse(fallbackUrl);
        if (await canLaunchUrl(fallback)) {
          await launchUrl(fallback, mode: LaunchMode.platformDefault);
        } else {
          _mostrarErro('Não foi possível abrir o aplicativo');
        }
      } else {
        _mostrarErro('Não foi possível abrir o aplicativo');
      }
    } catch (e) {
      _mostrarErro('Erro ao abrir: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  // Função para abrir opções de navegação
  Future<void> _abrirNavegacao() async {
    final endereco = Uri.encodeComponent(
      'Av Brasil, 4365, Castelo Mourisco, Sala 109, Manguinhos',
    );

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.map, color: Colors.blue),
                title: Text('Google Maps'),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(
                    'https://www.google.com/maps/search/?api=1&query=$endereco',
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.navigation, color: Colors.purple),
                title: Text('Waze'),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(
                    'https://waze.com/ul?q=$endereco',
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.map, color: Colors.red),
                title: Text('Apple Maps'),
                onTap: () {
                  Navigator.pop(context);
                  _launchUrl(
                    'https://maps.apple.com/?q=$endereco',
                    mode: LaunchMode.externalApplication,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Função para abrir WhatsApp
  Future<void> _abrirWhatsApp() async {
    await _launchUrl(
      'https://wa.me/5521996103104',
      mode: LaunchMode.externalApplication,
    );
  }

  // Função para abrir e-mail - usa platformDefault para permitir escolha do usuário
  Future<void> _abrirEmail() async {
    await _launchUrl(
      'mailto:plataformas@fiocruz.br',
      mode: LaunchMode.platformDefault,
    );
  }

  // Função para abrir site do Interact - usa externalApplication para abrir no navegador
  Future<void> _abrirInteract() async {
    await _launchUrl(
      'https://interact.fiocruz.br:8443/sa/custom/webtickets/anonymous/access.jsp?form=Fale_conosco',
      mode: LaunchMode.externalApplication,
    );
  }

  // Função para fazer ligação telefônica - usa platformDefault
  Future<void> _fazerLigacao() async {
    await _launchUrl('tel:+552138851972', mode: LaunchMode.platformDefault);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fale com a Rede'),
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F6FA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(left: 20, bottom: 20, top: 20, right: 20),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Além de um canal direto pelo Interact, você também pode entrar em contato pelos meios abaixo.',
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Presencialmente',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _abrirNavegacao,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.red),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Endereço',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Av Brasil, 4365, Castelo Mourisco, Sala 109, Manguinhos',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.navigation, color: Colors.blue),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Via mensagens',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: [
                  // WhatsApp
                  GestureDetector(
                    onTap: _abrirWhatsApp,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset('assets/whatsapp.svg', width: 45),
                          SizedBox(height: 8),
                          Text(
                            'WhatsApp',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(21) 99610-3104',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // E-mail
                  GestureDetector(
                    onTap: _abrirEmail,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email, color: Colors.blue, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'E-mail',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'plataformas@fiocruz.br',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Interact
                  GestureDetector(
                    onTap: _abrirInteract,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/interact_logo.svg',
                            width: 40,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Interact',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Acessar plataforma',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Telefone
                  GestureDetector(
                    onTap: _fazerLigacao,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.phone, color: Colors.red, size: 40),
                          SizedBox(height: 8),
                          Text(
                            'Telefone',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '(21) 3885-1972',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
