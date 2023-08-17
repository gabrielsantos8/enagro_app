import 'package:enagro_app/datasource/remote/user_address_remote.dart';
import 'package:enagro_app/ui/widgets/city_uf_combo.dart';
import 'package:flutter/material.dart';

class UserAddressCreatePage extends StatefulWidget {
  final Function() onAddressEdited;
  final int userId;
  const UserAddressCreatePage(
      {super.key, required this.onAddressEdited, required this.userId});

  @override
  State<UserAddressCreatePage> createState() => _UserAddressCreatePageState();
}

class _UserAddressCreatePageState extends State<UserAddressCreatePage> {
  final TextEditingController _complementController = TextEditingController();
  late String selUf = 'AC';
  late int selCityId = 13261;

  bool _isSaving = false;

  Future<void> _editAddress() async {
    setState(() {
      _isSaving = true;
    });

    Object map = {
      "city_id": selCityId,
      "complement": _complementController.text,
      "user_id": widget.userId
    };

    bool isSuccess = await UserAddressRemote().saveAddress(map);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess) {
      widget.onAddressEdited();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao salvar o endereço.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Cadastrar Endereço',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          Center(child: CityUfCombo(
            onSelectionChanged: (uf, city) {
              setState(() {
                selUf = uf;
                selCityId = city;
              });
            },
          )),
          Card(
              color: const Color.fromARGB(255, 243, 243, 243),
              child: TextField(
                maxLines: 10,
                controller: _complementController,
                decoration: const InputDecoration.collapsed(
                    hintText: "Complemento", border: InputBorder.none),
              )),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _editAddress,
            child: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
          ),
        ],
      ),
    )));
  }
}
