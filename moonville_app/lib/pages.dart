import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import './i18n/strings.g.dart';
import './widgets/message_box.dart';

class Pages {
  /// Switching current route.
  /// This function is for sub-pages only!
  static Future<T?> switchPage<T extends Object?>(
    BuildContext context,
    Widget widget, {
    Object? arguments,
  }) {
    return Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: widget,
        settings: RouteSettings(arguments: arguments),
      ),
    );
  }

  /// Check before leave page.
  static Future<bool> beforeBack(
    BuildContext context,
    bool changed,
  ) async {
    if (changed) {
      final answer = await MessageBox.question(
        context,
        t.question.areYouSureToLeave,
        MessageBoxOptions(
          button0Negative: true,
        ),
      );
      return answer == true;
    } else {
      return true;
    }
  }

  // ----------------------------------------------------------------------

  static const dashboard = '/dashboard';
  static const accounts = '/accounts';
  static const settings = '/settings';
}
