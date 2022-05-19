import 'dart:typed_data';
import 'package:logging/logging.dart';
import 'package:http/http.dart' as http;
import './models/account_user.dart' as models;
import './rest_result.dart';
import './rest_with_data.dart';
import './client.dart';

class RestAccountUsers {
  static final log = Logger('RestAccountUsers');

  static Future<RestWithData<models.AccountUser>> get(
    Client client, {
    required String email,
    required bool withIcon,
    required bool errorIcon,
  }) async {
    // get data
    final rd0 = await getData(client, email: email);
    if (!rd0.ok) return rd0;
    if (!withIcon) return rd0;

    // get icon
    final rd1 = await getIcon(client, email: email);
    if (!rd1.ok) {
      if (errorIcon) return RestWithData(rest: rd1.rest, data: null);
    }

    // return the result
    if (rd1.data != null) rd0.data!.icon = rd1.data;
    return rd0;
  }

  // ----------------------------------------------------------------------

  static Future<RestWithData<models.AccountUser>> getData(
    Client client, {
    required String email,
  }) async {
    // call REST
    late final RestResult rest;
    try {
      rest = RestResult(
        await http.get(
          client.getUri('accounts/users/$email'),
          headers: client.headers,
        ),
      );
    } catch (ex) {
      rest = RestResult.error(ex.toString());
    }
    if (!rest.ok) {
      return RestWithData(rest: rest, data: null);
    }

    // get result
    final item = models.AccountUser.fromJson(rest.json['user']);
    log.finer("user: $item");
    return RestWithData(rest: rest, data: item);
  }

  // ----------------------------------------------------------------------

  static Future<RestWithData<Uint8List>> getIcon(
    Client client, {
    required String email,
  }) async {
    // call REST
    late final RestResult rest;
    try {
      rest = RestResult(
        await http.get(
          client.getUri('accounts/users/icon/$email'),
          headers: client.headers,
        ),
      );
    } catch (ex) {
      rest = RestResult.error(ex.toString());
    }
    if (!rest.ok) {
      return RestWithData(rest: rest, data: null);
    }

    // return the result
    return RestWithData(rest: rest, data: rest.res!.bodyBytes);
  }
}
