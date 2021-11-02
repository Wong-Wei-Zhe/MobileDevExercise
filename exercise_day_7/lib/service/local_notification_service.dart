import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class LocalNotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  //LocalNotificationServices();
  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channelid', 'channename',
            channelDescription: 'channeldescription',
            importance: Importance.max,
            priority: Priority.defaultPriority));
  }

  static Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      {
        flutterLocalNotificationsPlugin.show(
            id, title, body, await _notificationDetails(),
            payload: payload)
      };
}
