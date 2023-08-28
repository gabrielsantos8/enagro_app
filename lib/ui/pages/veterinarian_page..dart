import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/pages/service_city_page.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:flutter/material.dart';

class VeterinarianPage extends StatefulWidget {
  final User? user;
  final Veterinarian? veterinarian;
  const VeterinarianPage(this.user, this.veterinarian, {super.key});

  @override
  State<VeterinarianPage> createState() => _VeterinarianPageState();
}

class _VeterinarianPageState extends State<VeterinarianPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nome: ${widget.veterinarian?.nome ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Nome Social: ${widget.veterinarian?.nomeSocial ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'ID CRMV: ${widget.veterinarian?.idPfInscricao ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'CRMV: ${widget.veterinarian?.pfInscricao ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'UF: ${widget.veterinarian?.pfUf ?? ''}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          DefaultHomeItem(
              iconData: Icons.warning_outlined,
              title: 'Acionamentos',
              description: 'Acionamentos em busca de atendimento.',
              onTap: () {}),
          DefaultHomeItem(
              iconData: Icons.local_hospital_outlined,
              title: 'Meus Planos de Saúde Animal',
              description: 'Meus Planos de saúde animal disponíveis.',
              onTap: () {}),
          DefaultHomeItem(
              iconData: Icons.assignment_late_outlined,
              title: 'Meus Serviços Avulsos',
              description: 'Meu serviços avulsos disponíveis.',
              onTap: () {}),
          DefaultHomeItem(
              iconData: Icons.location_city_outlined,
              title: 'Meus Municípios de Atendimento',
              description: 'Meus municípios de atendimento, pela UF do CRMV.',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ServiceCityPage(widget.veterinarian)));
              }),
        ],
      ),
    );
  }
}
