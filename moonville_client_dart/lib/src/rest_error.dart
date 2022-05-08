/// REST call error.
class RestError {
  final int status;
  final String message;
  final Map<String, dynamic> messageLocales;
  final String ref;

  RestError.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        messageLocales = json['messageLocales'],
        ref = json['ref'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'messageLocales': messageLocales,
        'ref': ref,
      };

  @override
  String toString() => '$status $message; ref=$ref';

  // ----------------------------------------------------------------------

  static final _re2 = RegExp(r'^(\w+)[_-](\w+)$');
  static final _re1 = RegExp(r'^(\w+)$');

  /// Get message with locale.
  String get(String locale) {
    var matches = _re2.firstMatch(locale);
    if (matches != null) {
      final key = matches.group(0)!;
      if (messageLocales.containsKey(key)) {
        return messageLocales[key];
      }
    }

    matches = _re1.firstMatch(locale);
    if (matches != null) {
      final key = matches.group(0)!;
      if (messageLocales.containsKey(key)) {
        return messageLocales[key];
      }
    }

    return messageLocales['en'];
  }
}
