import 'dart:convert';

import 'package:file_picker/file_picker.dart';

import 'api_endpoints.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'dio_service.dart';
import 'token_storage_service.dart';

class RegistrationService {
  RegistrationService({
    DioService? dioService,
    TokenStorageService? tokenStorageService,
  })  : _dioService = dioService ?? DioService(),
        _tokenStorageService = tokenStorageService ?? TokenStorageService();

  final DioService _dioService;
  final TokenStorageService _tokenStorageService;

  Future<ApiResponse<RegistrationData>> registerDoctor({
    required String fullName,
    required String email,
    required String mobileNumber,
    required String password,
    required String qualification,
    required String specialization,
    required String yearOfGraduation,
    required String yearsOfExperience,
    required String clinicAddress,
    required String medicalLicenseNumber,
    required List<Map<String, dynamic>> availabilitySlots,
    PlatformFile? medicalLicenseDocument,
  }) async {
    final response = await _dioService.postMultipart(
      ApiEndpoints.doctorRegistration,
      fields: {
        'fullName': fullName,
        'email': email,
        'mobileNumber': mobileNumber,
        'password': password,
        'qualification': qualification,
        'specialization': specialization,
        'yearOfGraduation': yearOfGraduation,
        'yearsOfExperience': yearsOfExperience,
        'clinicAddress': clinicAddress,
        'medicalLicenseNumber': medicalLicenseNumber,
        'availabilitySlots': jsonEncode(availabilitySlots),
      },
      files: {
        'medicalLicenseDocument': medicalLicenseDocument,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerPatient({
    required String fullName,
    required String email,
    required String mobile,
    required String password,
    required String gender,
    required String bloodGroup,
    required String address,
  }) async {
    final response = await _dioService.postJson(
      ApiEndpoints.patientRegistration,
      {
        'fullName': fullName,
        'email': email,
        'mobile': mobile,
        'password': password,
        'gender': gender,
        'bloodGroup': bloodGroup,
        'address': address,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerHospital({
    required String hospitalName,
    required String state,
    required String city,
    required String gstNumber,
    required String ceRegistrationNumber,
    required String email,
    required String mobile,
    required String address,
    required String password,
    PlatformFile? gstCertificate,
    PlatformFile? ceLicense,
  }) async {
    final response = await _dioService.postMultipart(
      ApiEndpoints.hospitalRegistration,
      fields: {
        'hospitalName': hospitalName,
        'state': state,
        'city': city,
        'gstNumber': gstNumber,
        'ceRegistrationNumber': ceRegistrationNumber,
        'email': email,
        'mobile': mobile,
        'address': address,
        'password': password,
      },
      files: {
        'gstCertificate': gstCertificate,
        'ceLicense': ceLicense,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerPharmacy({
    required String legalPharmacyName,
    required String state,
    required String city,
    required String phoneNumber,
    required String gstNumber,
    required bool hasDrugLicense,
    required String email,
    required String password,
    PlatformFile? gstCertificate,
    PlatformFile? drugLicense,
  }) async {
    final response = await _dioService.postMultipart(
      ApiEndpoints.pharmacyRegistration,
      fields: {
        'legalPharmacyName': legalPharmacyName,
        'state': state,
        'city': city,
        'phoneNumber': phoneNumber,
        'gstNumber': gstNumber,
        'hasDrugLicense': hasDrugLicense.toString(),
        'email': email,
        'password': password,
      },
      files: {
        'gstCertificate': gstCertificate,
        'drugLicense': hasDrugLicense ? drugLicense : null,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerEmployer({
    required String companyName,
    required String email,
    required String password,
  }) async {
    final response = await _dioService.postJson(
      ApiEndpoints.employerRegistration,
      {
        'companyName': companyName,
        'email': email,
        'password': password,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerPartnerOrganization({
    required String organizationName,
    required String email,
    required String mobile,
    required String licenseNumber,
    required String password,
  }) async {
    final response = await _dioService.postJson(
      ApiEndpoints.partnerOrganizationRegistration,
      {
        'organizationName': organizationName,
        'email': email,
        'mobile': mobile,
        'licenseNumber': licenseNumber,
        'password': password,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> registerDiagnosticsCenter({
    required String centerName,
    required String email,
    required String password,
  }) async {
    final response = await _dioService.postJson(
      ApiEndpoints.diagnosticsCenterRegistration,
      {
        'centerName': centerName,
        'email': email,
        'password': password,
      },
    );

    return _handleRegistrationResponse(response);
  }

  Future<ApiResponse<RegistrationData>> _handleRegistrationResponse(
    Map<String, dynamic> response,
  ) async {
    final parsed = ApiResponse<RegistrationData>.fromJson(
      response,
      dataParser: RegistrationData.fromJson,
    );

    if (!parsed.success) {
      throw ApiException(
        message: parsed.message.isEmpty
            ? 'Registration failed. Please try again.'
            : parsed.message,
        errorCode: parsed.errorCode,
      );
    }

    final token = parsed.data?.token;
    if (token != null && token.isNotEmpty) {
      await _tokenStorageService.saveToken(token);
    }

    return parsed;
  }
}
