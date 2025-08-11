import 'package:intl/intl.dart';

class Utils {
  static String getNumberFormat(number, {String symbol = 'RD \$'}) {
    try {
      return NumberFormat.currency(
        locale: 'en',
        symbol: symbol,
      ).format(double.parse(number.toString()));
    } catch (e) {
      return '0';
    }
  }
}
