export 'sanitizers.dart';
export 'validators.dart';
export 'field_validators.dart';

String? checkValidate(
  List<String? Function()> validators,
) {
  for (var i = 0; i < validators.length; i++) {
    final validator = validators[i];
    final message = validator();
    if (message != null) {
      return message;
    }
  }
  return null;
}
