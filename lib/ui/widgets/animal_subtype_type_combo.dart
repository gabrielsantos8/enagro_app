import 'package:enagro_app/datasource/remote/animal_subtype_remote.dart';
import 'package:enagro_app/datasource/remote/animal_type_remote.dart';
import 'package:flutter/material.dart';

class AnimalSubtypeTypeCombo extends StatefulWidget {
  final Function(int, int) onSelectionChanged;
  final int? selAnimalSubtypeId;
  final int? selAnimalTypeId;

  const AnimalSubtypeTypeCombo(
      {Key? key,
      required this.onSelectionChanged,
      this.selAnimalSubtypeId,
      this.selAnimalTypeId})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AnimalSubtypeTypeComboState createState() => _AnimalSubtypeTypeComboState();
}

class _AnimalSubtypeTypeComboState extends State<AnimalSubtypeTypeCombo> {
  Map<int, String> animalTypesMap = {};
  Map<int, String> animalSubtypesMap = {};
  late int selectedAnimalSubtypeId;
  late int selectedAnimalTypeId;

  late bool isChange;

  @override
  void initState() {
    super.initState();
    isChange = false;
    selectedAnimalTypeId = widget.selAnimalTypeId ?? 1;
    selectedAnimalSubtypeId = widget.selAnimalSubtypeId ?? 0;
    loadAnimalTypes();
    loadAnimalSubtypes(selectedAnimalTypeId);
  }

  Future<void> loadAnimalTypes() async {
    final animalTypeRemote = AnimalTypeRemote();
    final animalTypeList = await animalTypeRemote.getAnimalTypes();
    animalTypesMap =
        animalTypeList.fold<Map<int, String>>({}, (previousMap, type) {
      final id = type['id'] as int;
      final description = type['description'] as String;
      previousMap[id] = description;
      return previousMap;
    });
    setState(() {
      animalTypesMap = animalTypesMap;
    });
  }

  Future<void> loadAnimalSubtypes(int id) async {
    final animalSubtypeRemote = AnimalSubTypeRemote();
    final animalSubtypeList =
        await animalSubtypeRemote.getAnimalSubtypesByAnimalType(id);

    final map =
        animalSubtypeList.fold<Map<int, String>>({}, (previousMap, subtype) {
      final id = subtype['id'] as int;
      final description = subtype['description'] as String;
      previousMap[id] = description;
      return previousMap;
    });

    if (!isChange) {
      setState(() {
        animalSubtypesMap = map;
        selectedAnimalSubtypeId = widget.selAnimalSubtypeId ?? map.keys.first;
        widget.onSelectionChanged(
            selectedAnimalTypeId, selectedAnimalSubtypeId);
      });
    } else {
      setState(() {
        animalSubtypesMap = map;
        selectedAnimalSubtypeId = map.keys.first;
        widget.onSelectionChanged(
            selectedAnimalTypeId, selectedAnimalSubtypeId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<int>(
          value: selectedAnimalTypeId,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          dropdownColor: Theme.of(context).primaryColorLight,
          hint: const Text('Selecione o tipo:'),
          items: animalTypesMap.entries.map((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              isChange = true;
              selectedAnimalTypeId = newValue!;
              loadAnimalSubtypes(selectedAnimalTypeId);
              widget.onSelectionChanged(
                  selectedAnimalTypeId, selectedAnimalSubtypeId);
            });
          },
        ),
        DropdownButton<int>(
          dropdownColor: Theme.of(context).primaryColorLight,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          value: selectedAnimalSubtypeId,
          hint: const Text('Selecione o subtipo'),
          items: animalSubtypesMap.entries.map((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              selectedAnimalSubtypeId = newValue!;
              widget.onSelectionChanged(
                  selectedAnimalTypeId, selectedAnimalSubtypeId);
            });
          },
        ),
      ],
    );
  }
}
