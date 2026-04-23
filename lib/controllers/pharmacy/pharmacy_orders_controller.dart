import 'package:get/get.dart';

class PharmacyOrdersController extends GetxController {
  final orders = RxList<Map<String, dynamic>>([
    {
      'orderId': 'ORD-2026-0451',
      'customer': 'Rajesh Kumar',
      'amount': 2500.00,
      'status': 'Delivered',
      'date': '21 Apr, 2:30 PM',
      'items': 5,
      'address': '123 Main St, City',
      'phone': '+91 98765 43210',
      'paymentStatus': 'Paid',
    },
    {
      'orderId': 'ORD-2026-0450',
      'customer': 'Priya Singh',
      'amount': 1850.00,
      'status': 'Pending',
      'date': '21 Apr, 1:15 PM',
      'items': 3,
      'address': '456 Park Ave, City',
      'phone': '+91 98765 43211',
      'paymentStatus': 'Pending',
    },
    {
      'orderId': 'ORD-2026-0449',
      'customer': 'Amit Patel',
      'amount': 3200.00,
      'status': 'Delivered',
      'date': '21 Apr, 12:00 PM',
      'items': 7,
      'address': '789 Oak Rd, City',
      'phone': '+91 98765 43212',
      'paymentStatus': 'Paid',
    },
    {
      'orderId': 'ORD-2026-0448',
      'customer': 'Neha Gupta',
      'amount': 1200.00,
      'status': 'Processing',
      'date': '20 Apr, 11:45 PM',
      'items': 2,
      'address': '321 Elm St, City',
      'phone': '+91 98765 43213',
      'paymentStatus': 'Paid',
    },
  ]);

  final selectedFilter = RxString('All');
  
  List<Map<String, dynamic>> get filteredOrders {
    if (selectedFilter.value == 'All') return orders;
    return orders
        .where((order) =>
            order['status'].toLowerCase() ==
            selectedFilter.value.toLowerCase())
        .toList();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }
}
