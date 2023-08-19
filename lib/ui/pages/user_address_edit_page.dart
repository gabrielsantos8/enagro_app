import 'package:enagro_app/datasource/remote/user_address_remote.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/widgets/city_uf_combo.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:flutter/material.dart';

class UserAddressEditPage extends StatefulWidget {
  final UserAddress userAddress;
  final Function() onAddressEdited;
  const UserAddressEditPage(this.userAddress,
      {super.key, required this.onAddressEdited});

  @override
  State<UserAddressEditPage> createState() => _UserAddressEditPageState();
}

class _UserAddressEditPageState extends State<UserAddressEditPage> {
  late TextEditingController _complementController;
  late String selUf = '';
  late int selCityId = 0;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _complementController =
        TextEditingController(text: widget.userAddress.complement.toString());
  }

  @override
  void dispose() {
    _complementController.dispose();
    super.dispose();
  }

  Future<void> _editAddress() async {
    setState(() {
      _isSaving = true;
    });
    selCityId = selCityId == 0 ? widget.userAddress.city.cityId : selCityId;
    Object map = {
      "id": widget.userAddress.userAddressId,
      "city_id": selCityId,
      "complement": _complementController.text,
      "user_id": widget.userAddress.userId
    };

    bool isSuccess = await UserAddressRemote().editAddress(map);

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
            content: const Text('Houve um erro ao editar o endereço.'),
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

  Future<void> _deleteAddress() async {
    Object map = {"id": widget.userAddress.userAddressId};

    bool isSuccess = await UserAddressRemote().deleteAddress(map);
    
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
            content: const Text('Houve um erro ao excluir o endereço.'),
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
            'Editar Endereço',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
              child: CityUfCombo(
            selUf: widget.userAddress.city.uf,
            selCityId: widget.userAddress.city.cityId,
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
          const SizedBox(height: 12),
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 204, 63, 53)),
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 18)),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ConfirmDialog(
                        content: "Tem certeza que deseja excluir?",
                        noFunction: () {
                          Navigator.pop(context);
                        },
                        yesFunction: () {
                          Navigator.pop(context);
                          _deleteAddress();
                        },
                      );
                    });
              },
              child: const Text('Excluir'))
        ],
      ),
    )));
  }
}
