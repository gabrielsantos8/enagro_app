import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  final VoidCallback yesFunction;
  final Color color;
  final String buttonText;
  final String confirmText;
  const ConfirmButton(
      {super.key,
      required this.yesFunction,
      required this.color,
      required this.buttonText,
      this.confirmText = "Tem certeza?"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 28, vertical: 18)),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialog(
                  content: confirmText,
                  noFunction: () {
                    Navigator.pop(context);
                  },
                  yesFunction: () {
                    Navigator.pop(context);
                    yesFunction();
                  },
                );
              });
        },
        child:  Text(buttonText));
  }
}
