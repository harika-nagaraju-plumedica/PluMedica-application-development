import 'package:get/get.dart';
import '../../controllers/patient/patient_fitness_controller.dart';

class PatientFitnessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PatientFitnessController>(
      () => PatientFitnessController(),
    );
  }
}
