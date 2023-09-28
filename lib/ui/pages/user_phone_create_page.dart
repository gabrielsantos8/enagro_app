import 'package:enagro_app/datasource/remote/user_phone_remote.dart';
import 'package:enagro_app/models/user_phone.dart';
import 'package:enagro_app/ui/widgets/default_textfield.dart';
import 'package:flutter/material.dart';

class UserPhoneCreatePage extends StatefulWidget {
  final int userId;
  final Function() onPhoneEdited;
  const UserPhoneCreatePage(this.userId, {super.key, required this.onPhoneEdited});

  @override
  State<UserPhoneCreatePage> createState() => _UserPhoneCreatePageState();
}

class _UserPhoneCreatePageState extends State<UserPhoneCreatePage> {
  final _dddController = TextEditingController();
  final _numberController = TextEditingController();
  bool _isSaving = false;

  Future<void> _editPhone() async {
    setState(() {
      _isSaving = true;
    });

    UserPhone phone = UserPhone(
        userPhoneId: 0,
        ddd: int.parse(_dddController.text),
        number: _numberController.text,
        userId: widget.userId);

    bool isSuccess = await UserPhoneRemote().savePhone(phone);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess) {
      widget.onPhoneEdited();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao adicionar o telefone.'),
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
                'Adicionar Telefone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Flexible(
                    child: DefaultTextField(
                        withDecimals: false,
                        controller: _dddController,
                        type: const TextInputType.numberWithOptions(
                            decimal: false),
                        maxSize: 2,
                        fieldlabel: 'DDD'),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                      child: DefaultTextField(
                          withDecimals: false,
                          maxSize: 9,
                          type: const TextInputType.numberWithOptions(
                              decimal: false),
                          controller: _numberController,
                          fieldlabel: 'Número')),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _editPhone,
                child: _isSaving
                    ? const Text('Salvando...')
                    : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
