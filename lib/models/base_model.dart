import 'package:flutter/foundation.dart';

/// Base model for all data models
abstract class BaseModel {
  /// Convert model to JSON
  Map<String, dynamic> toJson();

  /// Create model from JSON
  static BaseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('fromJson must be implemented in subclass');
  }

  /// Debug print
  void debugLog(String message) {
    if (kDebugMode) {
      print('$runtimeType: $message');
    }
  }
}
