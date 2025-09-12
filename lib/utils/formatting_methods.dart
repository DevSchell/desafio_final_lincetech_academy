
import '../use_cases/nominatim_service.dart';

class Utils {

  String dateTimeToStringFormat(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  DateTime stringToDateTimeFormat(String dateString) {
    final parts = dateString.split('/');

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

}