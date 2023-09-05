import 'dart:io';

import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/pages/animal_edit_page.dart';
import 'package:enagro_app/ui/widgets/circular_button.dart';
import 'package:enagro_app/ui/widgets/confirm_circular_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AnimalDetails extends StatefulWidget {
  final Animal? animal;
  final User? user;
  final Function() onAnimalEdited;

  const AnimalDetails(this.animal, this.user, this.onAnimalEdited, {Key? key})
      : super(key: key);

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
  late Future<String> animalImageUrl;

  @override
  void initState() {
    super.initState();
    setState(() {
      animalImageUrl = _loadAnimalImage();
    });
  }

  void refresh() {
    widget.onAnimalEdited();
    Navigator.pop(context);
  }

  void _showModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Opções"),
              const SizedBox(height: 16.0),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Remover imagem"),
                onTap: _removeImage,
              ),
              ListTile(
                  leading: const Icon(Icons.send),
                  title: const Text("Enviar imagem"),
                  onTap: _sendImage),
            ],
          ),
        );
      },
    );
  }

  Future<void> _removeImage() async {
    bool isSuccess = await AnimalRemote().removeImage(widget.animal!.animalId);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);

      setState(() {
        widget.onAnimalEdited();
        animalImageUrl = _loadAnimalImage();
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao remover imagem.'),
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

  Future<String> _loadAnimalImage() async {
    AnimalRemote userRemote = AnimalRemote();
    return userRemote.getImage(widget.animal!.animalId);
  }

  Future<void> _sendImage() async {
    AnimalRemote animalRemote = AnimalRemote();
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      bool isSuccess =
          await animalRemote.sendImage(file, widget.animal!.animalId);
      if (isSuccess) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);

        setState(() {
          widget.onAnimalEdited();
          animalImageUrl = _loadAnimalImage();
        });
      } else {
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: const Text('Houve um erro ao enviar imagem.'),
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
  }

  Future<void> _deleteAnimal() async {
    Object map = {"id": widget.animal!.animalId};

    bool isSuccess = await AnimalRemote().deleteAnimal(map);

    if (isSuccess) {
      widget.onAnimalEdited();
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao excluir o animal.'),
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
      backgroundColor: const Color.fromARGB(255, 213, 213, 213),
      appBar: AppBar(automaticallyImplyLeading: false),
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
              height: MediaQuery.of(context).size.height * 0.99,
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
                      Padding(
                        padding: const EdgeInsets.only(right: 10, bottom: 10),
                        child: InkWell(
                          onTap: () {
                            _showModal(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColorDark,
                            radius: 20,
                            child: Icon(Icons.edit,
                                size: 22,
                                color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      )
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
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircularButton(
                          label: "Editar",
                          color: const Color.fromARGB(255, 238, 237, 237),
                          icon: Icons.edit_outlined,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnimalEditPage(
                                          animal: widget.animal,
                                          onAnimalEdited: refresh,
                                          user: widget.user,
                                        )));
                          }),
                      CircularButton(
                          label: "Histórico",
                          color: const Color.fromARGB(255, 238, 237, 237),
                          icon: Icons.history_outlined,
                          onPressed: () {}),
                      ConfirmCircularButton(
                          label: "Excluir",
                          color: const Color.fromARGB(255, 255, 227, 225),
                          icon: Icons.delete_outline,
                          confirmText: "Tem certeza que deseja excluir?",
                          onPressed: _deleteAnimal)
                    ],
                  ),
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
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar o modal
            },
            child: const Text("Fechar"),
          ),
        ],
      );
    },
  );
}
