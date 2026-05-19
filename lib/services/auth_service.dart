import 'package:flutter/foundation.dart';

import 'api_endpoints.dart';
import 'api_exception.dart';
import 'api_response.dart';
import 'dio_service.dart';
import 'patient_session_service.dart';
import 'token_storage_service.dart';

class AuthService {
  AuthService({
    DioService? dioService,
    TokenStorageService? tokenStorageService,
  })  : _dioService = dioService ?? DioService(),
        _tokenStorageService = tokenStorageService ?? TokenStorageService();

  final DioService _dioService;
  final TokenStorageService _tokenStorageService;

  Future<LoginResult> login({
    required String identifier,
    required String password,
  }) async {
    final normalizedIdentifier = identifier.trim();
    final isEmailLogin = _looksLikeEmail(normalizedIdentifier);

    final response = await _dioService.postJson(
      ApiEndpoints.authLogin,
      {
        'emailOrId': normalizedIdentifier,
        'email': isEmailLogin ? normalizedIdentifier : '',
        'id': isEmailLogin ? '' : normalizedIdentifier,
        'generatedId': isEmailLogin ? '' : normalizedIdentifier,
        'password': password,
      },
    );

    final parsed = ApiResponse<LoginData>.fromJson(
      response,
      dataParser: LoginData.fromJson,
    );

    if (!parsed.success || parsed.data == null) {
      throw ApiException(
        message: parsed.message.isEmpty
            ? 'Invalid email or password'
            : parsed.message,
        errorCode: parsed.errorCode,
      );
    }

    final loginData = parsed.data!;
    if (loginData.module.isEmpty) {
      throw ApiException(message: 'Login response missing user module');
    }

    final role = _roleFromModule(loginData.module);
    final extractedEmail = _extractEmail(
      loginDataProfile: loginData.profile,
      fallback: normalizedIdentifier,
      isEmailLogin: isEmailLogin,
    );
    final isApproved = _resolveApprovalStatus(loginData.profile, role);

    final token = loginData.token;
    if (token.isNotEmpty) {
      await _tokenStorageService.saveToken(token);
    }

    await PatientSessionService.markRoleRegistered(
      role,
      email: extractedEmail,
      loginIdentifier: normalizedIdentifier,
      displayName: _extractDisplayName(loginData.profile),
      generatedId: _extractGeneratedId(loginData.profile),
      status: _extractStatus(loginData.profile),
      isApproved: isApproved,
    );

    await PatientSessionService.saveRoleProfile(role, loginData.profile);

    if (isApproved) {
      await PatientSessionService.markRoleLoggedIn(
        role,
        email: extractedEmail,
        loginIdentifier: normalizedIdentifier,
        displayName: _extractDisplayName(loginData.profile),
        generatedId: _extractGeneratedId(loginData.profile),
        status: _extractStatus(loginData.profile),
      );
    }

    return LoginResult(
      module: loginData.module,
      role: role,
      profile: loginData.profile,
      token: token,
      isApproved: isApproved,
      dashboardRoute: PatientSessionService.dashboardRouteForRole(role),
    );
  }

  AppRole _roleFromModule(String module) {
    switch (module.toLowerCase().trim()) {
      case 'doctor':
        return AppRole.doctor;
      case 'patient':
        return AppRole.patient;
      case 'hospital':
        return AppRole.hospital;
      case 'pharmacy':
        return AppRole.pharmacy;
      case 'diagnostics':
      case 'diagnostic':
        return AppRole.diagnostics;
      case 'insurance':
      case 'insurance_partner':
      case 'insurance-partner':
      case 'partner':
        return AppRole.partner;
      case 'job_seeker':
      case 'job-seeker':
      case 'jobseeker':
        return AppRole.jobSeeker;
      case 'employer':
        return AppRole.employer;
      default:
        throw ApiException(message: 'Unsupported module: $module');
    }
  }

