import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:card_actions/card_action_button.dart';
import 'package:card_actions/card_actions.dart';
import 'package:enagro_app/datasource/remote/activation_remote.dart';
import 'package:enagro_app/models/activation.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/appointmant_page.dart';
import 'package:enagro_app/ui/widgets/activation_card.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class UserActivationPage extends StatefulWidget {
  final User? user;
  const UserActivationPage(this.user, {Key? key}) : super(key: key);

  @override
  State<UserActivationPage> createState() => _UserActivationPageState();
}

class _UserActivationPageState extends State<UserActivationPage> {
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
                        record.description,
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

  void _showVeterinarianModal(String veterinarianName) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Spacer(),
              Text("Veterinário: $veterinarianName.",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _buildActivationList(widget.user!.userId),
    );
  }

  Widget _buildActivationList(int userId) {
    return FutureBuilder(
      future: ActivationRemote().getByUser(userId),
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
                                  label: 'Veterinário',
                                  onPress: () => _showVeterinarianModal(
                                      activation.veterinarian),
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
                                if (activation.statusId == 1)
                                  CardActionButton(
                                      icon: const Icon(
                                        Icons.remove_red_eye,
                                        color: Colors.white,
                                        size: 20
                                      ),
                                      label: 'Acompanhar',
                                      onPress: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AppointmentPage(activation, true)))),
                              ],
                              child: ActivationCard(
                                activationDate: activation.activationDate,
                                activationId: activation.activationId,
                                scheduledDate: activation.scheduledDate,
                                status: activation.status,
                                type: activation.type,
                              ),
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
