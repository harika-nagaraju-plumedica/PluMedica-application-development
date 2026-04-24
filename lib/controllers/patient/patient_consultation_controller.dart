import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientConsultationController extends GetxController {
  final isLoading = false.obs;
  final consultations = <Map<String, dynamic>>[].obs;
  final upcomingConsultations = <Map<String, dynamic>>[].obs;
  final completedConsultations = <Map<String, dynamic>>[].obs;

  final availableDoctors = <Map<String, dynamic>>[
    {
      'id': 'DOC001',
      'name': 'Dr. Priya Sharma',
      'specialization': 'General Medicine',
      'supportsVirtual': true,
      'supportsHomeTreatment': true,
      'consultationFee': 700,
      'homeTreatmentFee': 1200,
    },
    {
      'id': 'DOC002',
      'name': 'Dr. Amit Patel',
      'specialization': 'Cardiology',
      'supportsVirtual': true,
      'supportsHomeTreatment': false,
      'consultationFee': 1200,
      'homeTreatmentFee': 0,
    },
    {
      'id': 'DOC003',
      'name': 'Dr. Nisha Verma',
      'specialization': 'Dermatology',
      'supportsVirtual': true,
      'supportsHomeTreatment': true,
      'consultationFee': 900,
      'homeTreatmentFee': 1400,
    },
  ].obs;

  final consultationModes = ['Virtual Video Call', 'Home Treatment'].obs;
  final paymentMethods = ['UPI', 'Credit Card', 'Net Banking', 'Wallet'].obs;
  final timeSlots = [
    '09:00 AM',
    '10:30 AM',
    '12:00 PM',
    '02:30 PM',
    '04:00 PM',
    '06:00 PM',
  ].obs;

  final selectedDoctorId = Rx<String?>(null);
  final selectedMode = 'Virtual Video Call'.obs;
  final selectedDate = Rx<DateTime?>(null);
  final selectedTimeSlot = Rx<String?>(null);
  final selectedPaymentMethod = 'UPI'.obs;
  final problemController = TextEditingController();

  final chatMessages = <String, RxList<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadConsultations();
  }

  Future<void> loadConsultations() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 350));

      final loaded = <Map<String, dynamic>>[
        {
          'id': 'CONS001',
          'doctorId': 'DOC001',
          'doctorName': 'Dr. Priya Sharma',
          'specialization': 'General Medicine',
          'date': 'Apr 24, 2026',
          'time': '10:30 AM',
          'status': 'Upcoming',
          'mode': 'Virtual Video Call',
          'isHomeTreatment': false,
          'problem': 'Persistent headache and mild fever for 3 days',
          'paymentStatus': 'Paid',
          'amount': 700,
        },
        {
          'id': 'CONS002',
          'doctorId': 'DOC003',
          'doctorName': 'Dr. Nisha Verma',
          'specialization': 'Dermatology',
          'date': 'Apr 25, 2026',
          'time': '04:00 PM',
          'status': 'Upcoming',
          'mode': 'Home Treatment',
          'isHomeTreatment': true,
          'problem': 'Skin allergy with redness and itching',
          'paymentStatus': 'Pending',
          'amount': 1400,
        },
        {
          'id': 'CONS003',
          'doctorId': 'DOC002',
          'doctorName': 'Dr. Amit Patel',
          'specialization': 'Cardiology',
          'date': 'Apr 20, 2026',
          'time': '12:00 PM',
          'status': 'Completed',
          'mode': 'Virtual Video Call',
          'isHomeTreatment': false,
          'problem': 'Follow-up for blood pressure review',
          'paymentStatus': 'Paid',
          'amount': 1200,
        },
      ];

      consultations.assignAll(loaded);
      upcomingConsultations.assignAll(
        loaded.where((item) => item['status'] == 'Upcoming').toList(),
      );
      completedConsultations.assignAll(
        loaded.where((item) => item['status'] == 'Completed').toList(),
      );

      for (final consultation in loaded) {
        final id = consultation['id'] as String;
        chatMessages.putIfAbsent(id, () {
          return <Map<String, dynamic>>[
            {
              'sender': consultation['doctorName'],
              'message': 'Please share your latest symptoms in detail.',
              'time': '09:15 AM',
            },
            {
              'sender': 'You',
              'message': consultation['problem'],
              'time': '09:16 AM',
            },
          ].obs;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load consultations');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> startVideoCall(String consultationId) async {
    final consultation = consultations.firstWhereOrNull(
      (item) => item['id'] == consultationId,
    );

    if (consultation == null) {
      Get.snackbar('Error', 'Consultation not found');
      return;
    }

    if (consultation['mode'] != 'Virtual Video Call') {
      Get.snackbar('Not Available', 'Video call is available only for virtual consultations');
      return;
    }

    Get.snackbar(
      'Joining Video Call',
      'Connecting with ${consultation['doctorName']}...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> openChat(String consultationId) async {
    final consultation = consultations.firstWhereOrNull(
      (item) => item['id'] == consultationId,
    );
    if (consultation == null) {
      Get.snackbar('Error', 'Consultation not found');
      return;
    }

    final messages = chatMessages.putIfAbsent(
      consultationId,
      () => <Map<String, dynamic>>[].obs,
    );
    final messageController = TextEditingController();

    Get.bottomSheet(
      Container(
        height: Get.height * 0.72,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Chat - ${consultation['doctorName']}',
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(
                () => ListView.separated(
                  itemCount: messages.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final sentByYou = msg['sender'] == 'You';
                    return Align(
                      alignment:
                          sentByYou ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints:
                            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                        decoration: BoxDecoration(
                          color: sentByYou ? const Color(0xFF2C68E8) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg['message'] as String,
                              style: TextStyle(
                                color: sentByYou ? Colors.white : const Color(0xFF111827),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              msg['time'] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: sentByYou
                                    ? Colors.white.withOpacity(0.85)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Explain your problem...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final message = messageController.text.trim();
                    if (message.isEmpty) {
                      return;
                    }
                    messages.add(
                      {
                        'sender': 'You',
                        'message': message,
                        'time': TimeOfDay.now().format(Get.context!),
                      },
                    );
                    messageController.clear();
                  },
                  child: const Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Future<void> reschedule(String consultationId) async {
    Get.snackbar(
      'Reschedule Requested',
      'The doctor will review your new requested schedule.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  int estimateAmount({
    required String doctorId,
    required String mode,
  }) {
    final doctor = availableDoctors.firstWhereOrNull(
      (item) => item['id'] == doctorId,
    );
    if (doctor == null) {
      return 0;
    }

    if (mode == 'Home Treatment') {
      return doctor['homeTreatmentFee'] as int;
    }
    return doctor['consultationFee'] as int;
  }

  Future<void> createBooking({
    required String doctorId,
    required String mode,
    required DateTime date,
    required String timeSlot,
    required String problem,
    required String paymentMethod,
  }) async {
    final doctor = availableDoctors.firstWhereOrNull(
      (item) => item['id'] == doctorId,
    );
    if (doctor == null) {
      Get.snackbar('Validation', 'Please select a doctor');
      return;
    }

    final amount = estimateAmount(doctorId: doctorId, mode: mode);
    final bookingId = 'CONS${100 + consultations.length + 1}';
    final isPaid = paymentMethod.isNotEmpty;

    final booking = <String, dynamic>{
      'id': bookingId,
      'doctorId': doctor['id'],
      'doctorName': doctor['name'],
      'specialization': doctor['specialization'],
      'date': '${_monthShort(date.month)} ${date.day}, ${date.year}',
      'time': timeSlot,
      'status': 'Upcoming',
      'mode': mode,
      'isHomeTreatment': mode == 'Home Treatment',
      'problem': problem,
      'paymentStatus': isPaid ? 'Paid' : 'Pending',
      'amount': amount,
      'paymentMethod': paymentMethod,
    };

    consultations.insert(0, booking);
    upcomingConsultations.insert(0, booking);
    chatMessages[bookingId] = <Map<String, dynamic>>[
      {
        'sender': doctor['name'],
        'message': 'Thanks. I reviewed your booking details. We will connect soon.',
        'time': '10:00 AM',
      },
    ].obs;

    selectedDoctorId.value = null;
    selectedMode.value = 'Virtual Video Call';
    selectedDate.value = null;
    selectedTimeSlot.value = null;
    selectedPaymentMethod.value = 'UPI';
    problemController.clear();

    Get.back();
    Get.snackbar(
      'Appointment Booked',
      'Your ${mode.toLowerCase()} appointment with ${doctor['name']} is confirmed.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> processPayment({
    required String consultationId,
    required String paymentMethod,
  }) async {
    final index = consultations.indexWhere((item) => item['id'] == consultationId);
    if (index < 0) {
      Get.snackbar('Error', 'Consultation not found for payment');
      return;
    }

    final updated = Map<String, dynamic>.from(consultations[index]);
    updated['paymentStatus'] = 'Paid';
    updated['paymentMethod'] = paymentMethod;
    consultations[index] = updated;

    final upcomingIndex = upcomingConsultations
        .indexWhere((item) => item['id'] == consultationId);
    if (upcomingIndex >= 0) {
      upcomingConsultations[upcomingIndex] = updated;
    }

    Get.snackbar(
      'Payment Successful',
      'Payment completed via $paymentMethod.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> bookDoctor() async {
    Get.snackbar(
      'Book Appointment',
      'Use the + button to open booking and payment options.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  String _monthShort(int month) {
    const monthMap = [
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
    return monthMap[month - 1];
  }

  Future<void> refreshConsultations() async {
    await loadConsultations();
  }

  @override
  void onClose() {
    problemController.dispose();
    super.onClose();
  }
}
