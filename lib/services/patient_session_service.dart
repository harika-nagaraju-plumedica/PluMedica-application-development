import 'dart:convert';

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

  static String _displayNameKeyForRole(AppRole role) =>
      '${_roleName(role)}_display_name';

  static String _approvalKeyForRole(AppRole role) =>
      '${_roleName(role)}_is_approved';

    static String _profileKeyForRole(AppRole role) =>
      '${_roleName(role)}_profile';

    static String roleName(AppRole role) => _roleName(role);

    static String dashboardRouteForRole(AppRole role) =>
      _dashboardRouteForRole(role);

  static bool requiresSuperAdminApproval(AppRole role) {
    switch (role) {
      case AppRole.doctor:
      case AppRole.hospital:
      case AppRole.pharmacy:
      case AppRole.partner:
      case AppRole.employer:
        return true;
      case AppRole.patient:
      case AppRole.diagnostics:
      case AppRole.jobSeeker:
        return false;
    }
  }

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

  static Future<bool> isRoleApproved(AppRole role) async {
    if (!requiresSuperAdminApproval(role)) {
      return true;
    }
    final prefs = await SharedPreferences.getInstance();
    // Default to true for legacy local sessions created before approval tracking.
    return prefs.getBool(_approvalKeyForRole(role)) ?? true;
  }

  static Future<void> markRoleApprovalStatus(
    AppRole role,
    bool isApproved,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_approvalKeyForRole(role), isApproved);
    if (!isApproved) {
      await prefs.setBool(_loggedInKeyForRole(role), false);
    }
  }

  static Future<void> markRoleRegistered(
    AppRole role, {
    String? email,
    String? displayName,
    bool? isApproved,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_registeredKeyForRole(role), true);
    if (isApproved != null) {
      await prefs.setBool(_approvalKeyForRole(role), isApproved);
      if (!isApproved) {
        await prefs.setBool(_loggedInKeyForRole(role), false);
      }
    }
    if (email != null && email.isNotEmpty) {
      await prefs.setString(_emailKeyForRole(role), email);
    }
    if (displayName != null && displayName.trim().isNotEmpty) {
      await prefs.setString(_displayNameKeyForRole(role), displayName.trim());
    }
    await _setLastRole(role);
  }

  static Future<void> markRoleLoggedIn(
    AppRole role, {
    String? email,
    String? displayName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_registeredKeyForRole(role), true);
    await prefs.setBool(_loggedInKeyForRole(role), true);
    if (email != null && email.isNotEmpty) {
      await prefs.setString(_emailKeyForRole(role), email);
    }
    if (displayName != null && displayName.trim().isNotEmpty) {
      await prefs.setString(_displayNameKeyForRole(role), displayName.trim());
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

  static Future<String> getRoleDisplayName(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_displayNameKeyForRole(role)) ?? '';
  }

  static Future<void> saveRoleProfile(
    AppRole role,
    Map<String, dynamic> profile,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKeyForRole(role), jsonEncode(profile));
  }

  static Future<Map<String, dynamic>> getRoleProfile(AppRole role) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKeyForRole(role));
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Return empty profile if local cache is invalid.
    }

    return <String, dynamic>{};
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
        if (await isRoleApproved(role)) {
          return _dashboardRouteForRole(role);
        }
        await logoutRole(role);
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

  static Future<void> markRegistered({String? email, String? displayName}) async {
    await markRoleRegistered(
      AppRole.patient,
      email: email,
      displayName: displayName,
    );
  }

  static Future<void> markLoggedIn({String? email, String? displayName}) async {
    await markRoleLoggedIn(
      AppRole.patient,
      email: email,
      displayName: displayName,
    );
  }

  static Future<void> logout() async {
    await logoutRole(AppRole.patient);
  }

  static Future<String> getRegisteredEmail() async {
    return getRoleEmail(AppRole.patient);
  }
}
