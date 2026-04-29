import 'package:shared_preferences/shared_preferences.dart';

enum AppRole {
  patient,
  doctor,
  hospital,
  pharmacy,
  diagnostics,
  partner,
  jobSeeker,
  employer,
}

class PatientSessionService {
  static const String _lastRoleKey = 'last_active_role';

  static String _roleName(AppRole role) {
    switch (role) {
      case AppRole.patient:
        return 'patient';
      case AppRole.doctor:
        return 'doctor';
      case AppRole.hospital:
        return 'hospital';
      case AppRole.pharmacy:
        return 'pharmacy';
      case AppRole.diagnostics:
        return 'diagnostics';
      case AppRole.partner:
        return 'partner';
      case AppRole.jobSeeker:
        return 'job_seeker';
      case AppRole.employer:
        return 'employer';
    }
  }

  static String _registeredKeyForRole(AppRole role) =>
      '${_roleName(role)}_is_registered';

  static String _loggedInKeyForRole(AppRole role) =>
      '${_roleName(role)}_is_logged_in';

  static String _emailKeyForRole(AppRole role) => '${_roleName(role)}_email';

  static String _dashboardRouteForRole(AppRole role) {
    switch (role) {
      case AppRole.patient:
        return '/patient/dashboard';
      case AppRole.doctor:
        return '/doctor_dashboard';
      case AppRole.hospital:
        return '/hospital/dashboard';
      case AppRole.pharmacy:
        return '/pharmacy/dashboard';
      case AppRole.diagnostics:
        return '/diagnostics/dashboard';
      case AppRole.partner:
        return '/partner/dashboard';
      case AppRole.jobSeeker:
        return '/jobs/search';
      case AppRole.employer:
        return '/jobs/employer/post-job';
    }
  }

  static String _loginRouteForRole(AppRole role) {
    switch (role) {
      case AppRole.patient:
        return '/patient/login';
      case AppRole.doctor:
        return '/doctor_login';
      case AppRole.hospital:
        return '/hospital/login';
      case AppRole.pharmacy:
        return '/pharmacy/login';
      case AppRole.diagnostics:
        return '/diagnostics/login';
      case AppRole.partner:
        return '/partner/login';
      case AppRole.jobSeeker:
        return '/jobs/job-seeker/login';
      case AppRole.employer:
        return '/jobs/employer/login';
    }
  }

  static String registrationRouteForRole(AppRole role) {
    switch (role) {
      case AppRole.patient:
        return '/patient/registration';
      case AppRole.doctor:
        return '/doctor_registration';
      case AppRole.hospital:
        return '/hospital/registration';
      case AppRole.pharmacy:
        return '/pharmacy/registration';
      case AppRole.diagnostics:
        return '/diagnostics/registration';
      case AppRole.partner:
        return '/partner/registration';
      case AppRole.jobSeeker:
        return '/jobs/job-seeker/registration';
      case AppRole.employer:
        return '/jobs/employer/registration';
    }
  }

  static Future<void> _setLastRole(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastRoleKey, _roleName(role));
  }

  static AppRole? _parseRole(String value) {
    for (final role in AppRole.values) {
      if (_roleName(role) == value) {
        return role;
      }
    }
    return null;
  }

  static Future<AppRole?> getLastRole() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastRoleKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }
    return _parseRole(raw);
  }

  static Future<bool> isRoleRegistered(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_registeredKeyForRole(role)) ?? false;
  }

  static Future<bool> isRoleLoggedIn(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKeyForRole(role)) ?? false;
  }

  static Future<void> markRoleRegistered(AppRole role, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_registeredKeyForRole(role), true);
    if (email != null && email.isNotEmpty) {
      await prefs.setString(_emailKeyForRole(role), email);
    }
    await _setLastRole(role);
  }

  static Future<void> markRoleLoggedIn(AppRole role, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_registeredKeyForRole(role), true);
    await prefs.setBool(_loggedInKeyForRole(role), true);
    if (email != null && email.isNotEmpty) {
      await prefs.setString(_emailKeyForRole(role), email);
    }
    await _setLastRole(role);
  }

  static Future<void> logoutRole(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKeyForRole(role), false);
  }

  static Future<String> getRoleEmail(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKeyForRole(role)) ?? '';
  }

  static Future<String> getStartupRoute() async {
    final lastRole = await getLastRole();
    final preferredRoles = lastRole == null ? null : [lastRole];
    final orderedRoles = <AppRole>[
      ...?preferredRoles,
      ...AppRole.values.where((role) => role != lastRole),
    ];

    for (final role in orderedRoles) {
      if (await isRoleLoggedIn(role)) {
        return _dashboardRouteForRole(role);
      }
    }

    for (final role in orderedRoles) {
      if (await isRoleRegistered(role)) {
        return _loginRouteForRole(role);
      }
    }

    return '/role_selection';
  }

  static Future<String> getRoleEntryRoute(AppRole role) async {
    final isRegistered = await isRoleRegistered(role);
    return isRegistered
        ? _loginRouteForRole(role)
        : registrationRouteForRole(role);
  }

  static Future<bool> isRegistered() async {
    return isRoleRegistered(AppRole.patient);
  }

  static Future<bool> isLoggedIn() async {
    return isRoleLoggedIn(AppRole.patient);
  }

  static Future<void> markRegistered({String? email}) async {
    await markRoleRegistered(AppRole.patient, email: email);
  }

  static Future<void> markLoggedIn({String? email}) async {
    await markRoleLoggedIn(AppRole.patient, email: email);
  }

  static Future<void> logout() async {
    await logoutRole(AppRole.patient);
  }

  static Future<String> getRegisteredEmail() async {
    return getRoleEmail(AppRole.patient);
  }
}
