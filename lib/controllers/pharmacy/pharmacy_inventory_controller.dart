import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';

class PharmacyInventoryController extends GetxController {
  static const List<String> allowedCategories = <String>[
    'All',
    'Analgesic',
    'Respiratory',
    'Supplements',
    'GI Health',
  ];

  final inventoryItems = RxList<Map<String, dynamic>>([
    {
      'itemId': 'MED-001',
      'name': 'Paracetamol 650mg',
      'manufacturer': 'ABC Pharma',
      'remainingStock': 150,
      'totalStock': 500,
      'meanLimit': 120,
      'maxLimit': 350,
      'price': 50.00,
      'unit': 'Strips',
      'expiryDate': '2027-12-31',
      'category': 'Analgesic',
      'timeline': [
        {
          'type': 'In-stock entry',
          'quantity': 300,
          'dateTime': DateTime(2026, 4, 18, 9, 15),
        },
        {
          'type': 'Sold stock',
          'quantity': 120,
          'dateTime': DateTime(2026, 4, 20, 13, 0),
        },
        {
          'type': 'In-stock entry',
          'quantity': 150,
          'dateTime': DateTime(2026, 4, 21, 11, 40),
        },
      ],
    },
    {
      'itemId': 'MED-002',
      'name': 'Aspirin 500mg',
      'manufacturer': 'XYZ Pharma',
      'remainingStock': 15,
      'totalStock': 300,
      'meanLimit': 60,
      'maxLimit': 200,
      'price': 45.00,
      'unit': 'Strips',
      'expiryDate': '2027-06-30',
      'category': 'Analgesic',
      'timeline': [
        {
          'type': 'In-stock entry',
          'quantity': 200,
          'dateTime': DateTime(2026, 4, 15, 10, 5),
        },
        {
          'type': 'Sold stock',
          'quantity': 185,
          'dateTime': DateTime(2026, 4, 21, 16, 20),
        },
      ],
    },
    {
      'itemId': 'MED-003',
      'name': 'Cough Syrup',
      'manufacturer': 'Care Pharma',
      'remainingStock': 8,
      'totalStock': 100,
      'meanLimit': 20,
      'maxLimit': 75,
      'price': 120.00,
      'unit': 'Bottles',
      'expiryDate': '2026-08-15',
      'category': 'Respiratory',
      'timeline': [
        {
          'type': 'In-stock entry',
          'quantity': 80,
          'dateTime': DateTime(2026, 4, 17, 8, 35),
        },
        {
          'type': 'Sold stock',
          'quantity': 72,
          'dateTime': DateTime(2026, 4, 21, 14, 10),
        },
      ],
    },
    {
      'itemId': 'MED-004',
      'name': 'Vitamin D3 1000IU',
      'manufacturer': 'Health Plus',
      'remainingStock': 320,
      'totalStock': 400,
      'meanLimit': 90,
      'maxLimit': 280,
      'price': 100.00,
      'unit': 'Tablets',
      'expiryDate': '2028-03-20',
      'category': 'Supplements',
      'timeline': [
        {
          'type': 'In-stock entry',
          'quantity': 250,
          'dateTime': DateTime(2026, 4, 10, 9, 45),
        },
        {
          'type': 'In-stock entry',
          'quantity': 150,
          'dateTime': DateTime(2026, 4, 21, 9, 30),
        },
        {
          'type': 'Sold stock',
          'quantity': 80,
          'dateTime': DateTime(2026, 4, 21, 18, 15),
        },
      ],
    },
    {
      'itemId': 'MED-005',
      'name': 'Omeprazole 20mg',
      'manufacturer': 'Gastro Care',
      'remainingStock': 78,
      'totalStock': 250,
      'meanLimit': 60,
      'maxLimit': 200,
      'price': 60.00,
      'unit': 'Capsules',
      'expiryDate': '2027-09-10',
      'category': 'GI Health',
      'timeline': [
        {
          'type': 'In-stock entry',
          'quantity': 200,
          'dateTime': DateTime(2026, 4, 14, 11, 25),
        },
        {
          'type': 'Sold stock',
          'quantity': 172,
          'dateTime': DateTime(2026, 4, 21, 12, 5),
        },
      ],
    },
  ]);

  final selectedCategory = RxString('All');
  final selectedTimeRange = RxString('Daily');
  final selectedDate = Rx<DateTime>(DateTime(2026, 4, 21));

