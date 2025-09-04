import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Configuração Android
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuração iOS (Darwin)
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Inicialização cruzada
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Tratar clique na notificação
        if (response.payload != null) {
          print("Payload da notificação: ${response.payload}");
        }
      },
    );

    // Pedir permissão no iOS
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Token FCM (Firebase Cloud Messaging)
    String? fcmToken = await _messaging.getToken();
    print("TOKEN FCM: $fcmToken");

    // Token APNS (somente iOS, em device físico)
    String? apnsToken = await _messaging.getAPNSToken();
    print("TOKEN APNS: $apnsToken");

    // TODO: enviar tokens para seu backend CakePHP

    // Listener para mensagens em foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = notification?.android;

      if (notification != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: android != null
                ? const AndroidNotificationDetails(
                    'canal_principal',
                    'Notificações',
                    importance: Importance.high,
                    priority: Priority.high,
                  )
                : null,
            iOS: const DarwinNotificationDetails(),
          ),
        );
      }
    });
  }
}
