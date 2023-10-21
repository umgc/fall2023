import 'package:moment_dart/moment_dart.dart';

class FormatUtils {
  static const int bytesInKB = 1024;
  static const int bytesInMB = bytesInKB * 1024;
  static const int bytesInGB = bytesInMB * 1024;

  static String getStorageSizeString(int storageSizeInBytes) {
    double size;
    String unit;

    switch (storageSizeInBytes) {
      case < bytesInKB:
        size = storageSizeInBytes.toDouble();
        unit = 'Bytes';
        break;
      case < bytesInMB:
        size = storageSizeInBytes / bytesInKB;
        unit = 'KB';
        break;
      case < bytesInGB:
        size = storageSizeInBytes / bytesInMB;
        unit = 'MB';
        break;
      default:
        size = storageSizeInBytes / bytesInGB;
        unit = 'GB';
        break;
    }

    return '${size.toStringAsFixed(2)} $unit';
  }

  static String getDateString(DateTime? timeStamp) {
    if (timeStamp == null) {
      return 'N/A';
    }

    return Moment(timeStamp).format('MMMM Do, YYYY');
  }

  static String getDateTimeString(DateTime? timeStamp) {
    if (timeStamp == null) {
      return 'Date Unknown';
    }

    return Moment(timeStamp).format('yyyy-MM-dd HH:mm:ss');
  }
}
