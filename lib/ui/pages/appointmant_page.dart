import 'package:enagro_app/datasource/remote/appointment_remote.dart';
import 'package:enagro_app/models/activation.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/appointment.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentPage extends StatefulWidget {
  final Activation activation;
  final bool isUser;
  const AppointmentPage(this.activation, this.isUser, {super.key});

  @override
  State<AppointmentPage> createState() => _VeterinarianAppointmentPageState();
}

class _VeterinarianAppointmentPageState extends State<AppointmentPage> {
  Future<Appointment> fetchAppointmentData() async {
    Future<Appointment> appointment =
        AppointmentRemote().getByActivation(widget.activation.activationId);
    return appointment;
  }

  void _showAddressDetailsModal(BuildContext context, UserAddress userAddress) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detalhes do Endereço"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Cidade: ${userAddress.city.description}."),
              Text("UF: ${userAddress.city.uf}."),
              Text("IBGE: ${userAddress.city.ibge}."),
              Text("Complemento: ${userAddress.complement}"),
            ],
          ),
          actions: [
            DefaultOutlineButton(
              'Fechar',
              () => Navigator.of(context).pop(),
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ],
        );
      },
    );
  }

  Widget buildCardAppointment(Appointment appointment) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Dados do atendimento',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Atendimento de:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(DateFormat('dd/MM/yyyy H:mm').format(appointment.date)),
            const SizedBox(height: 8),
            const Text('Até:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(DateFormat('dd/MM/yyyy H:mm').format(appointment.endDate)),
            const SizedBox(height: 8),
            const Text('Tempo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
                '${appointment.endDate.difference(appointment.date).inHours.toString().padLeft(2, '0')}:${(appointment.endDate.difference(appointment.date).inMinutes % 60).toString().padLeft(2, '0')}'),
            const SizedBox(height: 8),
            const Text(
              'Situação:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(appointment.status),
            const SizedBox(height: 8),
            const Text(
              'Valor:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              'R\$${appointment.value.toStringAsFixed(2)}',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardServices() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Center(
            child: Text(
              'Serviços',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: ListView.builder(
                itemCount: widget.activation.services.length,
                itemBuilder: (context, index) {
                  Service service = widget.activation.services[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Descrição:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(service.description),
                      const SizedBox(height: 8),
                      const Text('Valor:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        'R\$${service.value.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Divider()
                    ],
                  );
                },
              ))
        ]),
      ),
    );
  }

  Widget buildCardAnimals() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          const Center(
            child: Text(
              'Animais',
              style: TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.19,
              child: ListView.builder(
                itemCount: widget.activation.animals.length,
                itemBuilder: (context, index) {
                  Animal animal = widget.activation.animals[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Nome:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(animal.name),
                      const SizedBox(height: 8),
                      const Text('Tipo:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(animal.animalSubType.description),
                      const SizedBox(height: 8),
                      const Text('Endereço:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      InkWell(
                        onTap: () {
                          _showAddressDetailsModal(context, animal.userAddress);
                        },
                        child: Row(
                          children: [
                            Text(
                              '${animal.userAddress.city.description} - ${animal.userAddress.city.uf}',
                            ),
                            Icon(
                              Icons.not_listed_location_outlined,
                              size: 22,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                      const Divider()
                    ],
                  );
                },
              ))
        ]),
      ),
    );
  }

  Widget buildCardUser() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Dados do cliente',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Nome:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(widget.activation.user),
            const SizedBox(height: 8),
            const Text('Telefone:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(
                '(${widget.activation.phones[0].ddd}) ${widget.activation.phones[0].number}'),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Cidades',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(2.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 186, 186, 186),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ]),
              child: ListView.builder(
                itemCount: widget.activation.addresses.length,
                itemBuilder: (context, index) {
                  UserAddress address = widget.activation.addresses[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                          'Cidade${widget.activation.addresses.length <= 1 ? '' : ' $index'}:',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${address.city.description} - ${address.city.uf}'),
                      const SizedBox(height: 8),
                      const Divider()
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          FutureBuilder(
            future: fetchAppointmentData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColorLight,
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                Appointment? appointment = snapshot.data;
                if (appointment != null) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: ListView(
                      children: [
                        buildCardAppointment(appointment),
                        buildCardUser(),
                        buildCardServices(),
                        buildCardAnimals()
                      ],
                    ),
                  );
                } else {
                  return const Text('Nenhum dado encontrado.');
                }
              }
            },
          )
        ],
      ),
    );
  }
}
