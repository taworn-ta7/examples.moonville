import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moonville_client_dart/moonville_client_models.dart' as models;
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../i18n/strings.g.dart';
import '../loggings.dart';
import '../styles.dart';
import '../app_shared.dart';
import '../ui/custom_app_bar.dart';
import '../ui/custom_drawer.dart';

/// SettingsPage class.
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

/// _SettingsState internal class.
class _SettingsState extends State<SettingsPage> {
  static final log = Logger('SettingsPage');

  @override
  void initState() {
    super.initState();
    log.fine("$this initState()");
  }

  @override
  void dispose() {
    log.fine("$this dispose()");
    super.dispose();
  }

  // ----------------------------------------------------------------------

  /// Build widget tree.
  @override
  Widget build(BuildContext context) {
    final tr = t.settingsPage;
    return Scaffold(
      appBar: CustomAppBar(
        title: tr.title,
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Styles.around(
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // locale
              Text(
                tr.locale,
                style: Styles.titleTextStyle(),
              ),
              Styles.betweenVertical(),
              Row(
                children: [
                  // English language
                  IconButton(
                    icon: Image.asset('assets/locales/en.png'),
                    tooltip: t.switchLocale.en,
                    onPressed: () => _changeLocale('en'),
                  ),

                  // Thai language
                  IconButton(
                    icon: Image.asset('assets/locales/th.png'),
                    tooltip: t.switchLocale.th,
                    onPressed: () => _changeLocale('th'),
                  ),
                ],
              ),
              Styles.betweenVerticalBigger(),

              // color theme
              Text(
                tr.color,
                style: Styles.titleTextStyle(),
              ),
              Styles.betweenVertical(),
              Row(children: _buildColorButtons(context, 0, 4)),
              Styles.betweenVertical(),
              Row(children: _buildColorButtons(context, 4, 8)),
              Styles.betweenVertical(),
              Row(children: _buildColorButtons(context, 8, 12)),
              Styles.betweenVertical(),
              Row(children: _buildColorButtons(context, 12, 16)),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildColorButtons(
    BuildContext context,
    int start,
    int end,
  ) {
    const text = Text('    ');
    final result = <Widget>[];
    for (var i = start; i < end; i++) {
      final color = AppShared.themeList[i];
      result.add(
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          child: Styles.buttonPadding(text),
          onPressed: () => _changeColorTheme(i),
        ),
      );
      result.add(
        Styles.betweenHorizontal(),
      );
    }
    return result;
  }

  // ----------------------------------------------------------------------

  Future<void> _changeLocale(String locale) async {
    setState(() {
      AppShared.instance().changeLocale(context, locale);
    });

    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'locale': locale,
      },
    });

    // call REST
    late final RestResult rest;
    try {
      rest = RestResult(
        await http.put(
          client.getUri('settings'),
          headers: client.headers,
          body: json,
        ),
      );
    } catch (ex) {
      rest = RestResult.error(ex.toString());
    }
    if (!rest.ok) return;

    // get result
    final item = models.AccountUser.fromJson(rest.json['user']);
    log.finer("user: $item");

    // update client user
    client.update(item);
  }

  Future<void> _changeColorTheme(int index) async {
    setState(() {
      AppShared.instance().changeTheme(context, index);
    });

    final shared = AppShared.instance();
    final client = shared.client;

    // convert data to JSON
    final json = client.formatJson({
      'user': {
        'theme': index,
      },
    });

    // call REST
    late final RestResult rest;
    try {
      rest = RestResult(
        await http.put(
          client.getUri('settings'),
          headers: client.headers,
          body: json,
        ),
      );
    } catch (ex) {
      rest = RestResult.error(ex.toString());
    }
    if (!rest.ok) return;

    // get result
    final item = models.AccountUser.fromJson(rest.json['user']);
    log.finer("user: $item");

    // update client user
    client.update(item);
  }
}
