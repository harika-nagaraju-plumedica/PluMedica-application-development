class ApiEndpoints {
  static const String _defaultBaseUrl = 'https://plumedica-backend.onrender.com';

  // Override with --dart-define=BASE_URL=https://your-domain.com
  static const String _rawBaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get baseUrl {
    var value = _rawBaseUrl.trim();

    // Support values pasted like "https://host#BASE_URL".
    if (value.endsWith('#BASE_URL')) {
      value = value.substring(0, value.length - '#BASE_URL'.length);
    }

    if (value.isEmpty || value.contains('{{BASE_URL}}')) {
      return _defaultBaseUrl;
    }

    if (value.endsWith('/')) {
      value = value.substring(0, value.length - 1);
    }

    return value;
  }

  static bool get isUsingFallbackBaseUrl {
    return _rawBaseUrl.trim().isEmpty || _rawBaseUrl.contains('{{BASE_URL}}');
  }

  static const String doctorRegistration = '/api/doctors';
  static const String authLogin = '/api/auth/login';
  static const String patientRegistration = '/api/patients';
  static const String hospitalRegistration = '/api/hospitals';
  static const String pharmacyRegistration = '/api/pharmacies';
  static const String employerRegistration = '/api/employers';
  static const String partnerOrganizationRegistration = '/api/partner-organizations';
  static const String diagnosticsCenterRegistration = '/api/diagnostics-centers';
}
