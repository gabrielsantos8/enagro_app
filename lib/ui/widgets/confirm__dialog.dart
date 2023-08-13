import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {

  final String title;
  final String content;
  final VoidCallback yesFunction;
  final VoidCallback noFunction;


  const ConfirmDialog({super.key, this.title = "Confirmação", this.content = "Tem certeza?", required this.yesFunction, required this.noFunction});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: noFunction,
          child: const Text(
            "Não",
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 1, 206, 70)
            ),
          ),
        ),
        TextButton(
          onPressed: yesFunction,
          child: const Text(
            "Sim",
            style: TextStyle(
              fontSize: 18,
              color: Color.fromARGB(255, 1, 206, 70)
            ),
          ),
        ),
      ],
    );
  }
}
