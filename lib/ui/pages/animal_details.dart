import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/widgets/confirm_button.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class AnimalDetails extends StatefulWidget {
  final Animal? animal;
  final Function() onAnimalEdited;

  const AnimalDetails(this.animal, this.onAnimalEdited, {Key? key})
      : super(key: key);

  @override
  State<AnimalDetails> createState() => _AnimalDetailsState();
}

class _AnimalDetailsState extends State<AnimalDetails> {
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
                color:  const Color.fromARGB(255, 255, 255, 255),
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
                        height: 300,
                        width: MediaQuery.of(context).size.height * 0.7,
                        child: Image.network(
                          widget.animal!.imgUrl,
                          fit: BoxFit.fill,
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          radius: 20,
                          child: Icon(Icons.edit,
                              size: 22,
                              color: Theme.of(context).primaryColorLight),
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
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(' ${widget.animal!.animalType.description}'),
                              Text(
                                  'Nasc.: ${widget.animal!.birthDate.day}/${widget.animal!.birthDate.month}/${widget.animal!.birthDate.year}'),
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
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(widget.animal!.description),
                          const SizedBox(height: 20),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DefaultOutlineButton(
                        "Editar",
                        () {},
                        width: 100,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      ConfirmButton(
                          yesFunction: _deleteAnimal,
                          color: Colors.red,
                          buttonText: "Excluir",
                          confirmText: "Tem certeza que deseja excluir?")
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
