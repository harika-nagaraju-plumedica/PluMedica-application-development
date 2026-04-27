import 'package:flutter/foundation.dart';

/// Base service class for API calls and data operations
abstract class BaseService {
  /// Override to initialize service
  void initialize() {
    debugLog('Service initialized');
  }

  /// Override to dispose service
  void dispose() {
    debugLog('Service disposed');
  }

  /// Print debug messages
  void debugLog(String message) {
    if (kDebugMode) {
      print('$runtimeType: $message');
    }
  }

  /// Print error messages
  void errorLog(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR $runtimeType: $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }
}
