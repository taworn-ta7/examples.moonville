import 'package:flutter/material.dart';

/// Custom app styles.
class Styles {
  static Padding around(Widget child) =>
      Padding(padding: const EdgeInsets.all(32), child: child);

  // ----------------------------------------------------------------------

  static Padding betweenVertical() =>
      const Padding(padding: EdgeInsets.only(bottom: 8));

  static Padding betweenVerticalBig() =>
      const Padding(padding: EdgeInsets.only(bottom: 16));

  static Padding betweenVerticalBigger() =>
      const Padding(padding: EdgeInsets.only(bottom: 24));

  // ----------------------------------------------------------------------

  static Padding betweenHorizontal() =>
      const Padding(padding: EdgeInsets.only(right: 8));

  static Padding betweenHorizontalBig() =>
      const Padding(padding: EdgeInsets.only(right: 16));

  static Padding betweenHorizontalBigger() =>
      const Padding(padding: EdgeInsets.only(right: 24));

  // ----------------------------------------------------------------------

  static Padding buttonPadding(Widget child) =>
      Padding(padding: const EdgeInsets.all(12), child: child);

  // ----------------------------------------------------------------------

  static InputBorder inputBorder() =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  // ----------------------------------------------------------------------

  static ButtonStyle linkButton() => ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blue));

  // ----------------------------------------------------------------------

  static TextStyle titleTextStyle() => const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
}
