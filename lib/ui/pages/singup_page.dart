import 'package:enagro_app/ui/widgets/default_button.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final fullNameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: ListView(
        padding: const EdgeInsets.all(28.0),
        children: [Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Text(
              "Bem vindo!",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Crie uma conta",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 100),
            const DefaultTextField(
                fieldlabel: 'Email', type: TextInputType.emailAddress),
            const SizedBox(height: 25),
            const DefaultTextField(
                fieldlabel: 'Nome Completo', type: TextInputType.text),
            const SizedBox(height: 25),
            const DefaultTextField(
                fieldlabel: 'Senha',
                type: TextInputType.visiblePassword,
                isPass: true),
            const SizedBox(height: 25),
            const DefaultTextField(
                fieldlabel: 'Confirme sua senha',
                type: TextInputType.visiblePassword,
                isPass: true),
            const SizedBox(height: 25),
            DefaultButton(
              'Cadastrar',
              () {},
              width: 400,
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
        ]
      ),
    );
  }
}
