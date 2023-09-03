import 'package:date_field/date_field.dart';
import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/widgets/animal_type_combo.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:enagro_app/ui/widgets/user_address_combo.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AnimalEditPage extends StatefulWidget {
  final Function() onAnimalEdited;
  final User? user;
  final Animal? animal;
  const AnimalEditPage(
      {super.key,
      required this.onAnimalEdited,
      required this.user,
      required this.animal});

  @override
  State<AnimalEditPage> createState() => _AnimalEditPageState();
}

class _AnimalEditPageState extends State<AnimalEditPage> {
  late TextEditingController _descriptionController;
  late TextEditingController _nameController;
  late int selAnimalTypeId = 0;
  late int selUserAddressId = 0;
  late String birthDate = DateTime.now().toString();

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.animal!.description.toString());
    _nameController =
        TextEditingController(text: widget.animal!.name.toString());
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _editAnimal() async {
    setState(() {
      _isSaving = true;
    });

    Object prms = {
      "id": widget.animal!.animalId,
      "name": _nameController.text,
      "description": _descriptionController.text,
      "animal_type_id": selAnimalTypeId,
      "user_address_id": selUserAddressId,
      "birth_date": birthDate
    };

    bool isSuccess = await AnimalRemote().updateAnimal(prms);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess) {
      widget.onAnimalEdited();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao salvar o animal.'),
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
      child: ListView(
        children: [
          const Text(
            'Cadastrar Animal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 50,
          ),
          DefaultTextField(controller: _nameController, fieldlabel: 'Nome'),
          const SizedBox(
            height: 10,
          ),
          DefaultTextField(
              controller: _descriptionController,
              fieldlabel: 'Descrição',
              maxLines: 8),
          const SizedBox(
            height: 10,
          ),
          DateTimeFormField(
            initialValue: widget.animal!.birthDate,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Data Nascimento',
            ),
            dateFormat: DateFormat('dd/MM/yyyy'),
            mode: DateTimeFieldPickerMode.date,
            onDateSelected: (DateTime value) {
              birthDate = value.toString();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          AnimalTypeCombo(
              selAnimalType: widget.animal!.animalType.animalTypeId,
              onSelectionChanged: (anmTypeId) {
                selAnimalTypeId = anmTypeId;
              },
              fieldlabel: "Tipo"),
          UserAddressCombo(
              selUserAddress: widget.animal!.userAddress.userAddressId,
              userId: widget.user!.userId,
              onSelectionChanged: (usrAddress) {
                selUserAddressId = usrAddress;
              },
              fieldlabel: "Endereço"),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _editAnimal,
            child: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
          ),
        ],
      ),
    )));
  }
}
