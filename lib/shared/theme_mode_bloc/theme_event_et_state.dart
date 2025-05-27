import 'package:flutter/material.dart';

// theme_event.dart
abstract class ThemeEvent {}

class ToggleTheme extends ThemeEvent {}

class LoadTheme extends ThemeEvent {}


class ThemeState {
  final ThemeMode themeMode;
  ThemeState({required this.themeMode});
}
