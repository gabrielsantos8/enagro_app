import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivationCard extends StatelessWidget {
  final int activationId;
  final DateTime scheduledDate;
  final DateTime activationDate;
  final String status;
  final String type;
  const ActivationCard(
      {super.key,
      required this.activationId,
      required this.scheduledDate,
      required this.activationDate,
      required this.status,
      required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.98,
      height: MediaQuery.of(context).size.height * 0.18,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(10, 10),
            blurRadius: 10,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '#$activationId - Solicitado em  ${DateFormat('dd/MM/yyyy').format(activationDate)}',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Data desejada: ${DateFormat('dd/MM/yyyy').format(scheduledDate)}. $status.',
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: (status == 'Pendente'
                  ? Colors.yellow
                  : (status == 'Aceito' ? Colors.green : Colors.red)),
              height: 4,
              width: MediaQuery.of(context).size.width * 0.98,
            )
          ],
        ),
      ),
    );
  }
}
