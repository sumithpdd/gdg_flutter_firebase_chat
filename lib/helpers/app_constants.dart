import 'package:flutter/material.dart';

class AppConstants {
  static const String APP_PRIMARY_COLOR = "#EB342E";
  static const String APP_BACKGROUND_COLOR = "#F6F8F9";
  static const String APP_BACKGROUND_COLOR_WHITE = "#FFFFFF";
  static const String APP_PRIMARY_COLOR_LIGHT = "#9f9f9f";
  static const String APP_PRIMARY_COLOR_BLACK = "#000000";
  static const String APP_PRIMARY_FONT_COLOR_WHITE = "#FFFFFF";
  static const String APP_PRIMARY_COLOR_ACTION = "#BC2923";
  static const String APP_PRIMARY_ROOM_COLOR = "#707070";
  static const String APP_PRIMARY_COLOR_GREEN = "#009099";
  static const String APP_BACKGROUND_COLOR_GRAY = "#D0D0D0";

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}
