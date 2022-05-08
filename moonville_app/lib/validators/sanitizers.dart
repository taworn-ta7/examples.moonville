import 'package:decimal/decimal.dart';
import 'package:validators/sanitizers.dart' as sanitizers;

class Sanitizers {
  static int toIntOrDefault(
    String value, {
    int defaultValue = 0,
    int radix = 10,
  }) {
    var v = sanitizers.toInt(value, radix: radix);
    if (!v.isFinite) v = defaultValue;
    return v.toInt();
  }

  // ----------------------------------------------------------------------

  static double toFloatOrDefault(
    String value, {
    double defaultValue = 0.0,
  }) {
    var v = sanitizers.toDouble(value);
    if (!v.isFinite) v = defaultValue;
    return v.toDouble();
  }

  // ----------------------------------------------------------------------

  static Decimal toMoneyOrDefault(
    String value,
  ) {
    var v = Decimal.tryParse(value);
    if (v == null) return Decimal.parse('0');
    return v;
  }
}
