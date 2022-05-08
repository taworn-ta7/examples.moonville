import 'package:flutter/material.dart';
import '../i18n/strings.g.dart';

enum MessageBoxType {
  close,
  ok,
  okCancel,
  yesNo,
  retryCancel,
}

/// Options for MessageBox class.
class MessageBoxOptions {
  MessageBoxType type;
  Color titleColor;
  bool button0Negative;
  bool button1Negative;
  bool barrierDismissible;

  MessageBoxOptions({
    this.type = MessageBoxType.close,
    this.titleColor = Colors.black,
    this.button0Negative = false,
    this.button1Negative = false,
    this.barrierDismissible = false,
  });
}

/// Generic message dialog box.
class MessageBox {
  static Future<bool?> show({
    required BuildContext context,
    required String message,
    required String caption,
    required MessageBoxOptions options,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: options.barrierDismissible,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          caption,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: options.titleColor,
          ),
        ),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
          ],
        ),
        actions: _buildButtons(context, options),
      ),
    );
  }

  static List<Widget> _buildButtons(
    BuildContext context,
    MessageBoxOptions options,
  ) {
    // expand type to button0 and/or button1
    Icon icon0;
    Icon? icon1;
    String button0;
    String? button1;
    switch (options.type) {
      case MessageBoxType.close:
        icon0 = const Icon(Icons.close);
        button0 = t.common.close;
        break;
      case MessageBoxType.ok:
        icon0 = const Icon(Icons.check_circle);
        button0 = t.common.ok;
        break;
      case MessageBoxType.okCancel:
        icon0 = const Icon(Icons.check_circle);
        button0 = t.common.ok;
        icon1 = const Icon(Icons.cancel);
        button1 = t.common.cancel;
        break;
      case MessageBoxType.yesNo:
        icon0 = const Icon(Icons.done);
        button0 = t.common.yes;
        icon1 = const Icon(Icons.cancel);
        button1 = t.common.no;
        break;
      case MessageBoxType.retryCancel:
        icon0 = const Icon(Icons.autorenew);
        button0 = t.common.retry;
        icon1 = const Icon(Icons.cancel);
        button1 = t.common.cancel;
        break;
    }

    // build button list
    if (button1 != null) {
      return <Widget>[
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: options.button1Negative ? Colors.red : Colors.blue,
          ),
          icon: icon1!,
          label: Text(button1),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: options.button0Negative ? Colors.red : Colors.blue,
          ),
          icon: icon0,
          label: Text(button0),
          onPressed: () => Navigator.pop(context, true),
        ),
      ];
    } else {
      return <Widget>[
        TextButton.icon(
          style: TextButton.styleFrom(
            primary: options.button0Negative ? Colors.red : Colors.blue,
          ),
          icon: icon0,
          label: Text(button0),
          onPressed: () => Navigator.pop(context),
        ),
      ];
    }
  }

  // ----------------------------------------------------------------------

  /// Show generic information.
  static Future<void> info(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.info,
      options: MessageBoxOptions(
        barrierDismissible: true,
      ),
    );
  }

  /// Show warning.
  static Future<void> warning(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.warning,
      options: MessageBoxOptions(
        titleColor: Colors.orange,
        barrierDismissible: true,
      ),
    );
  }

  /// Show error.
  static Future<void> error(
    BuildContext context,
    String message,
  ) {
    return show(
      context: context,
      message: message,
      caption: t.messageBox.error,
      options: MessageBoxOptions(
        titleColor: Colors.red,
        barrierDismissible: false,
      ),
    );
  }

  /// Show question.
  static Future<bool?> question(
    BuildContext context,
    String message, [
    MessageBoxOptions? moreOptions,
  ]) {
    final options = moreOptions ?? MessageBoxOptions();
    options.type = MessageBoxType.yesNo;
    options.titleColor = Colors.blue;
    options.barrierDismissible = false;
    return show(
      context: context,
      message: message,
      caption: t.messageBox.question,
      options: options,
    );
  }
}
