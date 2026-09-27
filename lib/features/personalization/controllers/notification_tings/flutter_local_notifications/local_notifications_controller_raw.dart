import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rintel/features/store/models/inv_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  tz.initializeTimeZones();
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings iosSettings =
      DarwinInitializationSettings();
  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(settings);
}

Future<void> scheduleDailyExpiryReminder({
  required int id,
  required String itemName,
  required DateTime expiryDate,
}) async {
  // Calculate time from expiry date (e.g., notify 1 day before at 9:00 AM)
  final notifyDate = expiryDate.subtract(const Duration(days: 1));
  final tz.TZDateTime scheduledTime = tz.TZDateTime(
    tz.local,
    notifyDate.year,
    notifyDate.month,
    notifyDate.day,
    9,
  );

  // Only schedule if in the future
  if (scheduledTime.isBefore(tz.TZDateTime.now(tz.local))) {
    return;
  }

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: AndroidNotificationDetails(
      'expiry_channel',
      'Expiry Reminders',
      importance: Importance.max,
      priority: Priority.max,
    ),
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    id,
    'Expiry Alert',
    '$itemName expires in 1 day!',
    scheduledTime,
    platformChannelSpecifics,
    androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    matchDateTimeComponents: DateTimeComponents.dateAndTime,
  );
}

// Example usage for a list of items
void scheduleAllItems(List<CInventoryModel> inventoryItems) {
  for (var invItem in inventoryItems) {
    scheduleDailyExpiryReminder(
      id: invItem.productId.hashCode, // Unique ID per item
      itemName: invItem.name,
      expiryDate: DateTime.parse(invItem.expiryDate.replaceAll(' @', '')),
    );
  }
}
