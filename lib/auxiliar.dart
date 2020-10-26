import 'package:intl/intl.dart';

class auxiliar {
  getDateTimeNow() {
    DateTime now = DateTime.now();
    return DateFormat('dd/MM/yyyy HH:m:s').format(now);
  }
}