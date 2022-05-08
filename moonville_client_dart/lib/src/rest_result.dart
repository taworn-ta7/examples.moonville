import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './rest_error.dart';

/// REST call result.
class RestResult {
  static final log = Logger('RestResult');

  late final http.Response? res;
  late final bool ok;
  late final Map<String, dynamic> json;
  late final RestError? error;
  late final String? errorMessage;

  RestResult(http.Response response) {
    res = response;

    ok = [200, 201].contains(res!.statusCode);
    try {
      json = jsonDecode(res!.body);
    } catch (ex) {
      //
    }
    if (ok) {
      error = null;
      errorMessage = null;
    } else {
      if (json.containsKey('error')) {
        error = RestError.fromJson(json['error']);
        errorMessage = null;
      } else {
        error = null;
        errorMessage = 'unknown error!';
      }
    }

    final req = res!.request!;
    final prefix = '${req.method} ${req.url}';
    if (!ok) {
      log.warning('$prefix: $error');
    } else {
      log.info('$prefix: ${res!.statusCode} ${res!.reasonPhrase}');
    }
  }

  RestResult.error(String ex) {
    ok = false;
    json = jsonDecode('{}');
    error = null;
    errorMessage = ex;
    log.severe(errorMessage);
  }
}
