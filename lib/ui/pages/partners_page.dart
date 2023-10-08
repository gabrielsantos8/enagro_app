import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/veterinary_explanation_page.dart';
import 'package:enagro_app/ui/widgets/default_drawer_item.dart';
import 'package:flutter/material.dart';

class PartnersPage extends StatefulWidget {
  final User? user;
  const PartnersPage(this.user, {super.key});

  @override
  State<PartnersPage> createState() => _PartnersPageState();
}

class _PartnersPageState extends State<PartnersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          DefaultDrawerItem(Icons.man_4, 'Eu, veterinário', () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VeterinaryExplanation(widget.user)));
          })
        ],
      ),
    );
  }
}
