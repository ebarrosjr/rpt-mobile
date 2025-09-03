import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Inicializar notificações locais
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(initSettings);

    // Pedir permissão
    await _messaging.requestPermission();

    // Token do dispositivo
    String? token = await _messaging.getToken();
    print("TOKEN DO DEVICE: $token");

    // TODO: Enviar token para o backend CakePHP

    // Listener para mensagens foreground
    FirebaseMessaging.onMessage.listen((message) {
      _localNotifications.show(
        0,
        message.notification?.title,
        message.notification?.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'canal_principal',
            'Notificações',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
    });
  }
}
