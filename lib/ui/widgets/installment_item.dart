import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InstallmentItem extends StatelessWidget {
  final int installmentNumber;
  final String status;
  final num value;
  final DateTime dueDate;
  final Color color;
  final VoidCallback onCLick;

  const InstallmentItem({
    super.key,
    required this.installmentNumber,
    required this.status,
    required this.value,
    required this.dueDate,
    required this.color,
    required this.onCLick,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDueDate = DateFormat('dd/MM/yyyy').format(dueDate);

    return Column(children: [
      ListTile(
        title: Text(
          'Parcela $installmentNumber. Status: $status.',
          style:
              const TextStyle(color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
            'R\$ ${value.toStringAsFixed(2)}. Vencimento: $formattedDueDate.',
            style: const TextStyle(color: Color.fromARGB(255, 0, 0, 0))),
        trailing: status.toLowerCase() == 'pendente'
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => color),
                ),
                onPressed: onCLick,
                child: const Icon(Icons.attach_money))
            : null,
      ),
      const Divider(
        color: Color.fromARGB(255, 127, 127, 127),
      )
    ]);
  }
}