  @override
  void onInit() {
    super.onInit();
    _normalizeInventoryItems();
    _appendOutOfStockEvents();
  }

  List<Map<String, dynamic>> get filteredInventory {
    try {
      if (inventoryItems.isEmpty) {
        return <Map<String, dynamic>>[];
      }

      final activeCategory = selectedCategory.value.trim();
      final filtered = inventoryItems.where((item) {
        final itemCategory = item['category']?.toString() ?? '';
        final categoryMatches =
            activeCategory == 'All' || itemCategory == activeCategory;
        return categoryMatches && _hasTimelineInRange(item);
      }).toList(growable: false);

      debugPrint(
        'Inventory filter -> category: $activeCategory, total: ${inventoryItems.length}, filtered: ${filtered.length}',
      );
      return filtered;
    } catch (error, stackTrace) {
      debugPrint('filteredInventory error: $error');
      debugPrintStack(stackTrace: stackTrace);
      return <Map<String, dynamic>>[];
    }
  }

  List<Map<String, dynamic>> get lowStockItems {
    return inventoryItems
        .where((item) => stockStatus(item) == 'Low')
        .toList(growable: false);
  }

  int get inventoryMovementInRange {
    int movement = 0;
    for (final item in inventoryItems) {
      final timeline = ((item['timeline'] as List?) ?? const <dynamic>[]);
      for (final rawEvent in timeline) {
        if (rawEvent is! Map) continue;
        final event = Map<String, dynamic>.from(rawEvent);
        final date = _toDateTime(event['dateTime']);
        if (_isWithinRange(date)) {
          movement += _toInt(event['quantity']);
        }
      }
    }
    return movement;
  }

  String stockStatus(Map<String, dynamic> item) {
    final remaining = _toInt(item['remainingStock']);
    final meanLimit = _toInt(item['meanLimit']);
    final maxLimit = _toInt(item['maxLimit']);

    if (remaining <= meanLimit) return 'Low';
    if (remaining < maxLimit) return 'Average';
    return 'Full';
  }

  int soldStock(Map<String, dynamic> item) {
    return _toInt(item['totalStock']) - _toInt(item['remainingStock']);
  }

