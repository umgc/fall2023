import 'package:moment_dart/moment_dart.dart';
import 'package:timeago/timeago.dart' as timeago;

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

    // If the photo is from today, show how long ago it was instead of the date and time
    if (calculateDifference(timeStamp) == 0) {
      return timeago.format(timeStamp);
    }

    String formattedTime =
        Moment(timeStamp).format('h:mm A'); // Format the time
    String formattedDate =
        Moment(timeStamp).format('MMMM Do, YYYY'); // Format the date

    return '$formattedDate $formattedTime';
  }

  static String getDateTimeString(DateTime? timeStamp) {
    if (timeStamp == null) {
      return 'Date Unknown';
    }

    return Moment(timeStamp).format('yyyy-MM-dd HH:mm:ss');
  }

  /// Returns the difference (in full days) between the provided date and today.
  static int calculateDifference(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}
