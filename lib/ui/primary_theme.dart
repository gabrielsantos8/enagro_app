import 'package:flutter/material.dart';

ThemeData primaryTheme() {
  const corPrimaria = Color.fromARGB(255, 0, 150, 50);
  const corPrimariaEscura = Color.fromARGB(255, 0, 102, 34);
  const corPrimariaClara = Color.fromARGB(255, 1, 206, 70);
  const backgroundColor = Color.fromARGB(255, 255, 255, 255);
  const loginColor = Color.fromARGB(255, 255, 255, 255);

  final inputDecoration = InputDecorationTheme(
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: corPrimariaEscura, width: 2),
      // borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: corPrimariaClara, width: 3),
      // borderRadius: BorderRadius.circular(20),
    ),
  );

  final buttonDecoration = ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(corPrimaria),
      padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 28, vertical: 18)
      )
    )
  );

  const appBarDecoration = AppBarTheme(
    color: corPrimaria,
    titleTextStyle: TextStyle(fontSize: 28, color: Color.fromARGB(255, 255, 255, 255)),
    centerTitle: true
  );

  return ThemeData(
    primaryColor: corPrimaria,
    primaryColorDark: corPrimariaEscura,
    primaryColorLight: corPrimariaClara,
    appBarTheme: appBarDecoration,
    inputDecorationTheme: inputDecoration,
    elevatedButtonTheme: buttonDecoration,
    cardColor: backgroundColor,
    focusColor: loginColor
  );
}