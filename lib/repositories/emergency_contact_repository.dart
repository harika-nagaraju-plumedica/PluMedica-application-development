import '../models/emergency_contact.dart';
import '../models/generic_api_response.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class EmergencyContactRepository {
  EmergencyContactRepository(this._apiService);

  final PatientApiService _apiService;

  Future<EmergencyContact> createEmergencyContact(
    CreateEmergencyContactRequest request,
  ) async {
    final raw = await _apiService.post(
      '/api/patient/emergency-contacts',
      request.toJson(),
    );

    final response = GenericApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      fromData: (data) {
        if (data is Map<String, dynamic>) {
          return data;
        }
        return <String, dynamic>{};
      },
    );

    if (!response.success) {
      throw PatientApiException(
        message: response.message.isEmpty
            ? 'Failed to create emergency contact.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    final data = response.data ?? <String, dynamic>{};

    // Required parsing rule: contact is nested inside data.contact._doc.
    final contact = data['contact'] is Map<String, dynamic>
        ? data['contact'] as Map<String, dynamic>
        : <String, dynamic>{};

    final doc = contact['_doc'] is Map<String, dynamic>
        ? contact['_doc'] as Map<String, dynamic>
        : <String, dynamic>{};

    return EmergencyContact.fromJson(doc);
  }
}
