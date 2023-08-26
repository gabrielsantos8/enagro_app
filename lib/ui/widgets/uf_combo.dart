import 'package:enagro_app/datasource/remote/city_remote.dart';
import 'package:flutter/material.dart';

class UfCombo extends StatefulWidget {
  final Function(String) onSelectionChanged;
  final String? selUf;
  final String fieldlabel;

  const UfCombo(
      {Key? key,
      required this.onSelectionChanged,
      required this.fieldlabel,
      this.selUf})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CityUfComboState createState() => _CityUfComboState();
}

class _CityUfComboState extends State<UfCombo> {
  List<String> ufs = [];
  bool ufChange = false;
  late String selectedUf;

  @override
  void initState() {
    super.initState();
    selectedUf = widget.selUf ?? 'AC';
    loadUfs();
  }

  Future<void> loadUfs() async {
    final cityRemote = CityRemote();
    final ufList = await cityRemote.getUfs();
    setState(() {
      ufs = ufList.map((obj) => obj['uf'] as String).toList();
    });
    widget.onSelectionChanged(selectedUf);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.fieldlabel, style: const TextStyle(fontSize: 18)),
        DropdownButton<String>(
          value: selectedUf,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          dropdownColor: Theme.of(context).primaryColorLight,
          hint: const Text('Selecione a UF'),
          items: ufs.map((String uf) {
            return DropdownMenuItem<String>(
              value: uf,
              child: Text(uf),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedUf = newValue!;
              ufChange = true;
              widget.onSelectionChanged(selectedUf);
            });
          },
          iconSize: 24,
          isExpanded: true,
          underline:
              Container(height: 1, color: Theme.of(context).primaryColorDark),
        ),
      ],
    );
  }
}
