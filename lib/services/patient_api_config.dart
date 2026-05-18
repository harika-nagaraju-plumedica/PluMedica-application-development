class PatientApiConfig {
  static const String _defaultBaseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: '{{BASE_URL}}',
  );

  static const String _defaultToken = String.fromEnvironment(
    'PATIENT_TOKEN',
    defaultValue: '{{PATIENT_TOKEN}}',
  );

  static String get baseUrl {
    var url = _defaultBaseUrl.trim();
    if (url.endsWith('/')) {
      url = url.substring(0, url.length - 1);
    }
    if (url.isEmpty || url.contains('{{BASE_URL}}')) {
      return '';
    }
    return url;
  }

  static String get token {
    final value = _defaultToken.trim();
    if (value.isEmpty || value.contains('{{PATIENT_TOKEN}}')) {
      return '';
    }
    return value;
  }
}
