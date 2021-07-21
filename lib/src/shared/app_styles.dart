import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './app_colors.dart';

//Text Styles

@protected
ColorScheme lightColorScheme = ColorScheme(
    primary: AppColors.kcPrimaryColor,
    primaryVariant: AppColors.kcPrimaryVariantLight,
    secondary: AppColors.kcSecondaryColor,
    secondaryVariant: AppColors.kcSecondaryVariantLight,
    background: AppColors.kcPureWhite,
    onBackground: AppColors.kcPureBlack,
    error: AppColors.kcRed,
    onError: AppColors.kcPureWhite,
    onPrimary: AppColors.kcPureWhite,
    onSecondary: AppColors.kcPureBlack,
    surface: AppColors.kcPureWhite,
    onSurface: AppColors.kcPureBlack,
    brightness: Brightness.light);

@protected
ColorScheme darkColorScheme = ColorScheme(
    primary: AppColors.kcPrimaryColor,
    primaryVariant: AppColors.kcPrimaryVariantDark,
    secondary: AppColors.kcSecondaryColor,
    secondaryVariant: AppColors.kcSecondayVariantDark,
    background: AppColors.kcDarkBlack_1,
    onBackground: AppColors.kcDarkTextWhite,
    error: AppColors.kcRed,
    onError: AppColors.kcDarkTextWhite,
    onPrimary: AppColors.kcDarkTextWhite,
    onSecondary: AppColors.kcDarkTextWhite,
    surface: AppColors.kcDarkBlack_3,
    onSurface: AppColors.kcDarkTextWhite,
    brightness: Brightness.dark);

@protected
AppBarTheme appBarThemeLight = AppBarTheme(
    elevation: 0,
    textTheme: TextTheme(
        headline6: _appBarDefaultText.copyWith(color: AppColors.kcPureBlack)));

@protected
AppBarTheme appBarThemeDark = AppBarTheme(
  textTheme: TextTheme(
    headline6: _appBarDefaultText.copyWith(color: AppColors.kcAccentColor),
  ),
);

@protected
BottomNavigationBarThemeData bottomNavigationBarTheme =
    BottomNavigationBarThemeData(
  selectedItemColor: AppColors.kcAccentColor,
);

final _light = FontWeight.w300;
final _regular = FontWeight.w400;
final _medium = FontWeight.w500;
final _semiBold = FontWeight.w600;
final _bold = FontWeight.w700;

@protected
final TextTheme textTheme = TextTheme(
  headline1: GoogleFonts.lato(fontWeight: _bold, fontSize: 32),
  headline2: GoogleFonts.lato(fontWeight: _bold, fontSize: 24),
  headline3: GoogleFonts.lato(
    fontWeight: _bold,
    fontSize: 20,
  ),
  headline4: GoogleFonts.mulish(fontWeight: _bold, fontSize: 20),
  headline5: GoogleFonts.mulish(fontWeight: _bold, fontSize: 16),
  headline6: GoogleFonts.lato(
    fontWeight: _bold,
    fontSize: 14,
  ),
  subtitle1: GoogleFonts.lato(fontWeight: _medium, fontSize: 14),
  subtitle2: GoogleFonts.mulish(fontWeight: _medium, fontSize: 14),
  bodyText1: GoogleFonts.lato(fontWeight: _regular, fontSize: 14),
  bodyText2: GoogleFonts.mulish(fontWeight: _regular, fontSize: 14),
  overline: GoogleFonts.lato(fontWeight: _regular, fontSize: 12),
  caption: GoogleFonts.mulish(fontWeight: _regular, fontSize: 12),
  button: GoogleFonts.lato(fontWeight: _bold, fontSize: 14),
);

@protected
TextStyle _appBarDefaultText = GoogleFonts.openSans(
    fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.bold));
