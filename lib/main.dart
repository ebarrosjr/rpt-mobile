import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rptmobile/Pages/Usuarios/login_page.dart';
import 'package:rptmobile/Pages/Comum/home_page.dart';
import 'package:rptmobile/Services/auth_service.dart';
import 'package:rptmobile/Services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(RptApp());
}

class RptApp extends StatelessWidget {
  RptApp({super.key});
  final NotificationService _notificationService = NotificationService();

  // Chaev privada Firebase: GJEJ6duew4RCTLW2bRTIhbrFYp5sNMGKXJS9HXsyrsU
  // Par de chaves Firebase: BBCMK_MRlNhn_ib9MJ_0USY89i9yPjgLbuc07XUf3FGP40IK3M8-21HUR72sGYRXuheztCC2f3j1xhhs0C03ifs

  @override
  Widget build(BuildContext context) {
    _notificationService.init();

    return GetMaterialApp(
      title: 'RPT Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _checkIfUserIsLogged(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(); // Tela de carregamento
          } else {
            return snapshot.data ?? const LoginPage();
          }
        },
      ),
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
    );
  }

  Future<Widget> _checkIfUserIsLogged() async {
    // Inicializa o AuthService
    final authService = Get.put(AuthService(), permanent: true);

    // Carrega os dados do usuário
    await authService.loadUserData();

    // Pequeno delay para garantir que tudo está carregado
    await Future.delayed(const Duration(milliseconds: 300));

    if (authService.isLogged.value && authService.token.value.isNotEmpty) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}

// Binding para inicializar os serviços
class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Os serviços serão inicializados no FutureBuilder
  }
}

// Tela de splash/loading personalizada
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            const Text(
              'Carregando...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
