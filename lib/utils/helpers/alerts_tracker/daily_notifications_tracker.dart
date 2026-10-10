import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CDailyNotificationsTracker {
  static final box = GetStorage();
  static const _dateKey = 'alertDate';
  static const _countKey = 'alertCount';

  /// -- this is called every time the notification is triggered --
  static void onAlertTriggered() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final storedDate = box.read<String>(_dateKey);

    if (storedDate != today) {
      // new day → reset
      box.write(_dateKey, today);
      box.write(_countKey, 1);
    } else {
      // Same day → increment
      final current = box.read<int>(_countKey) ?? 0;
      box.write(_countKey, current + 1);
    }
  }

  /// -- returns how many times the notification fired today (0 if none) --
  static int getTodayAlertsCount() {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final storedDate = box.read<String>(_dateKey);

    if (storedDate != today) return 0;
    return box.read<int>(_countKey) ?? 0;
  }
}
