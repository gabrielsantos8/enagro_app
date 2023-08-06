import 'package:enagro_app/ui/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'ui/primary_theme.dart';
import 'package:flutter/services.dart'; //For using SystemChrome

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp]);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: primaryTheme(),
    home: const SplashScreen(),
  ));
}