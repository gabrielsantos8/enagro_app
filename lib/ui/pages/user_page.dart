import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage(this.user, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
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
                  color: Colors.black
                      .withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(
                      0, 4),
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
                        onTap: () {
                          
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          radius: 15,
                          child: Icon(Icons.edit, size: 20, color: Theme.of(context).primaryColorLight),
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
          const Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              'Seus endereços:',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.user!.addresses.length,
              itemBuilder: (context, index) {
                var address = widget.user!.addresses[index];
                return DefaultHomeItem(
                  title: '${address.city.description} - ${address.city.uf}',
                  description: address.complement,
                  div: false,
                  iconData: Icons.home_outlined,
                  rightIcon: Icons.edit_location_alt_outlined,
                  onTap: () {},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
