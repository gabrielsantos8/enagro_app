import 'package:enagro_app/ui/pages/signin_page.dart';
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

  String _errorMessage = '';

  void _signUp() {
    String email = emailController.text;
    String fullName = fullNameController.text;
    String password = passwordController.text;
    String passwordConfirm = passwordConfirmController.text;

    if (!_validateAll(email, fullName, password, passwordConfirm)) {
      return;
    }

    print('Cadastro realizado com sucesso!');
  }

  bool _validateEmail(String email) {
    RegExp regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    _errorMessage =
        regex.hasMatch(email) ? '' : 'O email informado é inválido.';
    return _errorMessage.isEmpty;
  }

  bool _validateFullName(String fullName) {
    bool isValid = fullName.trim().split(' ').length > 1;
    _errorMessage = isValid ? '' : 'Informe o nome completo.';
    return isValid;
  }

  bool _validatePasswords(String pass1, String pass2) {
    bool isValid = (pass1 == pass2);
    _errorMessage = isValid ? '' : 'As senhas não são iguais.';
    return isValid;
  }

  bool _validatePasswordRules(String password) {
    if (password.length < 8) {
      _errorMessage = 'A senha deve ter no mínimo 8 caracteres.';
      return false;
    }

    if (!password.contains(RegExp(r'[A-Z]'))) {
      _errorMessage = 'A senha deve ter ao menos um caractere maiúsculo.';
      return false;
    }

    if (!password.contains(RegExp(r'[0-9]'))) {
      _errorMessage = 'A senha deve ter ao menos um número.';
      return false;
    }

    _errorMessage = '';
    return true;
  }

  bool _validateFields(
      String email, String fullName, String pass1, String pass2) {
    bool isValid = true;
    if (email.isEmpty) {
      _errorMessage = 'O campo email é obrigatório.';
      isValid = false;
    } else if (fullName.isEmpty) {
      _errorMessage = 'O campo nome completo é obrigatório.';
      isValid = false;
    } else if (pass1.isEmpty) {
      _errorMessage = 'O campo senha é obrigatório.';
      isValid = false;
    } else if (pass2.isEmpty) {
      _errorMessage = 'O campo confirme sua senha é obrigatório.';
      isValid = false;
    } else {
      _errorMessage = '';
    }
    return isValid;
  }

  bool _validateAll(String email, String fullName, String pass1, String pass2) {
    setState(() {
      _errorMessage = _errorMessage;
    });
    return _validateEmail(email) &&
        _validateFullName(fullName) &&
        _validateFields(email, fullName, pass1, pass2) &&
        _validatePasswords(pass1, pass2) &&
        _validatePasswordRules(pass1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: ListView(padding: const EdgeInsets.all(28.0), children: [
        Column(
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
            DefaultTextField(
                fieldlabel: 'Email',
                type: TextInputType.emailAddress,
                controller: emailController),
            const SizedBox(height: 25),
            DefaultTextField(
                fieldlabel: 'Nome Completo',
                type: TextInputType.text,
                controller: fullNameController),
            const SizedBox(height: 25),
            DefaultTextField(
                fieldlabel: 'Senha',
                type: TextInputType.visiblePassword,
                isPass: true,
                controller: passwordController),
            const SizedBox(height: 25),
            DefaultTextField(
                fieldlabel: 'Confirme sua senha',
                type: TextInputType.visiblePassword,
                isPass: true,
                controller: passwordConfirmController),
            const SizedBox(height: 25),
            DefaultButton(
              'Cadastrar',
              _signUp,
              width: 400,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 30),
            const Text(
              "Já tem uma conta?",
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SigninPage()),
                );
              },
              child: const Text(
                "Entre em sua conta",
                style: TextStyle(
                  fontSize: 18,
                  color: Color.fromARGB(255, 1, 206, 70),
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
