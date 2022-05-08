import 'package:decimal/decimal.dart';

class Validators {
  static bool isMinInt(String value, int min) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v < min) return false;
    return true;
  }

  static bool isMaxInt(String value, int max) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v > max) return false;
    return true;
  }

  static bool isPositiveInt(String value) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v <= 0) return false;
    return true;
  }

  static bool isPositiveOrZeroInt(String value) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v < 0) return false;
    return true;
  }

  static bool isNegativeInt(String value) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v >= 0) return false;
    return true;
  }

  static bool isNegativeOrZeroInt(String value) {
    final v = int.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v > 0) return false;
    return true;
  }

  // ----------------------------------------------------------------------

  static bool isMinFloat(String value, double min) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v < min) return false;
    return true;
  }

  static bool isMaxFloat(String value, double max) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v > max) return false;
    return true;
  }

  static bool isPositiveFloat(String value) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v <= 0) return false;
    return true;
  }

  static bool isPositiveOrZeroFloat(String value) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v < 0) return false;
    return true;
  }

  static bool isNegativeFloat(String value) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v >= 0) return false;
    return true;
  }

  static bool isNegativeOrZeroFloat(String value) {
    final v = double.tryParse(value);
    if (v == null || v.isNaN || v.isInfinite || v > 0) return false;
    return true;
  }

  // ----------------------------------------------------------------------

  static bool isMoney(String value) {
    final v = Decimal.tryParse(value);
    if (v == null) return false;
    return true;
  }

  // ----------------------------------------------------------------------

  static bool isMinLength(String value, int min) {
    if (value.length < min) return false;
    return true;
  }

  static bool isMaxLength(String value, int max) {
    if (value.length > max) return false;
    return true;
  }

  // ----------------------------------------------------------------------

  static final regEmail = RegExp(r'^[^ \t@]+@[^ \t@.]+\.[^ \t@]+$');
  static bool isEmail(String value) => regEmail.hasMatch(value);
}
