import 'package:flutter/material.dart';
import 'ui/pages/entry_page.dart';
import 'ui/primary_theme.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: primaryTheme(),
    home: const EntryPage(),
  ));
}