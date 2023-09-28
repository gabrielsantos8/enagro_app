import 'package:enagro_app/ui/pages/signin_page.dart';
import 'package:enagro_app/ui/pages/signup_page.dart';
import 'package:enagro_app/ui/widgets/default_button.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({super.key});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 500,
                    child: Image.asset('images/banner_entrada.png'),
                  ),
                  DefaultButton('Cadastre-se', () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()),
                    );
                  }, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 16),
                  DefaultOutlineButton('Entre', () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SigninPage()),
                    );
                  },
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 150, 50),
                          fontSize: 18)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ));
  }
}
