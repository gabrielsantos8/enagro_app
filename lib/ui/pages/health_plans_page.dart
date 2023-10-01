import 'package:enagro_app/models/user.dart';
import 'package:flutter/material.dart';

class HealthPlansPage extends StatefulWidget {
  final User? user;
  const HealthPlansPage(this.user, {super.key});

  @override
  State<HealthPlansPage> createState() => _HealthPlansPageState();
}

class _HealthPlansPageState extends State<HealthPlansPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
      ),
    );
  }
}