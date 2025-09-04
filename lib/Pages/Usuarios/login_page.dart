import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:rptmobile/Controllers/plataformas_controller.dart';
import 'package:rptmobile/Pages/Comum/creditos.dart';
import 'package:rptmobile/Pages/Plataformas/tipo_plataforma.dart';
import 'package:rptmobile/Services/api.dart';
import 'package:rptmobile/Services/auth_service.dart';
import 'package:rptmobile/widgets/botoes_menu_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rptmobile/Pages/Comum/home_page.dart';
import 'package:rptmobile/Models/plataformas.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  bool _loading = false;
  List<Plataforma> _plataformas = [];
  bool _apiError = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPlataformas();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() => _loading = false);

      final uri = Uri.base;
      if (uri.scheme == "rptmobile" && uri.host == "auth") {
        final token = uri.queryParameters["token"];
        final success = uri.queryParameters["success"];
        final error = uri.queryParameters["error"];

        if (success == "true" && token != null) {
          // Salva o token usando GetX
          AuthService.to.saveUserData(token).then((_) {
            Get.find<PlataformasController>().atualizarPlataformas().then((_) {
              Get.offAll(() => const HomePage());
            });
          });
        } else if (error != null) {
          _showErrorDialog(error);
        }
      }
    }
  }

  Future<void> _saveUserData(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);

    // Decodifica o token para extrair dados do usuário
    final parts = token.split('.');
    if (parts.length == 2) {
      final payload = json.decode(utf8.decode(base64.decode(parts[0])));
      await prefs.setString('user_data', json.encode(payload['data']));
    }
  }

  void _showErrorDialog(String errorCode) {
    String message;

    switch (errorCode) {
      case 'sem_permissao':
        message = 'Você não possui permissão para acessar o sistema.';
        break;
      case 'cpf_nao_encontrado':
        message = 'CPF não encontrado na autenticação.';
        break;
      case 'cadastro_falhou':
        message = 'Falha ao criar cadastro. Entre em contato com o suporte.';
        break;
      default:
        message = 'Erro durante o login. Tente novamente.';
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Erro de Login'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadPlataformas() async {
    try {
      setState(() => _apiError = false);
      final plataformas = await Api.getPlataformas();

      if (mounted) {
        setState(() => _plataformas = plataformas);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _apiError = true);
      }
    }
  }

  Future<void> _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 50));

    final uri = Uri.parse(
      "https://plataformas.fiocruz.br/usuarios/login-unico-app",
    );

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        if (mounted) setState(() => _loading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildPlataformasGrid() {
    if (_apiError) {
      return Column(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 8),
          const Text(
            'Erro ao carregar plataformas',
            style: TextStyle(color: Colors.red),
          ),
          TextButton(
            onPressed: _loadPlataformas,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    if (_plataformas.isEmpty) {
      return const Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 8),
          Text('Carregando plataformas...'),
        ],
      );
    }

    return SizedBox(
      height: 3 * 100, // altura para 3 linhas
      child: GridView.count(
        crossAxisCount: 3,
        scrollDirection: Axis.horizontal,
        childAspectRatio: 1,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: _plataformas.map((plataforma) {
          return GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => TipoPlataformaPage(plataforma: plataforma),
              ),
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color(0xFFE2ECF5),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(5),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    "https://plataformas.fiocruz.br/img/${(plataforma.icone ?? 'ico_rpt.svg')}",
                    width: 40,
                    height: 40,
                  ),
                  const SizedBox(height: 10),
                  AutoSizeText(
                    plataforma.nome ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minFontSize: 8,
                    style: const TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _animatedFadeSlide(Widget child, int delayMs) {
    return TweenAnimationBuilder(
      tween: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, Offset offset, _) {
        return Transform.translate(
          offset: offset * 50,
          child: AnimatedOpacity(
            opacity: offset == Offset.zero ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),

              // Logo animada
              _animatedFadeSlide(
                Image.asset('assets/logo.png', height: 80),
                100,
              ),

              const SizedBox(height: 10),

              // Título animado
              _animatedFadeSlide(
                const Text(
                  'Nossas plataformas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                300,
              ),

              // Grid animada
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: _animatedFadeSlide(_buildPlataformasGrid(), 500),
              ),

              // Botões menu animados
              _animatedFadeSlide(const BotoesMenu(), 700),
              const SizedBox(height: 20),

              // Login animado
              _animatedFadeSlide(
                GestureDetector(
                  //onTap: _login,
                  onTap: () => Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => HomePage())),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      _loading
                          ? const CircularProgressIndicator(
                              color: Color.fromARGB(255, 32, 29, 70),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Para acompanhar suas solicitações, fazer orçamentos e gerenciar sua equipe, por favor realize o login clicando abaixo',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 12),
                                  Image.asset(
                                    'assets/acesso.png',
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                900,
              ),

              const SizedBox(height: 20),

              // Versão animada
              _animatedFadeSlide(
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => CreditosPage())),
                    child: const Text(
                      'Versão 1.0.0 - Release Candidate',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                1100,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
