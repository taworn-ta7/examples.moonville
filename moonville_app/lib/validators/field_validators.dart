import '../i18n/strings.g.dart';
import './validate.dart';

class FieldValidators {
  static String? checkMinInt(String? value, int min) {
    if (Validators.isMinInt(value ?? '', min)) return null;
    return t.validator.isMinInt(min: min);
  }

  static String? checkMaxInt(String? value, int max) {
    if (Validators.isMaxInt(value ?? '', max)) return null;
    return t.validator.isMaxInt(max: max);
  }

  static String? checkPositiveInt(String? value) {
    if (Validators.isPositiveInt(value ?? '')) return null;
    return t.validator.isPositiveInt;
  }

  static String? checkPositiveOrZeroInt(String? value) {
    if (Validators.isPositiveOrZeroInt(value ?? '')) return null;
    return t.validator.isPositiveOrZeroInt;
  }

  static String? checkNegativeInt(String? value) {
    if (Validators.isNegativeInt(value ?? '')) return null;
    return t.validator.isNegativeInt;
  }

  static String? checkNegativeOrZeroInt(String? value) {
    if (Validators.isNegativeOrZeroInt(value ?? '')) return null;
    return t.validator.isNegativeOrZeroInt;
  }

  // ----------------------------------------------------------------------

  static String? checkMinFloat(String? value, double min) {
    if (Validators.isMinFloat(value ?? '', min)) return null;
    return t.validator.isMinFloat(min: min);
  }

  static String? checkMaxFloat(String? value, double max) {
    if (Validators.isMaxFloat(value ?? '', max)) return null;
    return t.validator.isMaxFloat(max: max);
  }

  static String? checkPositiveFloat(String? value) {
    if (Validators.isPositiveFloat(value ?? '')) return null;
    return t.validator.isPositiveFloat;
  }

  static String? checkPositiveOrZeroFloat(String? value) {
    if (Validators.isPositiveOrZeroFloat(value ?? '')) return null;
    return t.validator.isPositiveOrZeroFloat;
  }

  static String? checkNegativeFloat(String? value) {
    if (Validators.isNegativeFloat(value ?? '')) return null;
    return t.validator.isNegativeFloat;
  }

  static String? checkNegativeOrZeroFloat(String? value) {
    if (Validators.isNegativeOrZeroFloat(value ?? '')) return null;
    return t.validator.isNegativeOrZeroFloat;
  }

  // ----------------------------------------------------------------------

  static String? checkMoney(String? value) {
    if (Validators.isMoney(value ?? '')) return null;
    return t.validator.isMoney;
  }

  // ----------------------------------------------------------------------

  static String? checkMinLength(String? value, int min) {
    if (Validators.isMinLength(value ?? '', min)) return null;
    return t.validator.isMinLength(min: min);
  }

  static String? checkMaxLength(String? value, int max) {
    if (Validators.isMaxLength(value ?? '', max)) return null;
    return t.validator.isMaxLength(max: max);
  }

  // ----------------------------------------------------------------------

  static String? checkEmail(String? value) {
    if (Validators.isEmail(value ?? '')) return null;
    return t.validator.isEmail;
  }
}
