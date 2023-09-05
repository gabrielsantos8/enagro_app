import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:flutter/material.dart';

class ConfirmCircularButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String confirmText;
  final VoidCallback onPressed;
  final Color color;

  const ConfirmCircularButton(
      {super.key, required this.icon, required this.label, required this.onPressed, required this.color, required this.confirmText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
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
                    onPressed();
                  },
                );
              });
      },
      child: Container(
        width: 80.0,
        height: 80.0,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 30.0,
              color: const Color.fromARGB(255, 0, 0, 0),
            ),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
