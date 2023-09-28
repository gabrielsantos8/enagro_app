import 'package:enagro_app/datasource/remote/veterinarian_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/pages/veterinarian_page.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:enagro_app/ui/widgets/uf_combo.dart';
import 'package:flutter/material.dart';

class VeterinarianCreatePage extends StatefulWidget {
  final User? user;
  const VeterinarianCreatePage(this.user, {super.key});

  @override
  State<VeterinarianCreatePage> createState() => _VeterinarianCreatePageState();
}

class _VeterinarianCreatePageState extends State<VeterinarianCreatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idCrmvController = TextEditingController();
  final TextEditingController _crmvController = TextEditingController();
  late String selUf = '';

  bool _isSaving = false;

  Future<void> _saveVeterinarian() async {
    if (_nameController.text == '' ||
        _crmvController.text == '' ||
        _idCrmvController.text == '') {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Preencha todos os dados corretamente!'),
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
      return;
    }

    setState(() {
      _isSaving = true;
    });
    Object map = {
      "uf": selUf,
      "name": _nameController.text,
      "crmv": _crmvController.text,
      "idcrmv": _idCrmvController.text,
      "user_id": widget.user!.userId
    };

    Veterinarian veterinarian = await VeterinarianRemote().saveVeterinarian(map);

    setState(() {
      _isSaving = false;
    });

    if (veterinarian.userId > 0) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VeterinarianPage(widget.user, veterinarian)),
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Cadastro veterinário não encontrado! Por favor, confira os dados fornecidos e tente novamente.'),
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
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Cadastre-se',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 50,
                ),
                DefaultTextField(
                  controller: _nameController,
                  fieldlabel: 'Confirme seu nome',
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                  controller: _idCrmvController,
                  fieldlabel: 'Código registro CRMV',
                  type: TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultTextField(
                    controller: _crmvController,
                    fieldlabel: 'CRMV',
                    type: TextInputType.number),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: UfCombo(
                  fieldlabel: 'UF Registro',
                  onSelectionChanged: (uf) {
                    setState(() {
                      selUf = uf;
                    });
                  },
                )),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveVeterinarian,
                  child: _isSaving
                      ? const Text('Salvando...')
                      : const Text('Salvar'),
                ),
              ])
        ],
      ),
    )));
  }
}
