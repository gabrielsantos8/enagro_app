import 'package:enagro_app/datasource/remote/user_address_remote.dart';
import 'package:enagro_app/datasource/remote/user_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/user_addresses.dart';
import 'package:enagro_app/ui/pages/entry_page.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage(this.user, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.zero,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://s2-pegn.glbimg.com/u5v52RSMsc8hTq0f6bZPU-hMAz4=/0x0:1024x1024/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_ba41d7b1ff5f48b28d3c5f84f30a06af/internal_photos/bs/2023/e/g/90RpDKT02z2P2kTuIzkQ/libano.png',
                      ),
                    ),
                    Positioned(
                      top: 70,
                      left: 70,
                      child: InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          radius: 15,
                          child: Icon(Icons.edit,
                              size: 20,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.user!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.user!.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(2.7),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Endereço(s):',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: _buildAddressList(widget.user!.userId),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          DefaultOutlineButton(
            'Sair',
            () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      content: "Tem certeza que deseja sair?",
                      noFunction: () {
                        Navigator.pop(context);
                      },
                      yesFunction: () {
                        UserRemote.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const EntryPage()),
                          (Route<dynamic> route) => false
 
                        );
                      },
                    );
                  });
            },
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }
}

Widget _buildAddressList(int userId) {
  return FutureBuilder(
    future: UserAddressRemote().getByUser(userId),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        case ConnectionState.waiting:
        case ConnectionState.none:
          return Center(
              child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
            color: Theme.of(context).primaryColorLight,
          ));
        case ConnectionState.done:
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                UserAddress address = snapshot.data![index];
                return DefaultHomeItem(
                  title: '${address.city.description} - ${address.city.uf}',
                  description: address.complement,
                  div: false,
                  iconData: Icons.home_outlined,
                  rightIcon: Icons.edit_location_alt_outlined,
                  onTap: () {},
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar endereços!'));
          } else {
            return const Center(child: Text('Nenhum endereço cadastrado'));
          }
      }
    },
  );
}