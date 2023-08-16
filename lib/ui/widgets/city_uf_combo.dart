import 'package:enagro_app/datasource/remote/city_remote.dart';
import 'package:flutter/material.dart';

class CityUfCombo extends StatefulWidget {
  const CityUfCombo({Key? key}) : super(key: key);

  @override
  _CityUfComboState createState() => _CityUfComboState();
}

class _CityUfComboState extends State<CityUfCombo> {
  List<String> ufs = [];
  Map<int, String> citiesMap = {};
  String selectedUf = '';
  int selectedCityId = 0;

  @override
  void initState() {
    super.initState();
    loadUfs();
  }

  Future<void> loadUfs() async {
    final cityRemote = CityRemote();
    final ufList = await cityRemote.getUfs();
    setState(() {
      ufs = List<String>.from(ufList);
    });
  }

  Future<void> loadCities(String uf) async {
    final cityRemote = CityRemote();
    final citiesList = await cityRemote.getCities(uf);
    final map = Map<int, String>.from(citiesList.map((city) => MapEntry<int, String>(city['id'], city['description'])) as Map);
    setState(() {
      citiesMap = map;
      selectedCityId = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: selectedUf,
          hint:const Text('Selecione a UF'),
          items: ufs.map((String uf) {
            return DropdownMenuItem<String>(
              value: uf,
              child: Text(uf),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              selectedUf = newValue!;
              loadCities(selectedUf);
            });
          },
        ),
        DropdownButton<int>(
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
            });
          },
        ),
      ],
    );
  }
}
