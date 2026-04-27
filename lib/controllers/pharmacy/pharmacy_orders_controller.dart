import 'package:get/get.dart';

class PharmacyOrdersController extends GetxController {
  final orders = RxList<Map<String, dynamic>>([
    {
      'orderId': 'ORD-2026-0451',
      'patientId': 'PT-100451',
      'customer': 'Rajesh Kumar',
      'customerType': 'Plumedica',
      'amount': 2500.00,
      'status': 'Delivered',
      'dateTime': DateTime(2026, 4, 21, 14, 30),
      'items': 5,
      'address': '123 Main St, City',
      'phone': '+91 98765 43210',
      'paymentStatus': 'Paid',
      'transactionId': null,
      'patientTransactionId': null,
      'isCriticalDrug': false,
      'prescriptionFromPlumedicaDoctor': true,
      'pharmacistApproved': true,
      'medicines': [
        {
          'name': 'Paracetamol 650mg',
          'remainingStock': 150,
          'totalStock': 500,
          'unit': 'strips',
        },
        {
          'name': 'Vitamin D3 1000IU',
          'remainingStock': 320,
          'totalStock': 400,
          'unit': 'tablets',
        },
      ],
    },
    {
      'orderId': 'ORD-2026-0450',
      'patientId': 'PT-100452',
      'customer': 'Priya Singh',
      'customerType': 'Non-Plumedica',
      'amount': 1850.00,
      'status': 'Pending',
      'dateTime': DateTime(2026, 4, 21, 13, 15),
      'items': 3,
      'address': '456 Park Ave, City',
      'phone': '+91 98765 43211',
      'paymentStatus': 'Pending',
      'transactionId': null,
      'patientTransactionId': null,
      'isCriticalDrug': false,
      'prescriptionFromPlumedicaDoctor': true,
      'pharmacistApproved': false,
      'medicines': [
        {
          'name': 'Aspirin 500mg',
          'remainingStock': 15,
          'totalStock': 300,
          'unit': 'strips',
        },
      ],
    },
    {
      'orderId': 'ORD-2026-0449',
      'patientId': 'PT-100453',
      'customer': 'Amit Patel',
      'customerType': 'Plumedica',
      'amount': 3200.00,
      'status': 'Processing',
      'dateTime': DateTime(2026, 4, 20, 12, 0),
      'items': 7,
      'address': '789 Oak Rd, City',
      'phone': '+91 98765 43212',
      'paymentStatus': 'Paid',
      'transactionId': null,
      'patientTransactionId': null,
      'isCriticalDrug': false,
      'prescriptionFromPlumedicaDoctor': true,
      'pharmacistApproved': true,
      'medicines': [
        {
          'name': 'Omeprazole 20mg',
          'remainingStock': 78,
          'totalStock': 250,
          'unit': 'capsules',
        },
        {
          'name': 'Cough Syrup',
          'remainingStock': 8,
          'totalStock': 100,
          'unit': 'bottles',
        },
      ],
    },
    {
      'orderId': 'ORD-2026-0448',
      'patientId': 'PT-100454',
      'customer': 'Neha Gupta',
      'customerType': 'Non-Plumedica',
      'amount': 1200.00,
      'status': 'Prescription verification required',
      'dateTime': DateTime(2026, 4, 19, 11, 45),
      'items': 2,
      'address': '321 Elm St, City',
      'phone': '+91 98765 43213',
      'paymentStatus': 'Pending',
      'transactionId': null,
      'patientTransactionId': null,
      'isCriticalDrug': true,
      'prescriptionFromPlumedicaDoctor': false,
      'pharmacistApproved': false,
      'medicines': [
        {
          'name': 'Insulin Pen',
          'remainingStock': 42,
          'totalStock': 120,
          'unit': 'units',
        },
      ],
    },
  ]);

  final selectedFilter = RxString('All');
  final selectedTimeRange = RxString('Daily');
  final selectedDate = Rx<DateTime>(DateTime(2026, 4, 21));
  final searchQuery = RxString('');

  static const List<String> orderFilters = [
    'All',
    'Pending',
    'Processing',
    'Delivered',
  ];

  @override
  void onInit() {
    super.onInit();
    _applyPrescriptionValidationRules();
    _ensureTransactionIdsForPaidOrders();
  }

  List<Map<String, dynamic>> get filteredOrders {
    return orders
        .where((order) => _matchesFilter(order, selectedFilter.value))
        .where(_matchesSearch)
        .where(_withinSelectedDateRange)
        .toList();
  }

  int get totalVisibleOrders {
    return orders.where(_matchesSearch).where(_withinSelectedDateRange).length;
  }

