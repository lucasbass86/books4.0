import 'package:books4/utils/utils.dart';
import 'package:flutter/material.dart';

ThemeData oscuro = ThemeData.dark().copyWith(
  iconTheme: IconThemeData(
    color: Utils.colorIcon,
  ),
  scaffoldBackgroundColor: Utils.colorScaffold,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    secondary: Colors.grey,
    primary: Colors.grey,
  ),
  textTheme: TextTheme(
    bodyLarge:
        TextStyle(color: Utils.colorEtiquetaTexto, fontSize: 19, fontWeight: FontWeight.w600),
    bodyMedium:
        TextStyle(color: Utils.colorEtiquetaTexto, fontSize: 17, fontWeight: FontWeight.w500),
    bodySmall:
        TextStyle(color: Utils.colorEtiquetaTexto, fontSize: 15, fontWeight: FontWeight.w400),
  ),
  inputDecorationTheme: InputDecorationTheme(
    suffixIconColor: Colors.grey,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Utils.circulo1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Utils.circulo1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: Utils.circulo1),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    overlayColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        } else {
          return Utils.circulo1;
        }
      },
    ),
    side: BorderSide(
      color: Utils.circulo1,
    ),
    checkColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return Utils.circulo2;
        } else {
          return Colors.transparent;
        }
      },
    ),
    fillColor: WidgetStateProperty.resolveWith(
      (states) {
        if (states.contains(WidgetState.selected)) {
          return Utils.circulo1;
        } else {
          return Colors.transparent;
        }
      },
    ),
  ),
);
