import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Message title: ${message.notification?.title}');
  print('Message body: ${message.notification?.body}');
  print('Message payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.defaultImportance,
  );

  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    print('Handle message function called');
  }

  Future<String> getAccessToken() async {
    final serviceAccountJson = {
  "type": "service_account",
  "project_id": "squeaky-database",
  "private_key_id": dotenv.env['GOOGLE_PRIVATE_KEY_ID']!,
  "private_key": dotenv.env['GOOGLE_PRIVATE_KEY']!,
  "client_email": dotenv.env['GOOGLE_CLIENT_EMAIL']!,
  "client_id": dotenv.env['GOOGLE_CLIENT_ID']!,
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": dotenv.env['GOOGLE_CLIENT_X509_CERT_URL']!,
  "universe_domain": "googleapis.com"
};

    List<String> scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',      
    ];

    http.Client client = await auth.clientViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
     scopes);

    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(auth.ServiceAccountCredentials.fromJson(serviceAccountJson), scopes, client);
  
    client.close();

    return credentials.accessToken.data;
  }

  Future<void> sendNotification(String recieverFCM) async {
    print('Send notification function called');

    final String serviceKey = await getAccessToken();

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Host': 'fcm.googleapis.com',
      'Authorization': 'Bearer $serviceKey'};
    
    var data = jsonEncode({
          'message': {
            'token': recieverFCM,
            'notification': {
              'title': 'New Message',
              'body': 'You have a new message!'
            }
          }
        });

    await http.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/squeaky-database/messages:send'),
        headers: headers,
        body: data);
    
    print('Notification sent');
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      handleMessage(message);
    });
    FirebaseMessaging.onBackgroundMessage(
        (message) => handleBackgroundMessage(message));
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
              _androidChannel.id, _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher'),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  Future initLocalNotifications() async {
    const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(iOS: iOS, android: android);

    await _localNotifications.initialize(settings,
        onSelectNotification: (payload) {
      final message = RemoteMessage.fromMap(jsonDecode(payload!));
      handleMessage(message);
    });

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future<void> init() async {
    await _firebaseMessaging.requestPermission();
    final token = await _firebaseMessaging.getToken();

    print('FirebaseMessaging token: $token');

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    initPushNotifications();
    initLocalNotifications();
  }

  Future getFCMToken() async {
    print('updating fcm token..');
    return await _firebaseMessaging.getToken();
  }
}
