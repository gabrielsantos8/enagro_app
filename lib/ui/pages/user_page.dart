import 'package:enagro_app/datasource/remote/user_address_remote.dart';
import 'package:enagro_app/datasource/remote/user_phone_remote.dart';
import 'package:enagro_app/datasource/remote/user_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/models/user_phone.dart';
import 'package:enagro_app/ui/pages/entry_page.dart';
import 'package:enagro_app/ui/pages/user_address_create_page.dart';
import 'package:enagro_app/ui/pages/user_address_edit_page.dart';
import 'package:enagro_app/ui/pages/user_phone_create_page.dart';
import 'package:enagro_app/ui/pages/user_phone_edit_page.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  final User? user;

  const UserPage(this.user, {super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  late Future<String> userProfileImageUrl;

  @override
  void initState() {
    super.initState();
    setState(() {
      userProfileImageUrl = _loadUserProfileImage();
    });
  }

  Future<String> _loadUserProfileImage() async {
    UserRemote userRemote = UserRemote();
    return userRemote.getImage(widget.user!.userId);
  }

  Future<void> _removeImage() async {
    bool isSuccess = await UserRemote().removeImage(widget.user!.userId);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);

      setState(() {
        userProfileImageUrl = _loadUserProfileImage();
      });
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao remove imagem.'),
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
                onTap: () {
                  // Lógica para enviar a imagem
                  Navigator.pop(context); // Fechar a modal
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void refreshData() {
    setState(() {
      _buildAddressList(widget.user!.userId);
      _buildPhoneList(widget.user!.userId);
      _loadUserProfileImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.zero,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    FutureBuilder<String>(
                      future: userProfileImageUrl,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Ou outro indicador de carregamento
                        } else if (snapshot.hasError) {
                          return const Text('Erro ao carregar imagem');
                        } else {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              snapshot.data!,
                            ),
                          );
                        }
                      },
                    ),
                    Positioned(
                      top: 70,
                      left: 70,
                      child: InkWell(
                        onTap: () {
                          _showModal(context);
                        },
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColorDark,
                          radius: 15,
                          child: Icon(Icons.edit,
                              size: 20,
                              color: Theme.of(context).primaryColorLight),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.user!.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.user!.email,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(2.7),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: const Center(
                      child: Text(
                        'Telefone:',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                    child: _buildPhoneList(widget.user!.userId),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(2.7),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 246, 246, 246),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: const Center(
                      child: Text(
                        'Endereço(s):',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.31,
                    child: _buildAddressList(widget.user!.userId),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          const SizedBox(height: 20),
          DefaultOutlineButton(
            'Sair',
            () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ConfirmDialog(
                      content: "Tem certeza que deseja sair?",
                      noFunction: () {
                        Navigator.pop(context);
                      },
                      yesFunction: () {
                        UserRemote.signOut();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const EntryPage()),
                            (Route<dynamic> route) => false);
                      },
                    );
                  });
            },
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildAddressList(int userId) {
    return FutureBuilder(
      future: UserAddressRemote().getByUser(userId),
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
                        UserAddress address = snapshot.data![index];
                        return DefaultHomeItem(
                          title:
                              '${address.city.description} - ${address.city.uf}',
                          description: address.complement,
                          div: false,
                          iconData: Icons.home_outlined,
                          rightIcon: Icons.edit_location_alt_outlined,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserAddressEditPage(
                                        address,
                                        onAddressEdited: refreshData,
                                      )),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DefaultOutlineButton(
                      'Adicionar Endereço',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAddressCreatePage(
                                  onAddressEdited: refreshData,
                                  userId: widget.user!.userId)),
                        );
                      },
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar endereços!'));
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('Nenhum endereço cadastrado')),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DefaultOutlineButton(
                      'Adicionar Endereço',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserAddressCreatePage(
                                  onAddressEdited: refreshData,
                                  userId: widget.user!.userId)),
                        );
                      },
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

  Widget _buildPhoneList(int userId) {
    return FutureBuilder(
      future: UserPhoneRemote().getByUser(userId),
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
            if (snapshot.hasData && snapshot.data!.userPhoneId > 0) {
              UserPhone? phone = snapshot.data;
              return DefaultHomeItem(
                title: '(${phone?.ddd}) ${phone?.number}',
                div: false,
                iconData: Icons.phone_android_outlined,
                rightIcon: Icons.edit_outlined,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserPhoneEditPage(
                            userPhone: phone, onPhoneEdited: refreshData)),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar telefone!'));
            } else {
              return Center(
                  child: Column(
                children: [
                  const Text('Nenhum telefone cadastrado'),
                  const SizedBox(height: 10),
                  DefaultOutlineButton(
                    'Adicionar Telefone',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserPhoneCreatePage(userId,
                                onPhoneEdited: refreshData)),
                      );
                    },
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ));
            }
        }
      },
    );
  }
}
