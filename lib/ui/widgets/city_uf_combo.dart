import 'package:enagro_app/datasource/remote/city_remote.dart';
import 'package:flutter/material.dart';

class CityUfCombo extends StatefulWidget {
  final Function(String, int) onSelectionChanged;
  final int? selCityId;
  final String? selUf;

  const CityUfCombo(
      {Key? key, required this.onSelectionChanged, this.selCityId, this.selUf})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CityUfComboState createState() => _CityUfComboState();
}

class _CityUfComboState extends State<CityUfCombo> {
  List<String> ufs = [];
  bool ufChange = false;
  Map<int, String> citiesMap = {};
  late String selectedUf;
  late int selectedCityId;

  @override
  void initState() {
    super.initState();
    selectedUf = widget.selUf ?? 'AC';
    selectedCityId = widget.selCityId ?? 0;
    loadUfs();
    loadCities(selectedUf);
  }

  Future<void> loadUfs() async {
    final cityRemote = CityRemote();
    final ufList = await cityRemote.getUfs();
    setState(() {
      ufs = ufList.map((obj) => obj['uf'] as String).toList();
    });
  }

  Future<void> loadCities(String uf) async {
    final cityRemote = CityRemote();
    final citiesList = await cityRemote.getCities(uf);

    final map = citiesList.fold<Map<int, String>>({}, (previousMap, city) {
      final id = city['id'] as int;
      final description = city['description'] as String;
      previousMap[id] = description;
      return previousMap;
    });

    setState(() {
      citiesMap = map;
      if (ufChange) {
        selectedCityId = map.keys.first;
      } else {
        selectedCityId = widget.selCityId ?? map.keys.first;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
              loadCities(selectedUf);
              widget.onSelectionChanged(selectedUf, selectedCityId);
            });
          },
        ),
        DropdownButton<int>(
          dropdownColor: Theme.of(context).primaryColorLight,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
          value: selectedCityId,
          hint: const Text('Selecione a Cidade'),
          items: citiesMap.entries.map((MapEntry<int, String> entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              selectedCityId = newValue!;
              widget.onSelectionChanged(selectedUf, selectedCityId);
            });
          },
        ),
      ],
    );
  }
}
