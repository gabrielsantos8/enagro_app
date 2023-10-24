import 'package:card_actions/card_action_button.dart';
import 'package:card_actions/card_actions.dart';
import 'package:enagro_app/datasource/remote/activation_remote.dart';
import 'package:enagro_app/models/activation.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/widgets/activation_card.dart';
import 'package:flutter/material.dart';

class VeterinarianActivationPage extends StatefulWidget {
  final Veterinarian? veterinarian;
  const VeterinarianActivationPage(this.veterinarian, {super.key});

  @override
  State<VeterinarianActivationPage> createState() =>
      _VeterinarianActivationPageState();
}

class _VeterinarianActivationPageState
    extends State<VeterinarianActivationPage> {
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
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: 'Aceitar',
                                    onPress: () {}),
                                CardActionButton(
                                    icon: const Icon(
                                      Icons.not_interested,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: 'Recusar',
                                    onPress: () {}),
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
