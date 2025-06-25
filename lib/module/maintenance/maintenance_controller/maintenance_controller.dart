import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:developer' as developer;

class MaintenanceController extends GetxController {
  final NotificationRepository _notificationRepository = NotificationRepository();
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs; // Separate loading state for pagination
  var notificationList = <NotificationListModel>[].obs;
  var currentPage = 1.obs;
  var hasMorePages = true.obs;
  var selectedNotificationType = Rxn<String>();
  final int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    // Auto-load notifications when controller is initialized
    getNotifications();
  }

  // Reset pagination state - useful when reopening the page
  void resetPagination() {
    currentPage.value = 1;
    hasMorePages.value = true;
    notificationList.clear();
  }

  // Get all notifications
  Future<void> getNotifications({bool refresh = false}) async {
    try {
      // Handle refresh scenario
      if (refresh) {
        resetPagination();
      }

      // Prevent multiple simultaneous requests
      if (isLoading.value || isLoadingMore.value) return;
      
      // If no more pages and not refreshing, don't make request
      if (!hasMorePages.value && !refresh) return;

      // Set appropriate loading state
      if (currentPage.value == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }

      final response = await _notificationRepository.getAllNotification(
        notificationType: selectedNotificationType.value,
        page: currentPage.value,
        pageSize: pageSize,
      );

      if (response != null) {
        final newNotifications = response.results ?? [];
        
        if (newNotifications.isEmpty) {
          // No more data available
          hasMorePages.value = false;
        } else {
          // Add new notifications to the list
          if (refresh || currentPage.value == 1) {
            notificationList.assignAll(newNotifications);
          } else {
            notificationList.addAll(newNotifications);
          }
          
          // Check if we got less than pageSize, indicating last page
          if (newNotifications.length < pageSize) {
            hasMorePages.value = false;
          } else {
            // Only increment page if we're going to load more
            currentPage.value++;
          }
        }
        
        // Trigger UI update
        notificationList.refresh();
      } else {
        // Handle null response
        if (currentPage.value == 1) {
          // If first page fails, show empty state
          notificationList.clear();
        }
        Get.snackbar('Error', 'Failed to load notifications');
      }
    } catch (e) {
      developer.log('Error in getNotification: $e');
      
      // Don't show error snackbar if it's just a "no more data" scenario
      if (currentPage.value == 1) {
        Get.snackbar('Error', 'Failed to load notifications');
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load more notifications (called when user scrolls near bottom)
  Future<void> loadMoreNotifications() async {
    // Prevent multiple simultaneous requests and check if more pages available
    if (hasMorePages.value && !isLoading.value && !isLoadingMore.value) {
      await getNotifications();
    }
  }

  // Filter notifications by type
  void filterByType(String? type) {
    selectedNotificationType.value = type;
    getNotifications(refresh: true);
  }

  // Refresh notifications (pull-to-refresh)
  Future<void> refreshNotifications() async {
    await getNotifications(refresh: true);
  }

  // Group notifications by date
  Map<String, List<NotificationListModel>> getGroupedNotifications() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    Map<String, List<NotificationListModel>> grouped = {};

    for (var notification in notificationList) {
      if (notification.createdAt == null) continue;
      
      try {
        final createdAt = DateTime.parse(notification.createdAt!);
        String dateKey;

        if (createdAt.year == now.year &&
            createdAt.month == now.month &&
            createdAt.day == now.day) {
          dateKey = 'Today';
        } else if (createdAt.year == yesterday.year &&
            createdAt.month == yesterday.month &&
            createdAt.day == yesterday.day) {
          dateKey = 'Yesterday';
        } else {
          dateKey = "${_getMonthName(createdAt.month)} ${createdAt.day}, ${createdAt.year}";
        }

        if (!grouped.containsKey(dateKey)) {
          grouped[dateKey] = [];
        }
        grouped[dateKey]!.add(notification);
      } catch (e) {
        developer.log('Error parsing date for notification: $e');
        // Add to a default group if date parsing fails
        if (!grouped.containsKey('Other')) {
          grouped['Other'] = [];
        }
        grouped['Other']!.add(notification);
      }
    }

    // Sort the keys to ensure chronological order
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        if (a == 'Today') return -1;
        if (b == 'Today') return 1;
        if (a == 'Yesterday') return -1;
        if (b == 'Yesterday') return 1;
        if (a == 'Other') return 1;
        if (b == 'Other') return -1;

        final dateA = _parseDate(a);
        final dateB = _parseDate(b);
        return dateB.compareTo(dateA);
      });

    // Create a new map with sorted keys
    Map<String, List<NotificationListModel>> sortedGrouped = {};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  DateTime _parseDate(String dateStr) {
    if (dateStr == 'Today' || dateStr == 'Yesterday') {
      return DateTime.now();
    }
    try {
      final parts = dateStr.split(' ');
      final month = _getMonthNumber(parts[0]);
      final day = int.parse(parts[1].replaceAll(',', ''));
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      return DateTime.now();
    }
  }

  int _getMonthNumber(String month) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    return months[month] ?? 1;
  }

  // Delete a notification
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await _notificationRepository.deleteNotification(notificationId);
      
      if (response) {
        notificationList.removeWhere((notification) => notification.uuid == notificationId);
        notificationList.refresh();
        Get.snackbar('Success', 'Notification deleted');
      } else {
        Get.snackbar('Error', 'Failed to delete notification');
      }
    } catch (e) {
      developer.log('Error in deleteNotification: $e');
      Get.snackbar('Error', 'Failed to delete notification');
    }
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final response = await _notificationRepository.markAllAsRead();

      if (response) {
        for (var notification in notificationList) {
          notification.isRead = true;
        }
        notificationList.refresh();
        Get.snackbar('Success', 'All notifications marked as read');
      } else {
        Get.snackbar('Error', 'Failed to mark all notifications as read');
      }
    } catch (e) {
      developer.log('Error in markAllAsRead: $e');
      Get.snackbar('Error', 'Failed to mark all notifications as read');
    }
  }

  // Mark a specific notification as read
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await _notificationRepository.markAsRead(notificationId);

      if (response) {
        final notificationIndex = notificationList.indexWhere(
          (notification) => notification.uuid == notificationId
        );
        
        if (notificationIndex != -1) {
          notificationList[notificationIndex].isRead = true;
          notificationList.refresh();
        }
      }
    } catch (e) {
      developer.log('Error in markAsRead: $e');
      Get.snackbar('Error', 'Failed to mark notification as read');
    }
  }

  // Check if should show load more button (not needed for auto-pagination, kept for compatibility)
  bool get shouldShowLoadMore => false; // Disabled since we're using auto-pagination

  // Get unread count
  int get unreadCount => notificationList.where((n) => !(n.isRead ?? false)).length;
}
