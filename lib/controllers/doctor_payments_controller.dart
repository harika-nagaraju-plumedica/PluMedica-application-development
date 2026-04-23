import 'package:get/get.dart';
import '../models/payment_model.dart';

/// Controller for doctor payments
class DoctorPaymentsController extends GetxController {
  final isLoading = false.obs;
  final payments = <Payment>[].obs;
  final totalEarnings = 0.0.obs;

  final filterPaymentStatus = Rx<String?>(null);
  final filteredPayments = <Payment>[].obs;

  final paymentStatusOptions = ['All', 'Paid', 'Pending', 'Failed'].obs;

  @override
  void onInit() {
    super.onInit();
    loadPayments();
  }

  /// Load payments
  Future<void> loadPayments() async {
    isLoading.value = true;

    try {
      // TODO: API call to fetch payments
      payments.value = [
        Payment(
          id: '1',
          patientId: 'P1',
          doctorId: '1',
          amount: 500.0,
          paymentMethod: 'Credit Card',
          status: 'Paid',
          transactionDate: DateTime.now().subtract(const Duration(days: 5)),
          transactionId: 'TXN001',
        ),
        Payment(
          id: '2',
          patientId: 'P2',
          doctorId: '1',
          amount: 750.0,
          paymentMethod: 'UPI',
          status: 'Paid',
          transactionDate: DateTime.now().subtract(const Duration(days: 10)),
          transactionId: 'TXN002',
        ),
        Payment(
          id: '3',
          patientId: 'P3',
          doctorId: '1',
          amount: 1000.0,
          paymentMethod: 'Bank Transfer',
          status: 'Paid',
          transactionDate: DateTime.now().subtract(const Duration(days: 15)),
          transactionId: 'TXN003',
        ),
        Payment(
          id: '4',
          patientId: 'P4',
          doctorId: '1',
          amount: 600.0,
          paymentMethod: 'Wallet',
          status: 'Pending',
          transactionDate: DateTime.now().subtract(const Duration(days: 2)),
          transactionId: 'TXN004',
        ),
        Payment(
          id: '5',
          patientId: 'P5',
          doctorId: '1',
          amount: 800.0,
          paymentMethod: 'Credit Card',
          status: 'Paid',
          transactionDate: DateTime.now().subtract(const Duration(days: 1)),
          transactionId: 'TXN005',
        ),
      ];

      // Calculate total earnings
      totalEarnings.value = payments
          .where((p) => p.status == 'Paid')
          .fold(0.0, (sum, p) => sum + p.amount);

      filterPaymentStatus.value = 'All';
      applyPaymentFilter('All');
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load payments: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Apply payment filter
  void applyPaymentFilter(String status) {
    filterPaymentStatus.value = status;

    if (status == 'All') {
      filteredPayments.value = payments;
    } else {
      filteredPayments.value =
          payments.where((p) => p.status == status).toList();
    }
  }

  /// Refresh payments
  Future<void> refreshPayments() async {
    await loadPayments();
  }
}
