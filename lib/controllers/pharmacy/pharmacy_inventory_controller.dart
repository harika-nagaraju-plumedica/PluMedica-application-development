import 'package:get/get.dart';

class PharmacyInventoryController extends GetxController {
  final inventoryItems = RxList<Map<String, dynamic>>([
    {
      'itemId': 'MED-001',
      'name': 'Paracetamol 650mg',
      'manufacturer': 'ABC Pharma',
      'stock': 150,
      'minStock': 50,
      'maxStock': 500,
      'price': 50.00,
      'unit': 'Strips',
      'expiryDate': '2027-12-31',
      'category': 'Analgesic',
    },
    {
      'itemId': 'MED-002',
      'name': 'Aspirin 500mg',
      'manufacturer': 'XYZ Pharma',
      'stock': 5,
      'minStock': 20,
      'maxStock': 300,
      'price': 45.00,
      'unit': 'Strips',
      'expiryDate': '2027-06-30',
      'category': 'Analgesic',
    },
    {
      'itemId': 'MED-003',
      'name': 'Cough Syrup',
      'manufacturer': 'Care Pharma',
      'stock': 8,
      'minStock': 15,
      'maxStock': 100,
      'price': 120.00,
      'unit': 'Bottles',
      'expiryDate': '2026-08-15',
      'category': 'Respiratory',
    },
    {
      'itemId': 'MED-004',
      'name': 'Vitamin D3 1000IU',
      'manufacturer': 'Health Plus',
      'stock': 320,
      'minStock': 50,
      'maxStock': 400,
      'price': 100.00,
      'unit': 'Tablets',
      'expiryDate': '2028-03-20',
      'category': 'Supplements',
    },
    {
      'itemId': 'MED-005',
      'name': 'Omeprazole 20mg',
      'manufacturer': 'Gastro Care',
      'stock': 78,
      'minStock': 40,
      'maxStock': 250,
      'price': 60.00,
      'unit': 'Capsules',
      'expiryDate': '2027-09-10',
      'category': 'GI Health',
    },
  ]);

  final selectedCategory = RxString('All');

  List<Map<String, dynamic>> get filteredInventory {
    if (selectedCategory.value == 'All') return inventoryItems;
    return inventoryItems
        .where((item) => item['category'] == selectedCategory.value)
        .toList();
  }

  List<Map<String, dynamic>> get lowStockItems {
    return inventoryItems
        .where((item) => item['stock'] < item['minStock'])
        .toList();
  }

  void updateCategory(String category) {
    selectedCategory.value = category;
  }
}
