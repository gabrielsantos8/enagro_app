import 'package:enagro_app/ui/widgets/city_uf_combo.dart';
import 'package:flutter/material.dart';

class UserAddressEditPage extends StatefulWidget {
  const UserAddressEditPage({super.key});

  @override
  State<UserAddressEditPage> createState() => _UserAddressEditPageState();
}

class _UserAddressEditPageState extends State<UserAddressEditPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(children: [
        SizedBox(height: 50,),
        Center(child: CityUfCombo())
      ],),
    );
  }
}