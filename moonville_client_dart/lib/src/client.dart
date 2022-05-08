import 'dart:convert';
import 'package:logging/logging.dart';
import './models/account_user.dart';

class Client {
  static final log = Logger('Client');

  /// Base URI.
  String _baseUri = '';
  String get baseUri => _baseUri;

  /// Constructor.
  Client({required String baseUri}) {
    if (!baseUri.endsWith('/')) baseUri += '/';
    _baseUri = baseUri;
    logout();
  }

  /// Default constructor.
  factory Client.def() => Client(baseUri: 'http://127.0.0.1:7000/api/');

  // ----------------------------------------------------------------------

  /// JSON formatter.
  static const _formatter = JsonEncoder.withIndent('  ');

  /// Format map to string JSON.
  String formatJson(
    Object data, {
    bool noLog = false,
  }) {
    final json = _formatter.convert(data);
    if (!noLog) log.finer('JSON: $json');
    return json;
  }

  /// Concat base URI with address, optional with trail query string.
  Uri getUri(String address, [Map<String, String>? query]) {
    var params = Uri(queryParameters: query).query;
    if (params != '') params = '?$params';
    final uri = Uri.parse('$baseUri$address$params');
    log.finer('URI: $uri');
    return uri;
  }

  // ----------------------------------------------------------------------

  /// Request headers.
  Map<String, String> _headers = {};
  Map<String, String> get headers => _headers;

  /// Authen token.
  String _token = '';
  String get token => _token;

  /// Account user.
  AccountUser? _user;
  AccountUser? get user => _user;

  // ----------------------------------------------------------------------

  /// Copy user data along with token.
  void login(AccountUser user, String token) {
    _user = user;
    _token = token;
    _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + _token,
    };
  }

  /// Update user data.
  void update(AccountUser user) {
    if (_user != null) user.icon = _user!.icon;
    _user = user;
  }

  /// Remove user data and token.
  void logout() {
    _user = null;
    _token = '';
    _headers = {
      'Content-Type': 'application/json',
    };
  }
}
