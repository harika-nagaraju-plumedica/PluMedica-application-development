import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/pharmacy/pharmacy_notifications_controller.dart';
import '../../utils/colors.dart';
import '../../utils/fonts.dart';
import '../../utils/constants.dart';

class PharmacyNotificationsView
    extends GetView<PharmacyNotificationsController> {
  const PharmacyNotificationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Clear All Notifications?'),
                  content: const Text(
                      'This action cannot be undone. Are you sure?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        controller.clearAllNotifications();
                        Get.back();
                      },
                      child: const Text(
                        'Clear All',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              'Clear All',
              style: AppFonts.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_off,
                      color: AppColors.textSecondary,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No Notifications',
                      style: AppFonts.heading2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You\'re all caught up!',
                      style: AppFonts.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notif = controller.notifications[index];
                  return _buildNotificationCard(notif);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final backgroundColor = _getBackgroundColor(notif['type']);
    final iconColor = _getIconColor(notif['type']);
    final icon = _getIcon(notif['type']);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(notif['id']);
        Get.snackbar(
          'Deleted',
          'Notification removed',
          duration: const Duration(seconds: 1),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(AppConstants.paddingMedium),
        decoration: BoxDecoration(
          color: notif['read'] ? Colors.white : backgroundColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: notif['read']
                ? Colors.transparent
                : backgroundColor.withValues(alpha: 0.3),
            width: notif['read'] ? 0 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'],
                              style: AppFonts.labelMedium.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (!notif['read'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['message'],
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['timestamp'],
                        style: AppFonts.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (!notif['read'])
                  GestureDetector(
                    onTap: () => controller.markAsRead(notif['id']),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: backgroundColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
            if (notif['actionText'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: backgroundColor.withValues(alpha: 0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      controller.markAsRead(notif['id']);
                      Get.snackbar(
                        'Action',
                        notif['actionText'],
                        duration: const Duration(seconds: 1),
                      );
                    },
                    child: Text(
                      notif['actionText'],
                      style: AppFonts.bodySmall.copyWith(
                        color: backgroundColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor(String type) {
    switch (type.toLowerCase()) {
      case 'warning':
        return AppColors.orange;
      case 'success':
        return AppColors.success;
      case 'error':
        return Colors.red;
      case 'info':
      default:
        return AppColors.primaryBlue;
    }
  }

  Color _getIconColor(String type) {
    return _getBackgroundColor(type);
  }

  IconData _getIcon(String type) {
    switch (type.toLowerCase()) {
      case 'warning':
        return Icons.warning_amber;
      case 'success':
        return Icons.check_circle;
      case 'error':
        return Icons.error;
      case 'info':
      default:
        return Icons.info;
    }
  }
}

