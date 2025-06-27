import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app_badge/flutter_app_badge.dart';

class BadgeCounter {
  static const String _badgeKey = 'badge_count';

  static Future<int> getBadgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_badgeKey) ?? 0;
  }

  static Future<void> setBadgeCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_badgeKey, count);
    FlutterAppBadge.count(count);
  }

  static Future<void> incrementBadgeCount() async {
    int currentCount = await getBadgeCount();
    await setBadgeCount(currentCount + 1);
  }

  static Future<void> resetBadgeCount() async {
    await setBadgeCount(0);
  }
}