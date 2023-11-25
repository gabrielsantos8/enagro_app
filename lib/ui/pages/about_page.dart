import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'images/logo_enagro.png',
              height: 70,
            ),
            const SizedBox(height: 30),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                'Bem-vindo ao ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Enagro',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              const Text(
                '!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
            const SizedBox(height: 20),
            const Text(
              'Seu aplicativo de planos de saúde para animais.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                decoration: TextDecoration.underline
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'O Enagro é uma inovação no universo dos cuidados com animais, proporcionando uma solução abrangente e especializada em planos de saúde para uma ampla gama de animais, desde animais de estimação como cães e gatos até animais de corte. Nosso aplicativo visa oferecer tranquilidade e assistência veterinária de qualidade para todos os membros peludos da sua família, independentemente do tamanho ou espécie.',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
