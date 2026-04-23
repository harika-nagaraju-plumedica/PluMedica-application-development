import 'package:get/get.dart';

class PharmacyCustomersController extends GetxController {
  final customers = RxList<Map<String, dynamic>>([
    {
      'customerId': 'CUST-001',
      'name': 'Rajesh Kumar',
      'phone': '+91 98765 43210',
      'email': 'rajesh@email.com',
      'joinDate': '15 Jan 2026',
      'totalOrders': 12,
      'totalSpent': 18500.00,
      'lastOrder': '21 Apr 2026',
      'address': '123 Main St, City',
      'city': 'Mumbai',
    },
    {
      'customerId': 'CUST-002',
      'name': 'Priya Singh',
      'phone': '+91 98765 43211',
      'email': 'priya@email.com',
      'joinDate': '22 Feb 2026',
      'totalOrders': 8,
      'totalSpent': 12300.00,
      'lastOrder': '20 Apr 2026',
      'address': '456 Park Ave, City',
      'city': 'Delhi',
    },
    {
      'customerId': 'CUST-003',
      'name': 'Amit Patel',
      'phone': '+91 98765 43212',
      'email': 'amit@email.com',
      'joinDate': '10 Mar 2026',
      'totalOrders': 15,
      'totalSpent': 25600.00,
      'lastOrder': '19 Apr 2026',
      'address': '789 Oak Rd, City',
      'city': 'Bangalore',
    },
    {
      'customerId': 'CUST-004',
      'name': 'Neha Gupta',
      'phone': '+91 98765 43213',
      'email': 'neha@email.com',
      'joinDate': '05 Apr 2026',
      'totalOrders': 3,
      'totalSpent': 3400.00,
      'lastOrder': '18 Apr 2026',
      'address': '321 Elm St, City',
      'city': 'Pune',
    },
    {
      'customerId': 'CUST-005',
      'name': 'Vikram Sharma',
      'phone': '+91 98765 43214',
      'email': 'vikram@email.com',
      'joinDate': '12 Jan 2026',
      'totalOrders': 20,
      'totalSpent': 42100.00,
      'lastOrder': '17 Apr 2026',
      'address': '555 Birch Lane, City',
      'city': 'Hyderabad',
    },
  ]);

  final searchQuery = RxString('');

  List<Map<String, dynamic>> get filteredCustomers {
    if (searchQuery.value.isEmpty) return customers;
    return customers
        .where((customer) =>
            customer['name']
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            customer['phone'].contains(searchQuery.value) ||
            customer['email']
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void search(String query) {
    searchQuery.value = query;
  }
}
