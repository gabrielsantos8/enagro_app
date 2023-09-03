import 'package:enagro_app/datasource/remote/animal_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/animal_details.dart';
import 'package:enagro_app/ui/widgets/card_list_item.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class AnimalPage extends StatefulWidget {
  final User? user;
  const AnimalPage(this.user, {super.key});

  @override
  State<AnimalPage> createState() => _AnimalPageState();
}

class _AnimalPageState extends State<AnimalPage> {
  void refreshData() {
    setState(() {
      _buildAnimalList(widget.user!.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 213, 213, 213),
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 236, 236, 236),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 133, 133, 133)
                          .withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.99,
                child: _buildAnimalList(widget.user!.userId),
              )),
        ));
  }

  Widget _buildAnimalList(int userId) {
    return FutureBuilder(
      future: AnimalRemote().getByUser(userId),
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
                  const Text(
                    "Animais",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 114, 114, 114),
                        fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Animal animal = snapshot.data![index];
                        return CardListItem(
                          title: animal.name,
                          description:
                              '${animal.userAddress.city.description} - ${animal.userAddress.city.uf}',
                          imageUrl: animal.imgUrl,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AnimalDetails(animal, refreshData)));
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DefaultOutlineButton(
                      'Adicionar Animal',
                      () {},
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar animais!'));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Nenhum animal cadastrado')),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DefaultOutlineButton(
                      'Adicionar Animal',
                      () {},
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }
}
