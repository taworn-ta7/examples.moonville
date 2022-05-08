import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';

/// Show progress dialog box while running long time task.
class WaitBox {
  static Future<T> show<T>(
    BuildContext context,
    Future<T> Function() task,
  ) async {
    // open progress dialog box
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
            Text(t.waitBox.message),
            const Padding(
              padding: EdgeInsets.all(8),
            ),
          ],
        ),
      ),
    );

    // do task
    final result = await task();

    // pop out progress dialog box
    Navigator.of(context).pop();
    return result;
  }
}