  int getOrderCount(String filter) {
    return orders
        .where((order) => _matchesFilter(order, filter))
        .where(_matchesSearch)
        .where(_withinSelectedDateRange)
        .length;
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  bool approvePrescription(String orderId) {
    final index = orders.indexWhere((order) => order['orderId'] == orderId);
    if (index == -1) return false;

    orders[index]['pharmacistApproved'] = true;
    orders[index]['status'] = 'Processing';
    orders.refresh();
    return true;
  }

  bool completeOrder(String orderId) {
    final index = orders.indexWhere((order) => order['orderId'] == orderId);
    if (index == -1) return false;

    final order = orders[index];
    _applyPrescriptionValidationRuleToOrder(order);
    final requiresVerification =
        order['status'] == 'Prescription verification required' ||
        ((order['isCriticalDrug'] == true) &&
            (order['prescriptionFromPlumedicaDoctor'] != true) &&
            (order['pharmacistApproved'] != true));

    if (requiresVerification && order['pharmacistApproved'] != true) {
      Get.snackbar(
        'Approval Required',
        'Pharmacist in-person verification is required before completion.',
      );
      return false;
    }

    order['status'] = 'Delivered';
    order['paymentStatus'] = 'Paid';
    _ensureTransactionId(order);
    orders.refresh();
    return true;
  }

  String formatOrderDate(DateTime dateTime) {
    final month = _monthName(dateTime.month);
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${dateTime.day} $month, $hour:$minute $suffix';
  }

  bool _matchesFilter(Map<String, dynamic> order, String filter) {
    if (filter == 'All') return true;

    final status = order['status'].toString().toLowerCase();
    if (filter == 'Pending') {
      return status == 'pending' ||
          status == 'prescription verification required';
    }

    return status == filter.toLowerCase();
  }

  bool _matchesSearch(Map<String, dynamic> order) {
    if (searchQuery.value.isEmpty) return true;
    final query = searchQuery.value.toLowerCase();

    final medicineNames = ((order['medicines'] ?? []) as List)
        .map((med) => (med['name'] ?? '').toString().toLowerCase())
        .join(' ');

    return (order['patientId'] ?? '').toString().toLowerCase().contains(
          query,
        ) ||
        (order['orderId'] ?? '').toString().toLowerCase().contains(query) ||
        medicineNames.contains(query);
  }

  bool _withinSelectedDateRange(Map<String, dynamic> order) {
    final orderDate = (order['dateTime'] as DateTime);
    final selected = selectedDate.value;

    if (selectedTimeRange.value == 'Daily') {
      return orderDate.year == selected.year &&
          orderDate.month == selected.month &&
          orderDate.day == selected.day;
    }

    if (selectedTimeRange.value == 'Weekly') {
      final start = selected.subtract(const Duration(days: 6));
      final orderDateOnly = DateTime(
        orderDate.year,
        orderDate.month,
        orderDate.day,
      );
      final startOnly = DateTime(start.year, start.month, start.day);
      final selectedOnly = DateTime(
        selected.year,
        selected.month,
        selected.day,
      );
      return !orderDateOnly.isBefore(startOnly) &&
          !orderDateOnly.isAfter(selectedOnly);
    }

    if (selectedTimeRange.value == 'Monthly') {
      return orderDate.year == selected.year &&
          orderDate.month == selected.month;
    }

    return orderDate.year == selected.year;
  }

  void _ensureTransactionIdsForPaidOrders() {
    for (final order in orders) {
      if (order['paymentStatus'] == 'Paid') {
        _ensureTransactionId(order);
      }
    }
    orders.refresh();
  }

  void _ensureTransactionId(Map<String, dynamic> order) {
    final orderId = (order['orderId'] ?? '').toString();

    if (order['transactionId'] == null) {
      order['transactionId'] = _generateTransactionId(orderId, 'PH');
    }

    if (order['patientTransactionId'] == null) {
      order['patientTransactionId'] = _generateTransactionId(orderId, 'PT');
    }
  }

  String _generateTransactionId(String orderId, String idPrefix) {
    final millisSuffix = DateTime.now().millisecondsSinceEpoch.toString();
    final safeOrderId = orderId.replaceAll('ORD-', '');
    return '$idPrefix-$safeOrderId-${millisSuffix.substring(millisSuffix.length - 6)}';
  }

  void _applyPrescriptionValidationRules() {
    for (final order in orders) {
      _applyPrescriptionValidationRuleToOrder(order);
    }
    orders.refresh();
  }

  void _applyPrescriptionValidationRuleToOrder(Map<String, dynamic> order) {
    final isCritical = order['isCriticalDrug'] == true;
    final fromPlumedica = order['prescriptionFromPlumedicaDoctor'] == true;
    final isApproved = order['pharmacistApproved'] == true;
    final isDelivered = order['status'].toString().toLowerCase() == 'delivered';

    if (isCritical && !fromPlumedica && !isApproved && !isDelivered) {
      order['status'] = 'Prescription verification required';
    }
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
