import 'package:file_picker/file_picker.dart';

class FilePickUtils {
  static Future<String?> pickSingleFileName({
    String dialogTitle = 'Select file',
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        dialogTitle: dialogTitle,
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      return result.files.single.name;
    } catch (_) {
      return null;
    }
  }
}
