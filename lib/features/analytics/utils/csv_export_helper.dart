import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CsvExportHelper {
  /// Export CSV data
  /// On Windows: Save to Downloads folder and open file location
  /// On Android: Share via system share dialog
  static Future<void> exportCsv({
    required String csvContent,
    required String fileName,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('CSV export is not supported on web');
    }

    if (Platform.isWindows) {
      await _saveToDownloads(csvContent, fileName);
    } else if (Platform.isAndroid) {
      await _shareFile(csvContent, fileName);
    } else {
      throw UnsupportedError('Platform not supported for CSV export');
    }
  }

  /// Save CSV to Downloads folder on Windows
  static Future<String> _saveToDownloads(
    String csvContent,
    String fileName,
  ) async {
    // Get Downloads directory
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception('Could not access Downloads directory');
    }

    // Create file path
    final filePath = '${directory.path}\\$fileName';
    final file = File(filePath);

    // Write CSV content
    await file.writeAsString(csvContent);

    return filePath;
  }

  /// Share CSV file on Android
  static Future<void> _shareFile(
    String csvContent,
    String fileName,
  ) async {
    // Get temporary directory
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    // Write CSV content
    await file.writeAsString(csvContent);

    // Share the file
    await Share.shareXFiles(
      [XFile(filePath)],
      subject: 'Analytics Export',
      text: 'PlanPal Analytics Data',
    );
  }
}
