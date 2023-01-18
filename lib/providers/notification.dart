import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.high),
    );
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await _notification.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }
}