  String _extractDisplayName(Map<String, dynamic> profile) {
    const candidateKeys = [
      'fullName',
      'name',
      'hospitalName',
      'legalPharmacyName',
      'organizationName',
      'centerName',
      'displayName',
    ];

    for (final key in candidateKeys) {
      final value = profile[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  String _extractGeneratedId(Map<String, dynamic> profile) {
    const candidateKeys = [
      'generatedId',
      'id',
      'userId',
      'doctorId',
      'hospitalId',
      'pharmacyId',
      'diagnosticsId',
      'centerId',
    ];

    for (final key in candidateKeys) {
      final value = profile[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    return '';
  }

  String _extractStatus(Map<String, dynamic> profile) {
    const candidateKeys = [
      'status',
      'approvalStatus',
      'registrationStatus',
      'verificationStatus',
    ];

    for (final key in candidateKeys) {
      final value = profile[key]?.toString().trim() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }

    return 'Approved';
  }

  bool _looksLikeEmail(String input) {
    return input.contains('@') && input.contains('.');
  }

  String _extractEmail({
    required Map<String, dynamic> loginDataProfile,
    required String fallback,
    required bool isEmailLogin,
  }) {
    final profileEmail = loginDataProfile['email']?.toString().trim() ?? '';
    if (profileEmail.isNotEmpty) {
      return profileEmail;
    }
    if (isEmailLogin) {
      return fallback;
    }
    return '';
  }

  bool _resolveApprovalStatus(Map<String, dynamic> profile, AppRole role) {
    if (!PatientSessionService.requiresSuperAdminApproval(role)) {
      return true;
    }

    final explicitApproval = _extractBoolean(profile, const [
      'isApproved',
      'approved',
      'is_verified',
      'isVerified',
    ]);
    if (explicitApproval != null) {
      return explicitApproval;
    }

    final statusText = _extractStatusText(profile, const [
      'status',
      'approvalStatus',
      'registrationStatus',
      'verificationStatus',
    ]);
    if (statusText != null) {
      if (statusText.contains('pending') || statusText.contains('waiting')) {
        return false;
      }
      if (statusText.contains('approved') || statusText.contains('verified')) {
        return true;
      }
    }

    if (kDebugMode) {
      print('AuthService: approval status not provided by API, defaulting to approved for $role');
    }
    return true;
  }

  bool? _extractBoolean(Map<String, dynamic> profile, List<String> keys) {
    for (final key in keys) {
      final value = profile[key];
      if (value is bool) {
        return value;
      }
      if (value is num) {
        return value != 0;
      }
      if (value is String) {
        final normalized = value.trim().toLowerCase();
        if (normalized == 'true' || normalized == '1') {
          return true;
        }
        if (normalized == 'false' || normalized == '0') {
          return false;
        }
      }
    }
    return null;
  }

  String? _extractStatusText(Map<String, dynamic> profile, List<String> keys) {
    for (final key in keys) {
      final value = profile[key]?.toString().trim().toLowerCase() ?? '';
      if (value.isNotEmpty) {
        return value;
      }
    }
    return null;
  }
}

class LoginData {
  LoginData({
    required this.module,
    required this.profile,
    required this.token,
  });

  final String module;
  final Map<String, dynamic> profile;
  final String token;

  factory LoginData.fromJson(dynamic raw) {
    final map = raw is Map<String, dynamic> ? raw : <String, dynamic>{};
    final profileMap = map['profile'] is Map<String, dynamic>
        ? Map<String, dynamic>.from(map['profile'] as Map)
        : <String, dynamic>{};

    if (profileMap.isEmpty) {
      final flatProfile = Map<String, dynamic>.from(map)
        ..remove('module')
        ..remove('token');
      profileMap.addAll(flatProfile);
    }

    return LoginData(
      module: map['module']?.toString().trim() ?? '',
      profile: profileMap,
      token: map['token']?.toString() ?? '',
    );
  }
}

class LoginResult {
  LoginResult({
    required this.module,
    required this.role,
    required this.profile,
    required this.token,
    required this.isApproved,
    required this.dashboardRoute,
  });

  final String module;
  final AppRole role;
  final Map<String, dynamic> profile;
  final String token;
  final bool isApproved;
  final String dashboardRoute;
}
