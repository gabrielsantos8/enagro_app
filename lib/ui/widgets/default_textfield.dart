import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatelessWidget {
  final String fieldlabel;
  final TextInputType type;
  final int maxSize;
  final bool isPass;
  final bool withDecimals;
  final TextEditingController controller;
  final int maxLines;

  const DefaultTextField(
      {super.key,
      this.fieldlabel = "",
      this.type = TextInputType.text,
      this.isPass = false,
      required this.controller,
      this.maxLines = 1,
      this.withDecimals = true,
      this.maxSize = 1000});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      obscureText: isPass,
      maxLength: maxSize,
      maxLines: maxLines,
      inputFormatters:
          (!withDecimals) ? [FilteringTextInputFormatter.digitsOnly] : [],
      controller: controller,
      enableSuggestions: !isPass,
      autocorrect: !isPass,
      decoration: InputDecoration(
        labelText: fieldlabel,
        labelStyle: const TextStyle(fontSize: 22),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color color = states.contains(MaterialState.error)
                ? Theme.of(context).colorScheme.error
                : const Color.fromARGB(255, 0, 102, 34);
            return TextStyle(color: color, fontSize: 24);
          },
        ),
      ),
    );
  }
}
