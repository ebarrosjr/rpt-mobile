import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rptmobile/Controllers/plataformas_controller.dart';
import 'package:rptmobile/Pages/Usuarios/login_page.dart';
import 'package:rptmobile/Pages/Comum/home_page.dart';
import 'package:rptmobile/Services/auth_service.dart';
import 'package:rptmobile/Services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Controllers globais
  Get.put(PlataformasController(), permanent: true);

  runApp(const RptApp());
}

class RptApp extends StatelessWidget {
  const RptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RPT Mobile',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashWrapper(),
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      opaqueRoute: Get.isOpaqueRouteDefault,
      popGesture: Get.isPopGestureEnable,
    );
  }
}

/// SplashWrapper gerencia inicializações assíncronas antes de decidir a tela inicial
class SplashWrapper extends StatelessWidget {
  const SplashWrapper({super.key});

  Future<Widget> _initApp() async {
    // Inicializa notificações
    final notificationService = NotificationService();
    await notificationService.init();

    // Inicializa AuthService
    final authService = Get.put(AuthService(), permanent: true);
    await authService.loadUserData();

    // Pequeno delay para UX
    await Future.delayed(const Duration(milliseconds: 300));

    if (authService.isLogged.value && authService.token.value.isNotEmpty) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text(
                "Erro ao inicializar o app: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          return snapshot.data ?? const LoginPage();
        }
      },
    );
  }
}

// Binding para inicializar dependências globais
class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Outros serviços podem ser inicializados aqui futuramente
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
