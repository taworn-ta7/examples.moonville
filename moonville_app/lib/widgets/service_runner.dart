import 'package:flutter/material.dart';
import 'package:moonville_client_dart/moonville_client_dart.dart';
import '../i18n/strings.g.dart';
import './message_box.dart';
import './wait_box.dart';
import '../app_shared.dart';

/// Call service helper.
class ServiceRunner {
  static Future<RestResult?> execute(
    BuildContext context,
    Future<RestResult> Function() task,
  ) async {
    while (true) {
      // run service(s) and wait
      final result = await WaitBox.show<RestResult>(context, task);
      if (result.ok) {
        return result;
      }

      // get error message
      late String message;
      if (result.error == null) {
        message = t.serviceRunner.message;
      } else {
        final locale = AppShared.instance().currentLocale.languageCode;
        message = result.error!.get(locale);
      }

      // show question dialog box
      final answer = await MessageBox.show(
        context: context,
        message: message,
        caption: t.messageBox.warning,
        options: MessageBoxOptions(
          type: MessageBoxType.retryCancel,
          titleColor: Colors.orange,
          barrierDismissible: true,
          button1Negative: true,
        ),
      );
      if (answer == null || answer == false) {
        return null;
      }
    }
  }
}
