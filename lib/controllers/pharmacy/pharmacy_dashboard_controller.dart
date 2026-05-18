import 'package:get/get.dart';
import '../../services/patient_session_service.dart';

class PharmacyDashboardController extends GetxController {
  final pharmacyName = RxString('City Pharmacy');
  final pharmacyPhone = RxString('+91 98765 43210');
  final pharmacyEmail = RxString('pharmacy@plumedica.com');
  
  // Stats
  final totalOrders = RxInt(245);
  final totalRevenue = RxDouble(155400.50);
  final totalInventory = RxInt(3456);
  final lowStockItems = RxInt(12);
  
  // Today's stats
  final ordersToday = RxInt(18);
  final revenueToday = RxDouble(8500.00);
  final customersToday = RxInt(34);
  
  // Recent Orders
  final recentOrders = RxList<Map<String, dynamic>>([
    {
      'orderId': 'ORD-2026-0451',
      'customer': 'Rajesh Kumar',
      'amount': 2500.00,
      'status': 'Delivered',
      'date': '21 Apr, 2:30 PM',
      'items': 5,
    },
    {
      'orderId': 'ORD-2026-0450',
      'customer': 'Priya Singh',
      'amount': 1850.00,
      'status': 'Pending',
      'date': '21 Apr, 1:15 PM',
      'items': 3,
    },
    {
      'orderId': 'ORD-2026-0449',
      'customer': 'Amit Patel',
      'amount': 3200.00,
      'status': 'Delivered',
      'date': '21 Apr, 12:00 PM',
      'items': 7,
    },
    {
      'orderId': 'ORD-2026-0448',
      'customer': 'Neha Gupta',
      'amount': 1200.00,
      'status': 'Processing',
      'date': '20 Apr, 11:45 PM',
      'items': 2,
    },
    {
      'orderId': 'ORD-2026-0447',
      'customer': 'Vikram Sharma',
      'amount': 4100.00,
      'status': 'Delivered',
      'date': '20 Apr, 8:20 PM',
      'items': 9,
    },
  ]);

  // Low Stock Items
  final lowStockItemsList = RxList<Map<String, dynamic>>([
    {
      'itemId': 'MED-001',
      'name': 'Aspirin 500mg',
      'currentStock': 5,
      'minStock': 20,
      'unit': 'Strips',
    },
    {
      'itemId': 'MED-002',
      'name': 'Cough Syrup',
      'currentStock': 8,
      'minStock': 15,
      'unit': 'Bottles',
    },
    {
      'itemId': 'MED-003',
      'name': 'Multivitamin Tablets',
      'currentStock': 3,
      'minStock': 10,
      'unit': 'Strips',
    },
  ]);

  // Top Selling Medicines
  final topSellingMedicines = RxList<Map<String, dynamic>>([
    {
      'name': 'Paracetamol 650mg',
      'sold': 245,
      'revenue': 12250.00,
      'popularity': 92,
    },
    {
      'name': 'Cetirizine 10mg',
      'sold': 189,
      'revenue': 9450.00,
      'popularity': 85,
    },
    {
      'name': 'Vitamin D3 1000IU',
      'sold': 156,
      'revenue': 15600.00,
      'popularity': 78,
    },
    {
      'name': 'Omeprazole 20mg',
      'sold': 134,
      'revenue': 8040.00,
      'popularity': 72,
    },
  ]);

  // Dashboard Messages / Notifications
  final notifications = RxList<Map<String, dynamic>>([
    {
      'id': 1,
      'title': 'Low Stock Alert',
      'message': 'Aspirin 500mg stock is below minimum threshold',
      'type': 'warning',
      'timestamp': '2 hours ago',
      'read': false,
    },
    {
      'id': 2,
      'title': 'New Order',
      'message': 'Order #ORD-2026-0451 has been delivered successfully',
      'type': 'success',
      'timestamp': '1 hour ago',
      'read': false,
    },
    {
      'id': 3,
      'title': 'Payment Received',
      'message': 'Payment of ₹2,500 received from Rajesh Kumar',
      'type': 'info',
      'timestamp': '45 minutes ago',
      'read': true,
    },
  ]);

  Future<void> logout() async {
    await PatientSessionService.logoutRole(AppRole.pharmacy);
    Get.snackbar('Logged Out', 'You have been successfully logged out');
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed('/role_selection');
    });
  }

  void navigateToOrders() {
    Get.toNamed('/pharmacy/orders');
  }

  void navigateToInventory() {
    Get.toNamed('/pharmacy/inventory');
  }

  void navigateToCustomers() {
    Get.toNamed('/pharmacy/customers');
  }

  void navigateToSales() {
    Get.toNamed('/pharmacy/sales');
  }

  @override
  void onInit() {
    super.onInit();
    _loadProfileIdentity();
    // Simulate real-time updates
    Future.delayed(const Duration(seconds: 2), () {
      ordersToday.value = 22;
      revenueToday.value = 12400.00;
    });
  }

  Future<void> _loadProfileIdentity() async {
    final displayName = await PatientSessionService.getRoleDisplayName(
      AppRole.pharmacy,
    );
    final roleEmail = await PatientSessionService.getRoleEmail(AppRole.pharmacy);

    if (displayName.isNotEmpty) {
      pharmacyName.value = displayName;
    }
    if (roleEmail.isNotEmpty) {
      pharmacyEmail.value = roleEmail;
    }
  }
}
