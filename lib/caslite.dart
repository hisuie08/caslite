import 'package:caslite/main.dart';
import 'package:caslite/providers/theme_provider.dart';
import 'package:caslite/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final String appName = AppInfo().package.appName;
final String appVersion = AppInfo().package.version;

class CasliteApp extends ConsumerWidget {
  const CasliteApp({super.key});
  static final theme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: "Noto Sans JP");
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: appName,
      theme: theme,
      darkTheme: theme.copyWith(colorScheme: darkColorScheme),
      themeMode: ref.watch(casliteThemeProvider).themeMode,
      home: const Home(),
    );
  }
}

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF005AC3),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFD8E2FF),
  onPrimaryContainer: Color(0xFF001A42),
  secondary: Color(0xFFAF3000),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFFFDBD1),
  onSecondaryContainer: Color(0xFF3A0A00),
  tertiary: Color(0xFF715573),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFFFCD7FB),
  onTertiaryContainer: Color(0xFF29132D),
  error: Color(0xFFBA1A1A),
  errorContainer: Color(0xFFFFDAD6),
  onError: Color(0xFFFFFFFF),
  onErrorContainer: Color(0xFF410002),
  background: Color(0xFFFEFBFF),
  onBackground: Color(0xFF1B1B1F),
  surface: Color(0xFFFEFBFF),
  onSurface: Color(0xFF1B1B1F),
  surfaceVariant: Color(0xFFE1E2EC),
  onSurfaceVariant: Color(0xFF44474F),
  outline: Color(0xFF75777F),
  onInverseSurface: Color(0xFFF2F0F4),
  inverseSurface: Color(0xFF303034),
  inversePrimary: Color(0xFFAEC6FF),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFF005AC3),
  outlineVariant: Color(0xFFC5C6D0),
  scrim: Color(0xFF000000),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFFAEC6FF),
  onPrimary: Color(0xFF002E6A),
  primaryContainer: Color(0xFF004395),
  onPrimaryContainer: Color(0xFFD8E2FF),
  secondary: Color(0xFFFFB59F),
  onSecondary: Color(0xFF5F1600),
  secondaryContainer: Color(0xFF862300),
  onSecondaryContainer: Color(0xFFFFDBD1),
  tertiary: Color(0xFFDEBCDF),
  onTertiary: Color(0xFF402843),
  tertiaryContainer: Color(0xFF583E5B),
  onTertiaryContainer: Color(0xFFFCD7FB),
  error: Color(0xFFFFB4AB),
  errorContainer: Color(0xFF93000A),
  onError: Color(0xFF690005),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF1B1B1F),
  onBackground: Color(0xFFE3E2E6),
  surface: Color(0xFF1B1B1F),
  onSurface: Color(0xFFE3E2E6),
  surfaceVariant: Color(0xFF44474F),
  onSurfaceVariant: Color(0xFFC5C6D0),
  outline: Color(0xFF8E9099),
  onInverseSurface: Color(0xFF1B1B1F),
  inverseSurface: Color(0xFFE3E2E6),
  inversePrimary: Color(0xFF005AC3),
  shadow: Color(0xFF000000),
  surfaceTint: Color(0xFFAEC6FF),
  outlineVariant: Color(0xFF44474F),
  scrim: Color(0xFF000000),
);
