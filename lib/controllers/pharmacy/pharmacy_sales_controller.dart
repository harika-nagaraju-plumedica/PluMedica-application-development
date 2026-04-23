import 'package:get/get.dart';

class PharmacySalesController extends GetxController {
  final totalRevenue = RxDouble(155400.50);
  final totalTransactions = RxInt(245);
  final averageOrderValue = RxDouble(634.29);
  
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
    {
      'day': '18 Apr',
      'sales': 4200.0,
    },
    {
      'day': '19 Apr',
      'sales': 5100.0,
    },
    {
      'day': '20 Apr',
      'sales': 3800.0,
    },
    {
      'day': '21 Apr',
      'sales': 4850.0,
    },
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
    {
      'method': 'UPI',
      'count': 65,
      'percentage': 26.5,
      'amount': 41163.50,
    },
    {
      'method': 'Cash',
      'count': 7,
      'percentage': 2.9,
      'amount': 4529.00,
    },
  ]);

  final selectedTimeRange = RxString('Monthly');

  void updateTimeRange(String range) {
    selectedTimeRange.value = range;
  }
}
