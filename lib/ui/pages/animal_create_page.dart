import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/ui/widgets/animal_subtype_type_combo.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:enagro_app/ui/widgets/user_address_combo.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AnimalCreatePage extends StatefulWidget {
  final Function() onAnimalEdited;
  final int userId;
  const AnimalCreatePage(this.onAnimalEdited, this.userId, {super.key});

  @override
  State<AnimalCreatePage> createState() => _AnimalCreatePageState();
}

class _AnimalCreatePageState extends State<AnimalCreatePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late int selAnimalTypeId = 0;
  late int selAnimalSubtypeId = 0;
  late int selUserAddressId = 0;
  late String birthDate = DateTime.now().toString();

  bool _isSaving = false;

  Future<void> _createAnimal() async {
    setState(() {
      _isSaving = true;
    });

    Object prms = {
      "name": _nameController.text,
      "description": _descriptionController.text,
      "animal_type_id": selAnimalTypeId,
      "animal_subtype_id": selAnimalSubtypeId,
      "user_address_id": selUserAddressId,
      "birth_date": birthDate,
      "weight": _weightController.text,
      "img_url": "https://static.thenounproject.com/png/1554486-200.png"
    };

    bool isSuccess = await AnimalRemote().saveAnimal(prms);

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
            height: 40,
          ),
          const Text('Tipo/Subtipo', style: TextStyle(fontSize: 18)),
          AnimalSubtypeTypeCombo(onSelectionChanged: (anmTypeId, anmSubTypeId) {
            selAnimalTypeId = anmTypeId;
            selAnimalSubtypeId = anmSubTypeId;
          }),
          const SizedBox(
            height: 20,
          ),
          DefaultTextField(controller: _nameController, fieldlabel: 'Nome'),
          const SizedBox(
            height: 20,
          ),
          DefaultTextField(
              controller: _descriptionController,
              fieldlabel: 'Descrição',
              maxLines: 8),
              const SizedBox(
            height: 20,
          ),
          DefaultTextField(
              type: TextInputType.number,
              controller: _weightController,
              fieldlabel: 'Peso'),
          const SizedBox(
            height: 20,
          ),
          DateTimeFormField(
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
            height: 20,
          ),
          UserAddressCombo(
              userId: widget.userId,
              onSelectionChanged: (usrAddress) {
                selUserAddressId = usrAddress;
              },
              fieldlabel: "Endereço"),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSaving ? null : _createAnimal,
            child: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
          ),
        ],
      ),
    )));
  }
}
