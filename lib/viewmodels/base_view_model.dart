import 'package:flutter/foundation.dart';

/// Base view model class for all view models
class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  String? _success;

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  String? get success => _success;
  bool get hasSuccess => _success != null;

  /// Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Set error message
  void setError(String? value) {
    _error = value;
    _success = null;
    notifyListeners();
  }

  /// Set success message
  void setSuccess(String? value) {
    _success = value;
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Clear success
  void clearSuccess() {
    _success = null;
    notifyListeners();
  }

  /// Clear all messages
  void clearMessages() {
    _error = null;
    _success = null;
    notifyListeners();
  }

  /// Handle errors safely
  void handleError(dynamic error) {
    final errorMessage = error.toString();
    setError(errorMessage);
    if (kDebugMode) {
      print('ViewModel Error: $errorMessage');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
