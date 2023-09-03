import 'package:enagro_app/datasource/remote/animal_type_remote.dart';
import 'package:flutter/material.dart';

class AnimalTypeCombo extends StatefulWidget {
  final Function(int) onSelectionChanged;
  final int? selAnimalType;
  final String fieldlabel;

  const AnimalTypeCombo(
      {Key? key,
      required this.onSelectionChanged,
      required this.fieldlabel,
      this.selAnimalType})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimalTypeComboState createState() => _AnimalTypeComboState();
}

class _AnimalTypeComboState extends State<AnimalTypeCombo> {
  Map<int, String> animalTypes = {};
  bool animalTypeChange = false;
  late int selectedAnimalTypeId;

  @override
  void initState() {
    super.initState();
    selectedAnimalTypeId = widget.selAnimalType ?? 1;
    loadAnimalType();
  }

  Future<void> loadAnimalType() async {
    final animalTypeRemote = AnimalTypeRemote();
    final animalTypeList = await animalTypeRemote.getAnimalTypes();

    final map = animalTypeList.fold<Map<int, String>>({}, (previousMap, animalType) {
      final id = animalType['id'] as int;
      final description = animalType['description'] as String;
      previousMap[id] = description;
      return previousMap;
    });

    setState(() {
      animalTypes = map;
    });
    widget.onSelectionChanged(selectedAnimalTypeId);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.fieldlabel, style: const TextStyle(fontSize: 18)),
        DropdownButton<int>(
          value: selectedAnimalTypeId,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          dropdownColor: Theme.of(context).primaryColorLight,
          hint: const Text('Selecione o tipo de animal'),
          items: animalTypes.entries.map((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              selectedAnimalTypeId = newValue!;
              animalTypeChange = true;
              widget.onSelectionChanged(selectedAnimalTypeId);
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
