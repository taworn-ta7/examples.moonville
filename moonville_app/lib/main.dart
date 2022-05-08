import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import './i18n/strings.g.dart';
import './loggings.dart';
import './embed.dart';
import './app_shared.dart';
import './app.dart';

/// Main program.
void main() async {
  // initialize loggings
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    // ignore: avoid_print
    (record) => print(
      '${record.time} ${record.level.name.padRight(7)} ${record.loggerName.padRight(12).characters.take(12)} ${record.message}',
    ),
  );

  // initialize localization
  WidgetsFlutterBinding.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  LocaleSettings.setLocaleRaw(AppShared.instance().currentLocale.languageCode);

  if (!kIsWeb) {
    // setup embedding
    await Embed.setup();
  }

  // run app
  runApp(TranslationProvider(child: const App()));
}
