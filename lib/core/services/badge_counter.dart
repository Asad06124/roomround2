import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BadgeCounter {
  static const String _badgeKey = 'badge_count';
  static const platform = MethodChannel('com.example.roomrounds/badge');

  // Initialize the badge counter system
  static Future<void> initialize() async {
    try {
      // Set up method call handler for native-to-Flutter communication
      platform.setMethodCallHandler(_handleMethodCall);
      // On startup, always reset badge count to 0
      await resetBadgeCount();
    } catch (e) {
      print('Error initializing BadgeCounter: $e');
    }
  }

  // Handle method calls from native iOS
  static Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'syncBadgeCount':
        if (call.arguments != null && call.arguments['count'] != null) {
          int nativeBadgeCount = call.arguments['count'];
          await _updateLocalBadgeCount(nativeBadgeCount);
        }
        break;
      default:
        print('Unknown method call from native: ${call.method}');
    }
  }

  // Get badge count from SharedPreferences
  static Future<int> getBadgeCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_badgeKey) ?? 0;
  }

  // Get badge count from native iOS
  static Future<int> getNativeBadgeCount() async {
    try {
      final int count = await platform.invokeMethod('getBadgeCount');
      return count;
    } on PlatformException catch (e) {
      print('Error getting native badge count: $e');
      return 0;
    }
  }

  // Set badge count (updates both local storage and native badge)
  static Future<void> setBadgeCount(int count) async {
    print('[BadgeCounter] setBadgeCount called with: $count');
    
    // Ensure count is not negative
    count = count < 0 ? 0 : count;
    
    // Update local storage
    await _updateLocalBadgeCount(count);

    // Update native badge
    await _updateNativeBadgeCount(count);
  }

  // Update local SharedPreferences
  static Future<void> _updateLocalBadgeCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_badgeKey, count);
  }

  // Update native iOS badge
  static Future<void> _updateNativeBadgeCount(int count) async {
    try {
      await platform.invokeMethod('setBadgeCount', {'count': count});
    } on PlatformException catch (e) {
      print('Error setting native badge count: $e');
    }
  }

  // Increment badge count
  static Future<void> incrementBadgeCount() async {
    int currentCount = await getBadgeCount();
    print('[BadgeCounter] incrementBadgeCount: currentCount = $currentCount');
    await setBadgeCount(currentCount + 1);
  }

  // Decrement badge count
  static Future<void> decrementBadgeCount() async {
    int currentCount = await getBadgeCount();
    int newCount = currentCount - 1;
    print('[BadgeCounter] decrementBadgeCount: currentCount = $currentCount, newCount = $newCount');
    await setBadgeCount(newCount);
  }

  // Reset badge count to 0
  static Future<void> resetBadgeCount() async {
    print('[BadgeCounter] resetBadgeCount called');
    await setBadgeCount(0);
  }

  // Sync badge count between Flutter and native
  static Future<void> syncBadgeCount() async {
    // On app resume, always reset badge count to 0
    await resetBadgeCount();
  }

  // Clear all badge data (useful for logout scenarios)
  static Future<void> clearBadgeData() async {
    try {
      await resetBadgeCount();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_badgeKey);
      print('[BadgeCounter] Badge data cleared');
    } catch (e) {
      print('Error clearing badge data: $e');
    }
  }
}