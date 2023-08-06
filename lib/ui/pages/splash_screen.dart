import 'package:enagro_app/datasource/remote/user_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/entry_page.dart';
import 'package:enagro_app/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    verifyLogin();
  }

  void verifyLogin() {
    _isAuth();
  }

  void getUser() async {
    Map<String, dynamic> tokenInfos = await UserRemote.getTokenInfos();
    User user = User.fromMap(tokenInfos);
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage(user)),
    );
  }

  void navigateToEntryPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EntryPage()),
    );
  }

  void _isAuth() async {
    bool isAuth = await UserRemote.isAuthenticated();
    if (isAuth) {
      getUser();
    } else {
      navigateToEntryPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: const Center(
          child: CircularProgressIndicator(
              backgroundColor: Color.fromARGB(255, 0, 150, 50))),
    );
  }
}
