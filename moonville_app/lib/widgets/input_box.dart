import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../i18n/strings.g.dart';

/// Options for InputBox class.
class InputBoxOptions {
  String initialValue;
  int? maxLength;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  bool button0Negative;
  bool button1Negative;
  bool barrierDismissible;

  InputBoxOptions({
    this.initialValue = '',
    this.maxLength,
    this.keyboardType,
    this.inputFormatters,
    this.button0Negative = false,
    this.button1Negative = false,
    this.barrierDismissible = false,
  });
}

/// Generic input dialog box.
class InputBox {
  static Future<String?> show({
    required BuildContext context,
    required String message,
    required String placeholder,
    required InputBoxOptions options,
  }) async {
    final TextEditingController textBox = TextEditingController();
    textBox.text = options.initialValue;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // message
            Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
            ),

            // input
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: placeholder,
              ),
              maxLength: options.maxLength,
              keyboardType: options.keyboardType,
              inputFormatters: options.inputFormatters,
              controller: textBox,
            ),
          ],
        ),
        actions: <Widget>[
          // cancel button
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: options.button1Negative ? Colors.red : Colors.blue,
            ),
            icon: const Icon(Icons.cancel),
            label: Text(t.common.cancel),
            onPressed: () => Navigator.pop(context),
          ),

          // ok button
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: options.button0Negative ? Colors.red : Colors.blue,
            ),
            icon: const Icon(Icons.check_circle),
            label: Text(t.common.ok),
            onPressed: () => Navigator.pop(context, textBox.text),
          ),
        ],
      ),
    );
    return result;
  }
}
