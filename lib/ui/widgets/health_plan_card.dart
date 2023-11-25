import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class HealthPlanCard extends StatelessWidget {
  final String title;
  final String description;
  final int minimalAnimals;
  final int maximumAnimals;
  final double value;
  final List<Service> services;
  final VoidCallback onPressed;
  final List<Color> colors;

  const HealthPlanCard({
    Key? key,
    required this.title,
    required this.description,
    required this.minimalAnimals,
    required this.maximumAnimals,
    required this.value,
    required this.services,
    required this.onPressed,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              height: 2.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: colors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: AutoAnimatedList<Service>(
                items: services,
                itemBuilder: (context, record, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      iconColor: const Color.fromARGB(255, 55, 55, 55),
                      leading: const Icon(Icons.medical_services_outlined),
                      title: Text(
                        '${record.description} (${record.animalSubType.description})',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 55, 55, 55),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Text('Entre $minimalAnimals e $maximumAnimals animais'),
            const Spacer(),
            Text(
              'R\$ ${value.toStringAsFixed(2)} /mês',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'R\$ ${(value * 12).toStringAsFixed(2)} /ano',
              style: TextStyle(color: Theme.of(context).primaryColorDark),
            ),
            const Spacer(),
            DefaultOutlineButton(
              "Detalhes",
              onPressed,
              width: 200,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
