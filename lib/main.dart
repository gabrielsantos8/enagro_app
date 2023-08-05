import 'package:flutter/material.dart';
import 'ui/pages/entry_page.dart';
import 'ui/primary_theme.dart';
import 'package:flutter/services.dart'; //For using SystemChrome

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: primaryTheme(),
    home: const EntryPage(),
  ));
}