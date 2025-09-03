// services/auth_service.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:rptmobile/Pages/Usuarios/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxController {
  static AuthService get to => Get.find();

  final RxBool isLogged = false.obs;
  final RxMap<String, dynamic> userData = RxMap<String, dynamic>();
  final RxString token = ''.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Carrega os dados quando o serviço é inicializado
    loadUserData();
  }

  Future<void> loadUserData() async {
    if (isInitialized.value) return;

    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('user_token');

    if (storedToken != null && storedToken.isNotEmpty) {
      token.value = storedToken;
      isLogged.value = true;

      final userDataString = prefs.getString('user_data');
      if (userDataString != null) {
        try {
          userData.value = Map<String, dynamic>.from(
            json.decode(userDataString),
          );
        } catch (e) {
          print('Erro ao decodificar user_data: $e');
        }
      }

      // Verifica se o token é válido
      _validateToken(storedToken);
    }

    isInitialized.value = true;
  }

  void _validateToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 2) {
        final payload = json.decode(utf8.decode(base64.decode(parts[0])));
        final exp = payload['exp'] as int?;

        if (exp != null && DateTime.now().millisecondsSinceEpoch > exp * 1000) {
          // Token expirado
          logout();
        }
      }
    } catch (e) {
      print('Erro ao validar token: $e');
      logout();
    }
  }

  Future<void> saveUserData(String newToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', newToken);
    token.value = newToken;
    isLogged.value = true;

    final parts = newToken.split('.');
    if (parts.length == 2) {
      try {
        final payload = json.decode(utf8.decode(base64.decode(parts[0])));
        if (payload['data'] != null) {
          userData.value = Map<String, dynamic>.from(payload['data']);
          await prefs.setString('user_data', json.encode(payload['data']));
        }
      } catch (e) {
        print('Erro ao decodificar token: $e');
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
    await prefs.remove('user_data');

    isLogged.value = false;
    userData.clear();
    token.value = '';
    isInitialized.value = false;

    // Navega para a página de login
    Get.offAll(() => const LoginPage());
  }

  bool get isAdmin => userData['admin'] == true;
  String get userName => userData['nome'] ?? '';
  String get userEmail => userData['email'] ?? '';
  String get userCpf => userData['cpf'] ?? '';
  int get userId => userData['id'] ?? 0;
}
