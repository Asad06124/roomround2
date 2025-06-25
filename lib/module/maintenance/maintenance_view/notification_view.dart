import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';


class MaintenanceView extends StatefulWidget {
  MaintenanceView({super.key});

  @override
  _MaintenanceViewState createState() => _MaintenanceViewState();
}

class _MaintenanceViewState extends State<MaintenanceView> {
  final NotificationController notificationController =
      Get.put(NotificationController());
  final ScrollController _scrollController = ScrollController();
  String? _currentHeader; // Track the current date header
  final Map<String, GlobalKey> _groupKeys = {}; // Keys for each date group

  @override
  void initState() {
    super.initState();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Auto-load more notifications
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.8) {
        notificationController.loadMoreNotifications();
      }

      // Update the current header based on scroll position
      // _updateCurrentHeader();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: AppSpacing.globalPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed header with actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => InkWell(
                      onTap: notificationController.unreadCount > 0
                          ? () => notificationController.markAllAsRead()
                          : null,
                      child: Text(
                        'Mark all as read',
                        style: AppTextStyle.poppins26normal600().copyWith(
                          color: notificationController.unreadCount > 0
                              ? AppColors.primary
                              : AppColors.greyText,
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )),
                AppMenuButton(
                  items: const [
                    'All',
                    'Mentions',
                    'Replies & Comments',
                    'Likes & Reactions',
                    'Votes & Polls',
                    'Warnings & Flags',
                    'System Updates',
                    // 'Profile Verification',
                    // 'Wink Verification',
                    // 'Rewards',
                    // 'Custom Tag',
                  ],
                  onSelected: (String selectedItem) {
                    final type = mapStringToNotificationType(selectedItem);
                    notificationController.filterByType(type);
                  },
                  textColor: AppColors.primary,
                ),
              ],
            ),
            AppSpacing.height20,
            // Scrollable content with headers scrolling with the list
            Expanded(
              child: Obx(() {
                // Show loading indicator for initial load
                if (notificationController.isLoading.value &&
                    notificationController.notificationList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final groupedNotifications =
                    notificationController.getGroupedNotifications();
                if (groupedNotifications.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: notificationController.refreshNotifications,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_none,
                                  size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text('No notifications found',
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                // Initialize group keys for each date
                _groupKeys.clear();
                for (var key in groupedNotifications.keys) {
                  _groupKeys[key] = GlobalKey();
                }

                return RefreshIndicator(
                  onRefresh: notificationController.refreshNotifications,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      // Notification groups with headers
                      ...groupedNotifications.entries.map((entry) {
                        final groupKey = entry.key;
                        final notifications = entry.value;
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // Add the header for the first item in the group
                              if (index == 0) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      key: _groupKeys[groupKey],
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                      child: Text(
                                        groupKey,
                                        style: AppTextStyle.poppins24normal500()
                                            .copyWith(
                                                color: AppColors.greyText),
                                      ),
                                    ),
                                    notificationTile(
                                      title: notifications[index].title ?? '',
                                      subtitle:
                                          notifications[index].message ?? '',
                                      isNotificationRead:
                                          notifications[index].isRead ?? false,
                                      notificationType: notifications[index]
                                              .notificationType ??
                                          '',
                                      id: notifications[index].uuid ?? '',
                                    ),
                                  ],
                                );
                              }
                              // Regular notification tile
                              return notificationTile(
                                title: notifications[index].title ?? '',
                                subtitle: notifications[index].message ?? '',
                                isNotificationRead:
                                    notifications[index].isRead ?? false,
                                notificationType:
                                    notifications[index].notificationType ?? '',
                                id: notifications[index].uuid ?? '',
                              );
                            },
                            childCount: notifications.length,
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget notificationTile({
    required String title,
    required String subtitle,
    bool isNotificationRead = false,
    required String notificationType,
    required String id,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Card(
            child: ListTile(
              onTap: () {
                if (!isNotificationRead) {
                  notificationController.markAsRead(id);
                }
              },
              leading: Container(
                width: 40.0.w,
                height: 40.0.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    _getNotificationIcon(notificationType),
                    color: Colors.white,
                    width: 18.0.w,
                    height: 18.0.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              title: Text(
                title,
                style: AppTextStyle.poppins19normal400(),
              ),
              subtitle: Text(
                subtitle,
                style: AppTextStyle.poppins16normal400(),
              ),
              trailing: InkWell(
                onTap: () {
                  _showDeleteConfirmation(id);
                },
                child: Icon(
                  Icons.close,
                  size: 18.0.sp,
                ),
              ),
            ),
          ),
          if (!isNotificationRead)
            Positioned(
              top: 0,
              right: 5,
              child: Container(
                width: 15.0.w,
                height: 15.0.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getNotificationIcon(String notificationType) {
    return switch (notificationType) {
      'mentions' => AppImage.someonesTalkingAboutYou,
      'replies_comments' => AppImage.chat,
      'likes_reactions' => AppImage.like,
      'votes_polls' => AppImage.vote,
      'warnings_flags' => AppImage.flagged,
      'system_updates' => AppImage.bell,
      'profile_verification' => AppImage.verification,
      'wink_verification' => AppImage.verification,
      'rewards' => AppImage.congrats,
      'custom_tag' => AppImage.favorite,
      _ => AppImage.bell, // Default icon
    };
  }

  void _showDeleteConfirmation(String notificationId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Notification'),
        content:
            const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            onPressed: () => Get.close(1),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              notificationController.deleteNotification(notificationId);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String? mapStringToNotificationType(String selectedItem) {
    return switch (selectedItem) {
      'Mentions' => 'mentions',
      'Replies & Comments' => 'replies_comments',
      'Likes & Reactions' => 'likes_reactions',
      'Votes & Polls' => 'votes_polls',
      'Warnings & Flags' => 'warnings_flags',
      'System Updates' => 'system_updates',
      'Profile Verification' => 'profile_verification',
      'Wink Verification' => 'wink_verification',
      'Rewards' => 'rewards',
      'Custom Tag' => 'custom_tag',
      _ => null,
    };
  }
}
