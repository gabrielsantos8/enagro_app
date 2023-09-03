import 'package:enagro_app/ui/widgets/animal_type_combo.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class AnimalCreatePage extends StatefulWidget {
  final Function() onAnimalEdited;
  const AnimalCreatePage(this.onAnimalEdited, {super.key});

  @override
  State<AnimalCreatePage> createState() => _AnimalCreatePageState();
}

class _AnimalCreatePageState extends State<AnimalCreatePage> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  late int selAnimalTypeId = 0;

  bool _isSaving = false;

  Future<void> _createAnimal() async {
    setState(() {
      _isSaving = true;
    });

    bool isSuccess = true;

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
          DefaultTextField(controller: _nomeController, fieldlabel: 'Nome'),
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
              print(value);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          AnimalTypeCombo(
              onSelectionChanged: (anmTypeId) {
                selAnimalTypeId = anmTypeId;
              },
              fieldlabel: "Tipo"),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _createAnimal,
            child: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
          ),
        ],
      ),
    )));
  }
}
