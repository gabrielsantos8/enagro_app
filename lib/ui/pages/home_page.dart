import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/widgets/default_drawer_item.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.zero,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 0, 150, 50),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Image.asset('images/cow_drawer.png',
                        width: 130), // Sua imagem aqui
                    const SizedBox(height: 10),
                    Text(
                      widget.user!.name,
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    DefaultOutlineButton(
                      'Ver perfil',
                      () {},
                      style: const TextStyle(
                          color: Color.fromARGB(255, 0, 150, 50)),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 7),
            DefaultDrawerItem(
                Icons.local_hospital_outlined, 'Plano de saúde animal', () {}),
            DefaultDrawerItem(Icons.shield_outlined, 'Seguro animal', () {}),
            DefaultDrawerItem(
                Icons.assignment_late_outlined, 'Serviços Avulsos', () {}),
            DefaultDrawerItem(Icons.business, 'Parceiros', () {}),
            const Spacer(),
            DefaultDrawerItem(Icons.info_outline, 'Sobre a Enagro', () {},
                div: false),
          ],
        ),
      ),
      body: ListView(),
    );
  }
}
