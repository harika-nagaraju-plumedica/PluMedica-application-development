import 'package:get/get.dart';

class PharmacyNotificationsController extends GetxController {
  final notifications = RxList<Map<String, dynamic>>([
    {
      'id': 1,
      'title': 'Low Stock Alert',
      'message': 'Aspirin 500mg stock is below minimum threshold',
      'type': 'warning',
      'timestamp': '2 hours ago',
      'read': false,
      'actionText': 'Reorder Now',
    },
    {
      'id': 2,
      'title': 'New Order',
      'message':
          'Order #ORD-2026-0451 for Patient ID PT-100451 was delivered successfully',
      'type': 'success',
      'timestamp': '1 hour ago',
      'read': false,
      'actionText': null,
    },
    {
      'id': 3,
      'title': 'Payment Received',
      'message':
          'Payment of ₹2,500 received for Patient ID PT-100451 (TXN-2026-0451-7312)',
      'type': 'info',
      'timestamp': '45 minutes ago',
      'read': true,
      'actionText': null,
    },
    {
      'id': 4,
      'title': 'Expiry Alert',
      'message': 'Cough Syrup batch expires in 4 months (31 Aug 2026)',
      'type': 'warning',
      'timestamp': '20 minutes ago',
      'read': false,
      'actionText': 'Clear Stock',
    },
    {
      'id': 5,
      'title': 'Order Cancelled',
      'message': 'Order #ORD-2026-0440 has been cancelled by customer',
      'type': 'error',
      'timestamp': '15 minutes ago',
      'read': false,
      'actionText': null,
    },
    {
      'id': 6,
      'title': 'System Update',
      'message': 'System maintenance scheduled for tomorrow at 2:00 AM',
      'type': 'info',
      'timestamp': '10 minutes ago',
      'read': false,
      'actionText': null,
    },
  ]);

  void markAsRead(int id) {
    int index = notifications.indexWhere((notif) => notif['id'] == id);
    if (index != -1) {
      notifications[index]['read'] = true;
      notifications.refresh();
    }
  }

  void deleteNotification(int id) {
    notifications.removeWhere((notif) => notif['id'] == id);
  }

  void clearAllNotifications() {
    notifications.clear();
  }
}
