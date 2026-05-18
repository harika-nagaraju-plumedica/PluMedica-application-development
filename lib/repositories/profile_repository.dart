import '../models/generic_api_response.dart';
import '../models/profile_model.dart';
import '../services/patient_api_exception.dart';
import '../services/patient_api_service.dart';

class ProfileRepository {
  ProfileRepository(this._apiService);

  final PatientApiService _apiService;

  Future<ProfileModel> fetchProfile() async {
    final raw = await _apiService.get('/api/patient/profile');
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
            ? 'Failed to load profile.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    return ProfileModel.fromJson(response.data ?? <String, dynamic>{});
  }

  Future<ProfileModel> updateProfile(ProfileUpdateRequest request) async {
    final raw = await _apiService.put('/api/patient/profile', request.toJson());
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
            ? 'Failed to update profile.'
            : response.message,
        type: PatientApiErrorType.badRequest,
      );
    }

    final payload = response.data ?? <String, dynamic>{};
    if (payload['profile'] is Map<String, dynamic>) {
      return ProfileModel.fromJson(payload);
    }

    final fallbackProfile = PatientProfile(
      id: '',
      fullName: request.fullName,
      email: '',
      mobile: request.mobile,
      gender: request.gender,
      bloodGroup: request.bloodGroup,
      address: request.address,
      dob: request.dob,
    );

    return ProfileModel(profile: fallbackProfile);
  }
}
