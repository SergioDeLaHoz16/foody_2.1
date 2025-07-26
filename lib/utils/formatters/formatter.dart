import 'package:intl/intl.dart';

class FFormatter {
  static String formateDate(DateTime? date) {
    date ??= DateTime.now();
    return DateFormat('dd/MM/yyyy').format(date);
  }

  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '\$');
    return formatter.format(amount);
  }
}
