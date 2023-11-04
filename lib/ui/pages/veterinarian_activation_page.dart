import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:card_actions/card_action_button.dart';
import 'package:card_actions/card_actions.dart';
import 'package:date_field/date_field.dart';
import 'package:enagro_app/datasource/remote/activation_remote.dart';
import 'package:enagro_app/datasource/remote/appointment_remote.dart';
import 'package:enagro_app/models/activation.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/models/user_phone.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/pages/vet_animal_details.dart';
import 'package:enagro_app/ui/pages/appointmant_page.dart';
import 'package:enagro_app/ui/widgets/activation_card.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VeterinarianActivationPage extends StatefulWidget {
  final Veterinarian? veterinarian;
  const VeterinarianActivationPage(this.veterinarian, {super.key});

  @override
  State<VeterinarianActivationPage> createState() =>
      _VeterinarianActivationPageState();
}

class _VeterinarianActivationPageState
    extends State<VeterinarianActivationPage> {
  late DateTime endDate = DateTime.now();
  late bool _isSaving = false;

  Future<void> _acceptActivation(Activation activation) async {
    setState(() {
      _isSaving = true;
    });
    Object prms = {
      "activation_id": activation.activationId,
      "initial_date": activation.scheduledDate.toString(),
      "end_date": endDate.toString(),
      "status_id": 2,
      "value": activation.value
    };
    dynamic ret = await AppointmentRemote().createAppointment(prms);
    String msg = ret['message'];
    setState(() {
      _isSaving = false;
    });

    if (ret['success']) {
      _buildActivationList(widget.veterinarian!.userVeterinarianId);
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: Text(msg),
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

  Future<void> _recuseActivation(Activation activation) async {
    Object prms = {"id": activation.activationId, "activation_status_id": 2};

    bool success = await ActivationRemote().editActivation(prms);

    if (success) {
      setState(() {
        _buildActivationList(widget.veterinarian!.userVeterinarianId);
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Atenção'),
            content: const Text('Houve um erro ao recusar acionamento.'),
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

  void _showServicesModal(List<Service> services) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Center(
            child: Column(children: [
          const SizedBox(height: 20),
          const Text(
            'Serviços:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: AutoAnimatedList<Service>(
                items: services,
                itemBuilder: (context, record, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      leading: const Icon(Icons.medical_services_outlined),
                      title: Text(
                        '${record.description.split("(")[0]} - R\$${record.value.toStringAsFixed(2)}.',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          DefaultOutlineButton(
            'Fechar',
            () {
              Navigator.pop(context);
            },
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const Spacer(),
        ]));
      },
    );
  }

  void _showAnimalsModal(List<Animal> animals) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Center(
            child: Column(children: [
          const SizedBox(height: 20),
          const Text(
            'Animais:',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: AutoAnimatedList<Animal>(
                items: animals,
                itemBuilder: (context, record, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    VetAnimalDetails(record)));
                      },
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      leading: const Icon(Icons.pets_outlined),
                      title: Text(
                        record.name,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Spacer(),
          DefaultOutlineButton(
            'Fechar',
            () {
              Navigator.pop(context);
            },
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const Spacer(),
        ]));
      },
    );
  }

  void _showUserModal(
      String userName, List<UserAddress> address, UserPhone phone) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Usuário: $userName.",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text(
                  "Telefone: (${phone.ddd.toString()}) ${phone.number.toString()}.",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AutoAnimatedList<UserAddress>(
                    items: address,
                    itemBuilder: (context, record, index, animation) {
                      return SizeFadeTransition(
                        animation: animation,
                        child: ListTile(
                          iconColor: const Color.fromARGB(255, 0, 0, 0),
                          leading: const Icon(Icons.location_city),
                          title: Text(
                            '${record.city.description}-${record.city.uf}',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const Spacer(),
              DefaultOutlineButton(
                'Fechar',
                () {
                  Navigator.pop(context);
                },
                style: TextStyle(color: Theme.of(context).primaryColor),
              )
            ],
          ),
        );
      },
    );
  }

  void _showAppointmentModal(DateTime scheduledDate, Activation activation) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("Aceitar acionamento.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              DateTimeFormField(
                decoration: const InputDecoration(
                  hintStyle: TextStyle(color: Colors.black45),
                  errorStyle: TextStyle(color: Colors.redAccent),
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.event_note),
                  labelText: 'Data estimada do término',
                ),
                dateFormat: DateFormat('dd/MM/yyyy H:mm'),
                mode: DateTimeFieldPickerMode.dateAndTime,
                onDateSelected: (DateTime value) {
                  setState(() {
                    endDate = value;
                  });
                },
                use24hFormat: true,
                firstDate: DateTime.now(),
                initialValue: endDate,
                validator: (value) {
                  if (value == null) {
                    return 'Campo Obrigatório!';
                  }
                  return null;
                },
              ),
              const Spacer(),
              DefaultOutlineButton(
                (_isSaving ? 'Aceitando...' : 'Aceitar'),
                () {
                  if (!scheduledDate.isBefore(endDate)) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Atenção'),
                          content: const Text(
                              'Data de término selecionada menor que a data inicial.'),
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
                  _acceptActivation(activation);
                },
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              const SizedBox(height: 10),
              DefaultOutlineButton(
                'Fechar',
                () {
                  Navigator.pop(context);
                },
                style: TextStyle(color: Theme.of(context).primaryColor),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: _buildActivationList(widget.veterinarian!.userVeterinarianId));
  }

  Widget _buildActivationList(int veterinarianId) {
    return FutureBuilder(
      future: ActivationRemote().getByVeterinarian(veterinarianId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
                color: Theme.of(context).primaryColorLight,
              ),
            );
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Activation activation = snapshot.data![index];
                        return Container(
                            padding: const EdgeInsets.all(20),
                            // margin: const EdgeInsets.only(bottom: 10, top: 10),
                            child: CardActions(
                              showToolTip: true,
                              backgroundColor: Theme.of(context).primaryColor,
                              axisDirection: CardActionAxis.bottom,
                              borderRadius: 15,
                              width: MediaQuery.of(context).size.width * 0.98,
                              height: MediaQuery.of(context).size.height * 0.25,
                              actions: <CardActionButton>[
                                CardActionButton(
                                  icon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: 'Usuário',
                                  onPress: () => _showUserModal(
                                      activation.user,
                                      activation.addresses,
                                      activation.phones[0]),
                                ),
                                CardActionButton(
                                  icon: const Icon(
                                    Icons.pets,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: 'Animais',
                                  onPress: () =>
                                      _showAnimalsModal(activation.animals),
                                ),
                                CardActionButton(
                                  icon: const Icon(
                                    Icons.build,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: 'Serviços',
                                  onPress: () =>
                                      _showServicesModal(activation.services),
                                ),
                                if (activation.statusId == 3)
                                  CardActionButton(
                                      icon: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      label: 'Aceitar',
                                      onPress: () {
                                        _showAppointmentModal(
                                            activation.scheduledDate,
                                            activation);
                                      }),
                                if (activation.statusId == 3)
                                  CardActionButton(
                                      icon: const Icon(
                                        Icons.not_interested,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      label: 'Recusar',
                                      onPress: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return ConfirmDialog(
                                                content:
                                                    "Tem certeza que deseja recusar esse acionamento?",
                                                noFunction: () {
                                                  Navigator.pop(context);
                                                },
                                                yesFunction: () {
                                                  _recuseActivation(activation);
                                                  Navigator.pop(context);
                                                },
                                              );
                                            });
                                      }),
                                if (activation.statusId == 1)
                                  CardActionButton(
                                      icon: const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 20
                                      ),
                                      label: 'Acompanhar',
                                      onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentPage(activation, false)))),
                              ],
                              child: ActivationCard(
                                  activationDate: activation.activationDate,
                                  activationId: activation.activationId,
                                  scheduledDate: activation.scheduledDate,
                                  status: activation.status,
                                  type: activation.type,
                                  value: activation.value),
                            ));
                      },
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar acionamentos!'),
              );
            } else {
              return const Center(
                child: Text('Nenhum acionamento encontrado'),
              );
            }
        }
      },
    );
  }
}
