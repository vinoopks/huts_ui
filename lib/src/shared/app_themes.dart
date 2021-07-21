import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_styles.dart';

ThemeData lightThemeData = themeData(
      colorScheme: lightColorScheme,
      appbarTheme: appBarThemeLight,
      focusColor: AppColors.kcLightFocusColor);

   ThemeData darkThemeData = themeData(
      colorScheme: darkColorScheme,
      appbarTheme: appBarThemeDark,
      focusColor: AppColors.kcDarkFocusColor);

        ThemeData themeData(
      {required ColorScheme colorScheme, required AppBarTheme appbarTheme, Color? focusColor}) {
    return ThemeData(
      backgroundColor: colorScheme.background,
      buttonColor: colorScheme.primary,
      colorScheme: colorScheme,
      textTheme: textTheme,
    
      primaryColor: colorScheme.primary,
      indicatorColor: colorScheme.onSurface.withOpacity(0.7),
    
      accentIconTheme: IconThemeData(
          color: colorScheme.brightness == Brightness.dark
              ? AppColors.kcDarkGrey
              : AppColors.kcDarkestGrey.withOpacity(0.8)),
      appBarTheme: appbarTheme.copyWith(
          color: colorScheme.background, brightness: colorScheme.brightness),
      bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
        backgroundColor:colorScheme.background,
          unselectedItemColor: colorScheme.onBackground),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.primary,
      focusColor: focusColor,
    );
  }

  