  void updateCategory(String? category) {
    final requestedCategory = (category ?? '').trim();
    final safeCategory = allowedCategories.contains(requestedCategory)
        ? requestedCategory
        : 'All';

    if (selectedCategory.value == safeCategory) return;

    selectedCategory.value = safeCategory;
    debugPrint('Selected category: ${selectedCategory.value}');
    debugPrint('Inventory count: ${inventoryItems.length}');
  }

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
  }

  void addInStockEntry({
    required String itemId,
    required int quantity,
    required DateTime receivedAt,
  }) {
    if (quantity <= 0) {
      Get.snackbar(
        'Invalid Quantity',
        'Please enter a quantity greater than 0',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final index = inventoryItems.indexWhere((item) => item['itemId'] == itemId);
    if (index == -1) {
      Get.snackbar(
        'Item Not Found',
        'Unable to add stock for selected item',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final item = Map<String, dynamic>.from(inventoryItems[index]);
    final currentRemaining = _toInt(item['remainingStock']);
    final currentTotal = _toInt(item['totalStock']);

    final timelineRaw = item['timeline'];
    final timeline = timelineRaw is List
        ? timelineRaw
              .whereType<Map>()
              .map((event) => Map<String, dynamic>.from(event))
              .toList()
        : <Map<String, dynamic>>[];

    timeline.add({
      'type': 'In-stock entry',
      'quantity': quantity,
      'dateTime': DateTime(
        receivedAt.year,
        receivedAt.month,
        receivedAt.day,
        receivedAt.hour,
        receivedAt.minute,
      ),
    });

    item['remainingStock'] = currentRemaining + quantity;
    item['totalStock'] = currentTotal + quantity;
    item['timeline'] = timeline;

    inventoryItems[index] = item;
    inventoryItems.refresh();

    Get.snackbar(
      'Stock Added',
      '$quantity units added to ${item['name']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateStockLimits({
    required String itemId,
    required int meanLimit,
    required int maxLimit,
  }) {
    final index = inventoryItems.indexWhere((item) => item['itemId'] == itemId);
    if (index == -1) return;

    final totalStock = _toInt(inventoryItems[index]['totalStock']);
    final safeMean = meanLimit.clamp(0, totalStock);
    final safeMax = maxLimit.clamp(safeMean, totalStock);

    inventoryItems[index]['meanLimit'] = safeMean;
    inventoryItems[index]['maxLimit'] = safeMax;
    inventoryItems.refresh();
  }

  Color getStockStatusColor(Map<String, dynamic> item) {
    final status = stockStatus(item);
    if (status == 'Low') return AppColors.stockLow;
    if (status == 'Average') return AppColors.stockAverage;
    return AppColors.stockFull;
  }

  List<Map<String, dynamic>> timelineForItem(Map<String, dynamic> item) {
    final events = ((item['timeline'] ?? <Map<String, dynamic>>[]) as List)
        .cast<Map<String, dynamic>>()
        .toList();
    events.sort(
      (a, b) =>
          _toDateTime(b['dateTime']).compareTo(_toDateTime(a['dateTime'])),
    );
    return events;
  }

  String formatDateTime(DateTime dateTime) {
    final month = _monthName(dateTime.month);
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final suffix = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '${dateTime.day} $month ${dateTime.year}, $hour:$minute $suffix';
  }

  bool _hasTimelineInRange(Map<String, dynamic> item) {
    final timeline = ((item['timeline'] as List?) ?? const <dynamic>[]);
    return timeline.any(
      (rawEvent) {
        if (rawEvent is! Map) return false;
        final event = Map<String, dynamic>.from(rawEvent);
        return _isWithinRange(_toDateTime(event['dateTime']));
      },
    );
  }

  bool _isWithinRange(DateTime eventDate) {
    final selected = selectedDate.value;
    final eventOnly = DateTime(eventDate.year, eventDate.month, eventDate.day);
    final selectedOnly = DateTime(selected.year, selected.month, selected.day);

    if (selectedTimeRange.value == 'Daily') {
      return eventOnly == selectedOnly;
    }

    if (selectedTimeRange.value == 'Weekly') {
      final start = selectedOnly.subtract(const Duration(days: 6));
      return !eventOnly.isBefore(start) && !eventOnly.isAfter(selectedOnly);
    }

    if (selectedTimeRange.value == 'Monthly') {
      return eventDate.year == selected.year &&
          eventDate.month == selected.month;
    }

    return eventDate.year == selected.year;
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

  void _appendOutOfStockEvents() {
    for (final item in inventoryItems) {
      if (_toInt(item['remainingStock']) > 0) continue;

      final timeline = ((item['timeline'] ?? <Map<String, dynamic>>[]) as List)
          .cast<Map<String, dynamic>>();
      item['timeline'] = timeline;
      final hasOutOfStockEvent = timeline.any(
        (event) =>
            event['type'].toString().toLowerCase() == 'out-of-stock status',
      );
      if (hasOutOfStockEvent) continue;

      timeline.add({'type': 'Out-of-stock status', 'dateTime': DateTime.now()});
    }
    inventoryItems.refresh();
  }

  void _normalizeInventoryItems() {
    for (final item in inventoryItems) {
      final totalStock = _toInt(item['totalStock']);
      final normalizedTotalStock = totalStock <= 0 ? 1 : totalStock;
      final remainingStock = _toInt(
        item['remainingStock'],
      ).clamp(0, normalizedTotalStock);
      final meanLimit = _toInt(
        item['meanLimit'],
      ).clamp(0, normalizedTotalStock);
      final maxLimit = _toInt(
        item['maxLimit'],
      ).clamp(meanLimit, normalizedTotalStock);

      item['totalStock'] = normalizedTotalStock;
      item['remainingStock'] = remainingStock;
      item['meanLimit'] = meanLimit;
      item['maxLimit'] = maxLimit;
      item['unit'] = (item['unit'] ?? 'units').toString();

      final timelineRaw = item['timeline'];
      final timeline = timelineRaw is List ? timelineRaw : <dynamic>[];
      item['timeline'] = timeline
          .whereType<Map>()
          .map(
            (event) {
              return {
                'type': (event['type'] ?? 'Stock update').toString(),
                'quantity': _toInt(event['quantity']),
                'dateTime': _toDateTime(event['dateTime']),
              };
            },
          )
          .toList(growable: false);
    }
    inventoryItems.refresh();
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  DateTime _toDateTime(dynamic value) {
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime(1970, 1, 1);
    }
    return DateTime(1970, 1, 1);
  }
}
