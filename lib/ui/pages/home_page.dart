import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/user_page.dart';
import 'package:enagro_app/ui/widgets/default_drawer_item.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
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
        appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
            leading: Builder(builder: ((context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColorDark,
                  size: 44,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }))),
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
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                            'https://s2-pegn.glbimg.com/u5v52RSMsc8hTq0f6bZPU-hMAz4=/0x0:1024x1024/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_ba41d7b1ff5f48b28d3c5f84f30a06af/internal_photos/bs/2023/e/g/90RpDKT02z2P2kTuIzkQ/libano.png'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.user!.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      DefaultOutlineButton(
                        'Ver perfil',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPage(widget.user)),
                          );
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 150, 50)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 7),
              DefaultDrawerItem(Icons.local_hospital_outlined,
                  'Plano de saúde animal', () {}),
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
        body: ListView(
          children: [
            Container(
              height: 65,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 25),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/logo_enagro_white.png',
                          width: 35,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Olá, ${widget.user?.name.split(' ')[0]}!',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            DefaultHomeItem(
                iconData: Icons.local_hospital_outlined,
                title: 'Plano de Saúde Animal',
                description: 'Nenhum plano contratado.',
                onTap: () {}),
            DefaultHomeItem(
                iconData: Icons.shield_outlined,
                title: 'Seguro Animal',
                description: 'Nenhum seguro contratado.',
                onTap: () {}),
            DefaultHomeItem(
                iconData: Icons.assignment_late_outlined,
                title: 'Serviços Avulsos',
                description: 'O melhor, aqui.',
                onTap: () {}),
          ],
        ));
  }
}
