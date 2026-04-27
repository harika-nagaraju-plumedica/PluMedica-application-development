import 'package:get/get.dart';

class PharmacySalesController extends GetxController {
  static const List<String> _paymentMethodOrder = [
    'Credit Card',
    'Debit Card',
    'UPI',
    'Cash',
  ];

  static final Map<String, Map<String, Map<String, num>>> _paymentSnapshots = {
    '2026-04-16': {
      'Credit Card': {'count': 13, 'amount': 8440.0},
      'Debit Card': {'count': 11, 'amount': 7260.0},
      'UPI': {'count': 9, 'amount': 5810.0},
      'Cash': {'count': 1, 'amount': 690.0},
    },
    '2026-04-17': {
      'Credit Card': {'count': 14, 'amount': 9010.0},
      'Debit Card': {'count': 12, 'amount': 7688.0},
      'UPI': {'count': 10, 'amount': 6420.0},
      'Cash': {'count': 1, 'amount': 780.0},
    },
    '2026-04-18': {
      'Credit Card': {'count': 15, 'amount': 9520.0},
      'Debit Card': {'count': 12, 'amount': 7640.0},
      'UPI': {'count': 10, 'amount': 6410.0},
      'Cash': {'count': 1, 'amount': 830.0},
    },
    '2026-04-19': {
      'Credit Card': {'count': 16, 'amount': 10120.0},
      'Debit Card': {'count': 13, 'amount': 8240.0},
      'UPI': {'count': 11, 'amount': 6890.0},
      'Cash': {'count': 2, 'amount': 1150.0},
    },
    '2026-04-20': {
      'Credit Card': {'count': 18, 'amount': 11180.0},
      'Debit Card': {'count': 15, 'amount': 9440.0},
      'UPI': {'count': 12, 'amount': 7620.0},
      'Cash': {'count': 1, 'amount': 560.0},
    },
    '2026-04-21': {
      'Credit Card': {'count': 19, 'amount': 11950.0},
      'Debit Card': {'count': 15, 'amount': 9220.0},
      'UPI': {'count': 13, 'amount': 8013.5},
      'Cash': {'count': 1, 'amount': 519.0},
    },
  };

  final totalRevenue = RxDouble(155400.50);
  final totalTransactions = RxInt(245);
  final averageOrderValue = RxDouble(634.29);
  final inventoryMovement = RxInt(420);
  final stockRefill = RxInt(220);

  final salesByCategory = RxList<Map<String, dynamic>>([
    {
      'category': 'Analgesics',
      'revenue': 45230.00,
      'percentage': 29.0,
      'transactions': 78,
    },
    {
      'category': 'Respiratory',
      'revenue': 32450.00,
      'percentage': 21.0,
      'transactions': 56,
    },
    {
      'category': 'Supplements',
      'revenue': 38920.00,
      'percentage': 25.0,
      'transactions': 65,
    },
    {
      'category': 'GI Health',
      'revenue': 25180.00,
      'percentage': 16.0,
      'transactions': 34,
    },
    {
      'category': 'Others',
      'revenue': 13620.50,
      'percentage': 9.0,
      'transactions': 12,
    },
  ]);

  final monthlySalesData = RxList<Map<String, dynamic>>([
    {'month': 'Jan', 'sales': 45000.0, 'target': 50000.0},
    {'month': 'Feb', 'sales': 48500.0, 'target': 50000.0},
    {'month': 'Mar', 'sales': 52300.0, 'target': 55000.0},
    {'month': 'Apr', 'sales': 55400.0, 'target': 55000.0},
  ]);

  final dailySalesData = RxList<Map<String, dynamic>>([
    {'day': '18 Apr', 'sales': 4200.0},
    {'day': '19 Apr', 'sales': 5100.0},
    {'day': '20 Apr', 'sales': 3800.0},
    {'day': '21 Apr', 'sales': 4850.0},
  ]);

  final stockActivityData = RxList<Map<String, dynamic>>([
    {'label': 'Sold', 'value': 180.0, 'max': 300.0},
    {'label': 'Remaining', 'value': 620.0, 'max': 800.0},
    {'label': 'Refilled', 'value': 220.0, 'max': 300.0},
  ]);

  final paymentMethods = RxList<Map<String, dynamic>>([
    {
      'method': 'Credit Card',
      'count': 95,
      'percentage': 38.8,
      'amount': 60220.00,
    },
    {
      'method': 'Debit Card',
      'count': 78,
      'percentage': 31.8,
      'amount': 49488.00,
    },
    {'method': 'UPI', 'count': 65, 'percentage': 26.5, 'amount': 41163.50},
    {'method': 'Cash', 'count': 7, 'percentage': 2.9, 'amount': 4529.00},
  ]);

