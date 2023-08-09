import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DefaultDrawerItem extends StatelessWidget {
  IconData iconData;
  String title;
  VoidCallback onTap;
  bool div;

  DefaultDrawerItem(this.iconData, this.title, this.onTap, {this.div = true ,super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(iconData),
          title: Text(title),
          onTap: onTap,
        ),
        if(div)  
          const Divider(
              color: Color.fromARGB(255, 218, 218, 218),
              thickness: 1,
              indent: 5,
              endIndent: 5),
      ],
    );
  }
}