import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class VetAnimalDetails extends StatefulWidget {
  final Animal? animal;

  const VetAnimalDetails(this.animal, {Key? key})
      : super(key: key);

  @override
  State<VetAnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<VetAnimalDetails> {
  late Future<String> animalImageUrl;

  @override
  void initState() {
    super.initState();
    setState(() {
      animalImageUrl = _loadAnimalImage();
    });
  }

  void refresh() {
    Navigator.pop(context);
  }


  Future<String> _loadAnimalImage() async {
    AnimalRemote userRemote = AnimalRemote();
    return userRemote.getImage(widget.animal!.animalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 213, 213),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 133, 133, 133)
                        .withOpacity(0.5),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              height: MediaQuery.of(context).size.height * 1.1,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                        height: 250,
                        width: MediaQuery.of(context).size.height * 0.7,
                        child: FutureBuilder<String>(
                          future: animalImageUrl,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ); // Ou outro indicador de carregamento
                            } else if (snapshot.hasError) {
                              return const Text('Erro ao carregar imagem');
                            } else {
                              return Image.network(
                                snapshot.data!,
                                fit: BoxFit.fill,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.animal!.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 71, 71, 71),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('')),
                              DataColumn(label: Text('')),
                            ],
                            rows: [
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Tipo:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(
                                    ' ${widget.animal!.animalType.description}')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Sub-Tipo:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(
                                    ' ${widget.animal!.animalSubType.description}')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text(
                                  'Peso:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                DataCell(Text(' ${widget.animal!.weight}kg')),
                              ]),
                              if (widget.animal!.animalSubType.animalSubTypeId == 3)
                                  DataRow(cells: [
                                    const DataCell(Text(
                                      'Quantidade:',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    )),
                                    DataCell(Text(' ${widget.animal!.amount}')),
                                  ]),
                              DataRow(cells: [
                                const DataCell(Text('Nascimento:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                DataCell(Text(
                                    '${widget.animal!.birthDate.day}/${widget.animal!.birthDate.month}/${widget.animal!.birthDate.year}')),
                              ]),
                              DataRow(cells: [
                                const DataCell(Text('Local:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      _showAddressDetailsModal(
                                          context, widget.animal!.userAddress);
                                    },
                                    child: Row(
                                      children: [
                                        Text(
                                          '${widget.animal!.userAddress.city.description} - ${widget.animal!.userAddress.city.uf}',
                                        ),
                                        Icon(
                                          Icons.not_listed_location_outlined,
                                          size: 22,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ]),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              widget.animal!.description,
                              textAlign: TextAlign
                                  .center, // Isso alinha o texto ao centro horizontalmente
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
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