  final selectedTimeRange = RxString('Monthly');
  final selectedDate = Rx<DateTime>(DateTime(2026, 4, 21));
  final paymentMethodSpecificDayEnabled = RxBool(false);
  final paymentMethodFilterDate = Rx<DateTime>(DateTime(2026, 4, 21));

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
    _recalculateForSelection();
  }

  void updateSelectedDate(DateTime date) {
    selectedDate.value = DateTime(date.year, date.month, date.day);
    _recalculateForSelection();
  }

  void setPaymentMethodSpecificDay(bool enabled) {
    paymentMethodSpecificDayEnabled.value = enabled;
    _recalculatePaymentMethods();
  }

  void updatePaymentMethodFilterDate(DateTime date) {
    paymentMethodFilterDate.value = DateTime(date.year, date.month, date.day);
    paymentMethodSpecificDayEnabled.value = true;
    _recalculatePaymentMethods();
  }

  @override
  void onInit() {
    super.onInit();
    _recalculateForSelection();
  }

  void _recalculateForSelection() {
    if (selectedTimeRange.value == 'Daily') {
      totalRevenue.value = 4850.0;
      totalTransactions.value = 12;
      averageOrderValue.value = 404.17;
      inventoryMovement.value = 58;
      stockRefill.value = 24;

      dailySalesData.assignAll([
        {'day': _formattedDate(selectedDate.value), 'sales': 4850.0},
      ]);
    } else if (selectedTimeRange.value == 'Weekly') {
      totalRevenue.value = 31940.0;
      totalTransactions.value = 58;
      averageOrderValue.value = 550.69;
      inventoryMovement.value = 146;
      stockRefill.value = 68;

      dailySalesData.assignAll([
        {'day': '16 Apr', 'sales': 4020.0},
        {'day': '17 Apr', 'sales': 4510.0},
        {'day': '18 Apr', 'sales': 4200.0},
        {'day': '19 Apr', 'sales': 5100.0},
        {'day': '20 Apr', 'sales': 3800.0},
        {'day': '21 Apr', 'sales': 4850.0},
      ]);
    } else if (selectedTimeRange.value == 'Monthly') {
      totalRevenue.value = 155400.50;
      totalTransactions.value = 245;
      averageOrderValue.value = 634.29;
      inventoryMovement.value = 420;
      stockRefill.value = 220;

      dailySalesData.assignAll([
        {'day': '18 Apr', 'sales': 4200.0},
        {'day': '19 Apr', 'sales': 5100.0},
        {'day': '20 Apr', 'sales': 3800.0},
        {'day': '21 Apr', 'sales': 4850.0},
      ]);
    } else {
      totalRevenue.value = 1725600.0;
      totalTransactions.value = 3048;
      averageOrderValue.value = 566.14;
      inventoryMovement.value = 4980;
      stockRefill.value = 2420;

      dailySalesData.assignAll([
        {'day': 'Q1', 'sales': 410000.0},
        {'day': 'Q2', 'sales': 436200.0},
        {'day': 'Q3', 'sales': 438100.0},
        {'day': 'Q4', 'sales': 441300.0},
      ]);
    }

    stockActivityData.assignAll([
      {
        'label': 'Sold',
        'value': inventoryMovement.value.toDouble(),
        'max': (inventoryMovement.value + stockRefill.value + 100).toDouble(),
      },
      {
        'label': 'Remaining',
        'value': (stockRefill.value + 400).toDouble(),
        'max': (stockRefill.value + 700).toDouble(),
      },
      {
        'label': 'Refilled',
        'value': stockRefill.value.toDouble(),
        'max': (stockRefill.value + 120).toDouble(),
      },
    ]);

    _recalculatePaymentMethods();
  }

  void _recalculatePaymentMethods() {
    final selected = selectedDate.value;
    final methodTotals = <String, Map<String, num>>{
      for (final method in _paymentMethodOrder)
        method: {'count': 0, 'amount': 0.0},
    };

    final datesToInclude = <DateTime>[];
    if (paymentMethodSpecificDayEnabled.value) {
      datesToInclude.add(paymentMethodFilterDate.value);
    } else if (selectedTimeRange.value == 'Daily') {
      datesToInclude.add(selected);
    } else if (selectedTimeRange.value == 'Weekly') {
      for (int i = 0; i < 7; i++) {
        datesToInclude.add(selected.subtract(Duration(days: i)));
      }
    } else if (selectedTimeRange.value == 'Monthly') {
      for (final key in _paymentSnapshots.keys) {
        final date = DateTime.parse(key);
        if (date.year == selected.year && date.month == selected.month) {
          datesToInclude.add(date);
        }
      }
    } else {
      for (final key in _paymentSnapshots.keys) {
        final date = DateTime.parse(key);
        if (date.year == selected.year) {
          datesToInclude.add(date);
        }
      }
    }

    for (final date in datesToInclude) {
      final snapshot = _paymentSnapshots[_dateKey(date)];
      if (snapshot == null) {
        continue;
      }

      for (final method in _paymentMethodOrder) {
        final value = snapshot[method];
        if (value == null) {
          continue;
        }

        methodTotals[method]!['count'] =
            (methodTotals[method]!['count'] as num) + (value['count'] ?? 0);
        methodTotals[method]!['amount'] =
            (methodTotals[method]!['amount'] as num) + (value['amount'] ?? 0);
      }
    }

    final totalCount = methodTotals.values
        .map((entry) => entry['count'] as num)
        .fold<num>(0, (sum, count) => sum + count);

    paymentMethods.assignAll(
      _paymentMethodOrder.map((method) {
        final count = (methodTotals[method]!['count'] as num).toInt();
        final amount = (methodTotals[method]!['amount'] as num).toDouble();
        final percentage = totalCount == 0
            ? 0.0
            : (count * 100) / totalCount.toDouble();

        return {
          'method': method,
          'count': count,
          'percentage': percentage,
          'amount': amount,
        };
      }).toList(),
    );
  }

  String _dateKey(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formattedDate(DateTime date) {
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}';
  }
}
