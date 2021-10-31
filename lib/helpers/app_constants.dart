// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AppConstants {
  static const String APP_PRIMARY_COLOR = "#026be4";
  static const String APP_BACKGROUND_COLOR = "#F6F8F9";
  static const String APP_BACKGROUND_COLOR_WHITE = "#FFFFFF";
  static const String APP_PRIMARY_COLOR_LIGHT = "#9f9f9f";

  static const String APP_PRIMARY_COLOR_BLACK = "#000000";
  static const String APP_PRIMARY_FONT_COLOR_WHITE = "#FFFFFF";
  static const String APP_PRIMARY_FONT_COLOR_LIGHT = "#9f9f9f";

  static const String APP_PRIMARY_COLOR_ACTION = "#026be4";
  static const String APP_PRIMARY_TILE_COLOR = "#7eb1fb";
  static const String APP_PRIMARY_COLOR_GREEN = "#009099";
  static const String APP_BACKGROUND_COLOR_GRAY = "#D0D0D0";

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
