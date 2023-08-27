import 'package:enagro_app/datasource/remote/service_city_remote.dart';
import 'package:enagro_app/models/service_city.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:flutter/material.dart';

class ServiceCityPage extends StatefulWidget {
  final Veterinarian? veterinarian;
  const ServiceCityPage(this.veterinarian, {Key? key}) : super(key: key);

  @override
  State<ServiceCityPage> createState() => _ServiceCityPageState();
}

class _ServiceCityPageState extends State<ServiceCityPage> {
  void refreshData() {
    setState(() {
      fetchAtendeData();
      fetchNaoAtendeData();
    });
  }

  Future<List<ServiceCity>> fetchAtendeData() async {
    Future<List<ServiceCity>> serviceCities =
        ServiceCityRemote().getByVeterinarian(widget.veterinarian!.userId);
    return serviceCities;
  }

  Future<List<ServiceCity>> fetchNaoAtendeData() async {
    Future<List<ServiceCity>> serviceCities = ServiceCityRemote()
        .getByUf(widget.veterinarian!.userVeterinarianId, widget.veterinarian!.pfUf);
    return serviceCities;
  }

  Widget buildList(String titulo, List<ServiceCity> items) {
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
                      iconData: Icons.location_city_rounded,
                      rightIcon: titulo == 'Atende'
                          ? Icons.remove_circle
                          : Icons.add_circle,
                      title: items[index].city.description,
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
                                      _removeCity(items[index].serviceCityId);
                                    },
                                  );
                                })
                            : _addCity(items[index].veterinarianId,
                                items[index].city.cityId);
                      });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeCity(int id) async {
    Object map = {"id": id};

    bool isSuccess = await ServiceCityRemote().deleteServiceCity(map);

    if (isSuccess) {
      refreshData();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao remover a cidade.'),
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

  Future<void> _addCity(int vetId, int cityId) async {
    Object map = {"veterinarian_id": vetId, "city_id": cityId};

    bool isSuccess = await ServiceCityRemote().saveServiceCity(map);

    if (isSuccess) {
      refreshData();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao adicionar a cidade.'),
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
                final atendeData = snapshot.data;
                if (atendeData != null) {
                  return buildList('Atende', atendeData);
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
