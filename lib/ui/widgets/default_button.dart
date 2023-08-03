import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String titulo;
  final TextStyle? style;
  final VoidCallback clique;
  final double? width;
  final double? height;

  const DefaultButton(
      this.titulo, this.clique,
      {this.width, this.height, this.style, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 350,
      height: height ?? 55,
      child: ElevatedButton(
        onPressed: clique,
        child: Text(
          titulo,
          style: style,
        ),
      ),
    );
  }
}
