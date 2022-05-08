import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './constants.dart';
import './loggings.dart';
import './i18n/strings.g.dart';
import './app.dart';

/// AppShared singleton class.
class AppShared {
  static AppShared? _instance;

  static AppShared instance() {
    _instance ??= AppShared();
    return _instance!;
  }

  // ----------------------------------------------------------------------

  static final log = Logger('AppShared');

  /// Construction.
  AppShared();

  // ----------------------------------------------------------------------

  //
  // Localization
  //

  /// Supported locale list.
  final localeList = const [
    Locale('en'),
    Locale('th'),
  ];

  /// Current locale.
  Locale get currentLocale => localeList[_indexLocale];
  int _indexLocale = 0;

  /// Change current locale.
  void changeLocale(BuildContext context, String locale) {
    late int i;
    switch (locale) {
      case 'th':
        i = 1;
        break;

      case 'en':
      case '':
      default:
        i = 0;
        break;
    }

    if (_indexLocale != i) {
      _indexLocale = i;
      log.info('change locale to $locale');
      LocaleSettings.setLocaleRaw(locale);
      App.refresh(context);
    }
  }

  // ----------------------------------------------------------------------

  //
  // Theme
  //

  /// Material color list.
  static List<MaterialColor> themeList = [
    Colors.deepOrange,
    Colors.orange,
    Colors.amber,
    Colors.yellow,
    Colors.lime,
    Colors.lightGreen,
    Colors.green,
    Colors.teal,
    Colors.cyan,
    Colors.lightBlue,
    Colors.blue,
    Colors.indigo,
    Colors.blueGrey,
    Colors.red,
    Colors.pink,
    Colors.purple,
  ];

  /// Current theme.
  MaterialColor get currentTheme => themeList[_indexTheme];
  int _indexTheme = 0;

  /// Change current theme.
  void changeTheme(BuildContext context, int index) {
    if (index < 0 || index >= themeList.length) return;

    if (_indexTheme != index) {
      _indexTheme = index;
      log.info('change theme to $_indexTheme');

      App.refresh(context);
    }
  }

  // ----------------------------------------------------------------------

  /// Moonville client.
  final Client client = Client(baseUri: Constants.baseUri);

  /// Login task.
  void login(
    BuildContext context,
    models.AccountUser user,
    String token,
  ) async {
    // login logic
    client.login(user, token);

    // set login flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user.login', true);

    // set user settings
    changeLocale(context, client.user!.locale);
    changeTheme(context, client.user!.theme);
    log.info('login to system, welcome :)');
  }

  /// Logout task.
  void logout(
    BuildContext context,
  ) async {
    // logout service.
    RestResult(await http.put(
      client.getUri('authen/logout'),
      headers: client.headers,
    ));

    // remove login flag
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user.login');

    // move out to first page
    Navigator.popUntil(context, (route) => route.isFirst);
    changeTheme(context, 0);
    log.info('logout from system gracefully :)');

    // logout logic
    client.logout();
  }
}
