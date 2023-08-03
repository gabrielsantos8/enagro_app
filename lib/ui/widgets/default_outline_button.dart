import 'package:flutter/material.dart';

class DefaultOutlineButton extends StatelessWidget {
  final String titulo;
  final TextStyle? style;
  final VoidCallback clique;
  final double? width;
  final double? height;
  const DefaultOutlineButton(this.titulo, this.clique,
      {this.style, this.width, this.height, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      height: height ?? 55,
      child: OutlinedButton(
        onPressed: clique,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(width: 2, color: Color.fromARGB(255, 0, 150, 50)),
        ),
        child: Text(titulo, style: style),
      ),
    );
  }
}
