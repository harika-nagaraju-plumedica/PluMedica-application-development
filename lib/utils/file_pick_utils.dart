import 'package:file_picker/file_picker.dart';

class FilePickUtils {
  static Future<PlatformFile?> pickSingleFile({
    String dialogTitle = 'Select file',
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        dialogTitle: dialogTitle,
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return null;
      }

      return result.files.single;
    } catch (_) {
      return null;
    }
  }

  static Future<String?> pickSingleFileName({
    String dialogTitle = 'Select file',
    List<String>? allowedExtensions,
  }) async {
    final file = await pickSingleFile(
      dialogTitle: dialogTitle,
      allowedExtensions: allowedExtensions,
    );
    return file?.name;
  }
}
