import 'package:enagro_app/datasource/remote/veterinarian_service_remote.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:flutter/material.dart';

class VeterinarianServicePage extends StatefulWidget {
  final Veterinarian? veterinarian;
  const VeterinarianServicePage(this.veterinarian, {super.key});

  @override
  State<VeterinarianServicePage> createState() =>
      _VeterinarianServicePageState();
}

class _VeterinarianServicePageState extends State<VeterinarianServicePage> {
  void refreshData() {
    setState(() {
      fetchAtendeData();
    });
  }

  Future<List<Service>> fetchAtendeData() async {
    Future<List<Service>> services = VeterinarianServiceRemote()
        .getByVeterinarian(widget.veterinarian!.userVeterinarianId);
    return services;
  }

  Future<List<Service>> fetchNaoAtendeData() async {
    Future<List<Service>> services = VeterinarianServiceRemote()
        .getNotByVeterinarian(widget.veterinarian!.userVeterinarianId);
    return services;
  }

  Future<void> _removeService(int id) async {
    Object map = {"id": id};

    bool isSuccess = await VeterinarianServiceRemote().deleteService(map);

    if (isSuccess) {
      refreshData();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao remover o serviço.'),
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

  Future<void> _addService(int vetId, int serviceId) async {
    Object map = {"veterinarian_id": vetId, "service_id": serviceId};

    bool isSuccess = await VeterinarianServiceRemote().saveService(map);

    if (isSuccess) {
      refreshData();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao adicionar o serviço.'),
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

  Widget buildList(String titulo, List<Service> items) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 130, 130, 130),
                fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 300,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 246, 246, 246),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return DefaultHomeItem(
                      iconData: Icons.pets,
                      rightIcon: titulo == 'Atende'
                          ? Icons.remove_circle
                          : Icons.add_circle,
                      title: items[index].description.split('(')[0],
                      description:
                          'Para: ${items[index].animalSubType.description} - R\$${items[index].value.toStringAsFixed(2)}',
                      onTap: () {
                        titulo == 'Atende'
                            ? showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ConfirmDialog(
                                    content: "Tem certeza que deseja remover?",
                                    noFunction: () {
                                      Navigator.pop(context);
                                    },
                                    yesFunction: () {
                                      Navigator.pop(context);
                                      _removeService(items[index].vetServiceId);
                                    },
                                  );
                                })
                            : _addService(
                                widget.veterinarian!.userVeterinarianId,
                                items[index].serviceId);
                      });
                },
              ),
            ),
          ),
        ],
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
            future: fetchAtendeData(),
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
                final serviceData = snapshot.data;
                if (serviceData != null) {
                  return buildList('Atende', serviceData);
                } else {
                  return const Text('Nenhum dado encontrado.');
                }
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          FutureBuilder(
            future: fetchNaoAtendeData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColorLight,
                  ),
                );
              } else if (snapshot.hasError) {
                fetchAtendeData();
                return Text('Error: ${snapshot.error}');
              } else {
                final atendeData = snapshot.data;
                if (atendeData != null) {
                  return buildList('Não atende', atendeData);
                } else {
                  return const Text('Nenhum dado encontrado.');
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
