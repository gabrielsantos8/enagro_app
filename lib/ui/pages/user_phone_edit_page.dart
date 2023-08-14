import 'package:flutter/material.dart';
import 'package:enagro_app/models/user_phone.dart';
import 'package:enagro_app/datasource/remote/user_phone_remote.dart';

class UserPhoneEditPage extends StatefulWidget {
  final UserPhone? userPhone;
  const UserPhoneEditPage({super.key, required this.userPhone});

  @override
  State<UserPhoneEditPage> createState() => _UserPhoneEditPageState();
}

class _UserPhoneEditPageState extends State<UserPhoneEditPage> {
  late TextEditingController _dddController;
  late TextEditingController _numberController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _dddController =
        TextEditingController(text: widget.userPhone?.ddd.toString());
    _numberController =
        TextEditingController(text: widget.userPhone?.number.toString());
  }

  @override
  void dispose() {
    _dddController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _editPhone() async {
    setState(() {
      _isSaving = true;
    });

    UserPhone editedPhone = UserPhone(
        userPhoneId: widget.userPhone!.userPhoneId,
        ddd: int.parse(_dddController.text),
        number: int.parse(_numberController.text),
        userId: widget.userPhone!.userId);

    bool isSuccess = await UserPhoneRemote().editPhone(editedPhone);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao editar o telefone.'),
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
                'Editar Telefone',
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
                    child: TextFormField(
                      controller: _dddController,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      decoration: const InputDecoration(
                        hintText: 'DDD',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0.1, horizontal: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: TextFormField(
                      controller: _numberController,
                      keyboardType: TextInputType.number,
                      maxLength: 9,
                      decoration: const InputDecoration(
                        hintText: 'Número',
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 0.1, horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : _editPhone,
                child: _isSaving ? const Text('Salvando...') : const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
