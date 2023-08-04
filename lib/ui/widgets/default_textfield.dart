import 'package:flutter/material.dart';

class DefaultTextField extends StatelessWidget {
  final String fieldlabel;
  final TextInputType type;
  final bool isPass;

  const DefaultTextField(
      {super.key, this.fieldlabel = "", this.type = TextInputType.text, this.isPass = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      obscureText: isPass,
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
