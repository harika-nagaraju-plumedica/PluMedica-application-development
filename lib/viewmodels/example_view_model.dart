import 'base_view_model.dart';

/// Example view model for managing state and business logic
class ExampleViewModel extends BaseViewModel {
  /// Clear selection
  void clearSelection() {
    notifyListeners();
  }
}
