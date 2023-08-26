import 'package:enagro_app/models/user.dart';
import 'package:flutter/material.dart';

class VeterinarianPage extends StatefulWidget {
  final User? user;
  const VeterinarianPage(this.user, {super.key});

  @override
  State<VeterinarianPage> createState() => _VeterinarianPageState();
}

class _VeterinarianPageState extends State<VeterinarianPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
