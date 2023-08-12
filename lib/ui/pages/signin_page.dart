import 'package:enagro_app/datasource/remote/user_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/home_page.dart';
import 'package:enagro_app/ui/pages/signup_page.dart';
import 'package:enagro_app/ui/widgets/default_button.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<User> _signIn(String email, String password) {
    Object params = {"email": email, "password": password};

    UserRemote userRemote = UserRemote();
    Future<User> user = userRemote.login(params);

    return user;
  }

  void _setErrorMsg(String msg) {
    setState(() {
      _errorMessage = msg;
    });
  }

  bool _validateFields(String email, String pass) {
    bool isValid = true;
    if (email.isEmpty) {
      _errorMessage = 'O campo email é obrigatório.';
      isValid = false;
    } else if (pass.isEmpty) {
      _errorMessage = 'O campo senha é obrigatório.';
      isValid = false;
    } else {
      _errorMessage = '';
    }
    _setErrorMsg(_errorMessage);
    return isValid;
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
              "Bem vindo de volta!",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              "Entre",
              style: TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 100),
            DefaultTextField(
                fieldlabel: 'Email',
                type: TextInputType.emailAddress,
                controller: emailController),
            const SizedBox(height: 25),
            DefaultTextField(
                fieldlabel: 'Senha',
                type: TextInputType.visiblePassword,
                isPass: true,
                controller: passwordController),
            const SizedBox(height: 25),
            DefaultButton(
              _isLoading ? 'Entrando...' : 'Entrar',
              () async {
                String email = emailController.text;
                String password = passwordController.text;
                if (!_validateFields(email, password)) {
                  return;
                }
                setState(() {
                  _isLoading = true;
                });

                User user = await _signIn(email, password);

                setState(() {
                  _isLoading = false;
                });

                if (user.userId > 0) {
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(user)),
                  );
                } else {
                  _setErrorMsg('Email ou senha inválidos!');
                }
              },
              width: 400,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            if (_errorMessage.isNotEmpty)
              Text(_errorMessage, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 30),
            const Text(
              "Não tem uma conta ainda?",
              style: TextStyle(fontSize: 18),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text(
                "Cadastre-se",
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
