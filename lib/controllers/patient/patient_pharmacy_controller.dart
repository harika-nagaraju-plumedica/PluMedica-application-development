import 'package:get/get.dart';

class PatientPharmacyController extends GetxController {
  final isLoading = false.obs;
  final medicines = [].obs;
  final searchQuery = ''.obs;
  final cart = [].obs;

  @override
  void onInit() {
    super.onInit();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    isLoading.value = true;
    try {
      // TODO: Fetch medicines from API
      // TODO: Load pharmacy inventory
    } catch (e) {
      Get.snackbar('Error', 'Failed to load medicines');
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    // TODO: Filter medicines by search
  }

  void addToCart(String medicineId) {
    cart.add(medicineId);
    Get.snackbar('Success', 'Added to cart');
  }

  void removeFromCart(String medicineId) {
    cart.remove(medicineId);
  }

  Future<void> proceedToCheckout() async {
    // TODO: Navigate to checkout
  }

  Future<void> viewMedicineDetails(String medicineId) async {
    // TODO: Navigate to medicine detail
  }
}
