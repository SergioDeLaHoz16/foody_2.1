import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:foody/features/inventory/models/models.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _plugin.initialize(settings);

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) {
        await ph.Permission.notification.request();
      }
    }
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'caducidad_channel',
      'Caducidad de productos',
      channelDescription: 'Notificaciones de productos próximos a caducar',
      importance: Importance.max,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await _plugin.show(id, title, body, details);
  }

  static Future<void> notifyExpiringProducts(List<Product> userProducts, String userEmail) async {
    final now = DateTime.now();

    for (final product in userProducts) {
      if (product.expiryDate.difference(now).inDays <= 3) {
        await showNotification(
          id: product.id.hashCode,
          title: '¡Producto por caducar!',
          body: 'El producto "${product.name}" caduca en ${product.expiryDate.difference(now).inDays} día(s).',
        );
      }
    }
  }
}