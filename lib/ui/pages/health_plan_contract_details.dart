import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:backdrop_modal_route/backdrop_modal_route.dart';
import 'package:enagro_app/datasource/remote/health_plan_contract_animal_remote.dart';
import 'package:enagro_app/datasource/remote/health_plan_contract_installment_remote.dart';
import 'package:enagro_app/datasource/remote/health_plan_contract_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/installment.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/activation_page.dart';
import 'package:enagro_app/ui/pages/home_page.dart';
import 'package:enagro_app/ui/widgets/card_list_item.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:enagro_app/ui/widgets/installment_item.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class HealthPlanContractDetails extends StatefulWidget {
  final HealthPlanContract contract;
  final User? user;
  const HealthPlanContractDetails(this.contract, this.user, {super.key});

  @override
  State<HealthPlanContractDetails> createState() =>
      _HealthPlanContractDetailsState();
}

class _HealthPlanContractDetailsState extends State<HealthPlanContractDetails>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Animal> animals;
  late bool canTrigger = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    fetchAnimals();
    _buildInstallmentlList(widget.contract.healthPlanContractId);
  }

  Future<void> fetchAnimals() async {
    int userId = widget.contract.userId;
    int contractId = widget.contract.healthPlanContractId;
    List<Animal> fetchedAnimals = await HealthPlanContractAnimalRemote()
        .getAnimalsToAddByUser(userId, contractId);
    setState(() {
      animals = fetchedAnimals;
    });
  }

  void _handleTabSelection() {
    setState(() {});
  }

  void refreshData() {
    setState(() {
      _buildAnimalList(widget.contract.healthPlanContractId);
      _buildInstallmentlList(widget.contract.healthPlanContractId);
      fetchAnimals();
    });
  }

  void _cancel() async {
    Object map = {"user_id": widget.user!.userId};
    bool isSuccess =
        await HealthPlanContractRemote().contractCancel(map);
    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(widget.user)), (Route<dynamic> route) => false);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao cancelar a assinatura.'),
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

  void _removeAnimal(int id) async {
    Object map = {"id": id};

    bool isSuccess =
        await HealthPlanContractAnimalRemote().deleteContractAnimal(map);

    if (isSuccess) {
      refreshData();
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao remover o animal.'),
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

  void _addAnimal(int animalId) async {
    Object map = {
      "animal_id": animalId,
      "contract_id": widget.contract.healthPlanContractId
    };

    bool isSuccess =
        await HealthPlanContractAnimalRemote().addContractAnimal(map);

    if (!isSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao adicionar o animal.'),
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

  void _pay(int installmentId) async {
    Object map = {
      "installment_id": installmentId,
      "type_id": widget.contract.healthPlanContractType.healthPlanContractTypeId
    };

    bool isSuccess = await HealthPlanContractRemote().payInstallment(map);

    if (!isSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao pagar a parcela.'),
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
      return;
    }
    refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Detalhes'),
                Tab(text: 'Animais'),
                Tab(text: 'Parcelas'),
              ],
              indicatorColor: Theme.of(context).primaryColorLight,
              labelColor: Colors.white),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.90,
            child: TabBarView(controller: _tabController, children: [
              Container(
                child: _buildDetailsContract(),
              ),
              Container(
                child: _buildAnimalList(widget.contract.healthPlanContractId),
              ),
              Container(
                child: _buildInstallmentlList(
                    widget.contract.healthPlanContractId),
              )
            ])),
      ]),
    );
  }

  Widget _buildDetailsContract() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.90,
      child: Center(
        child: Column(children: [
          Text(
            widget.contract.healthPlan.description,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.contract.healthPlan.detailedDescription,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Entre ${widget.contract.healthPlan.minimalAnimals}-${widget.contract.healthPlan.maximumAnimals} animais.',
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Você está pagando R\$${widget.contract.value.toStringAsFixed(2)} por ${widget.contract.healthPlanContractType.healthPlanContractTypeId == 1 ? 'mês' : 'ano'}.',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Serviços:',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color.fromARGB(255, 221, 221, 221)],
                  )),
              child: AutoAnimatedList<Service>(
                items: widget.contract.healthPlan.services,
                itemBuilder: (context, record, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      leading: const Icon(Icons.medical_services_outlined),
                      title: Text(
                        '${record.description} (${record.animalSubType.description})',
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
          const SizedBox(height: 10)
        ]),
      ),
    );
  }

  Widget _buildAnimalList(int contractId) {
    return FutureBuilder(
      future: HealthPlanContractAnimalRemote().getByContract(contractId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ));
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              int totalAmount = _calculateTotalAmount(snapshot.data!);
              return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Color.fromARGB(255, 221, 221, 221)
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 221, 221, 221),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ]),
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Animal animal = snapshot.data![index];
                            return CardListItem(
                              trailing: const Icon(Icons.delete_outlined),
                              title: animal.name,
                              description:
                                  '${animal.userAddress.city.description} - ${animal.userAddress.city.uf}',
                              imageUrl: animal.imgUrl,
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return ConfirmDialog(
                                        content:
                                            "Tem certeza que deseja remover esse animal do plano?",
                                        noFunction: () {
                                          Navigator.pop(context);
                                        },
                                        yesFunction: () {
                                          Navigator.pop(context);
                                          _removeAnimal(
                                              animal.healthPlanContractAnimalId
                                                  as int);
                                        },
                                      );
                                    });
                              },
                            );
                          },
                        ),
                      ),
                      if (totalAmount <
                          widget.contract.healthPlan.maximumAnimals)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: DefaultOutlineButton(
                            'Adicionar Animal',
                            () async {
                              await _buildAddAnimalModal(totalAmount);
                            },
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                    ],
                  ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar animais!'));
            } else {
              return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Color.fromARGB(255, 221, 221, 221)],
                  )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                          child: Text(
                        'Nenhum animal cadastrado!',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: DefaultOutlineButton(
                          'Adicionar Animal',
                          () async {
                            await _buildAddAnimalModal(0);
                          },
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ));
            }
        }
      },
    );
  }

  int _calculateTotalAmount(List<Animal> animals) {
    int totalAmount = 0;

    for (Animal animal in animals) {
      totalAmount += animal.amount;
    }

    return totalAmount;
  }

  _buildAddAnimalModal(int totalAmount) {
    return Navigator.push(
      context,
      BackdropModalRoute<void>(
        overlayContentBuilder: (context) {
          return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(children: [
                    const Text(
                      'Adicionar animais',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close))
                  ]),
                  const SizedBox(height: 50),
                  Center(
                    child: MultiSelectDialogField(
                      items: animals
                          .map((e) => MultiSelectItem(e, e.name))
                          .toList(),
                      listType: MultiSelectListType.CHIP,
                      title: const Text('Seus animais disponíveis'),
                      cancelText: Text(
                        'Fechar',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      buttonText: const Text('Selecione...'),
                      onConfirm: (values) {
                        int maxAnimals =
                            widget.contract.healthPlan.maximumAnimals -
                                totalAmount;
                        int totalAnimalsAmount = values
                            .map((animal) => animal.amount)
                            .reduce((sum, amount) => sum + amount);

                        if (totalAnimalsAmount <= maxAnimals) {
                          for (var animal in values) {
                            _addAnimal(animal.animalId);
                          }
                          Navigator.pop(context);
                          refreshData();
                          return;
                        }
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Atenção'),
                              content: const Text(
                                  'Você está tentando adicionar uma quantia acima do máximo de animais para esse plano!'),
                              actions: [
                                OutlinedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Ok',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onSelectionChanged: (values) {},
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.50),
                  Text(
                    'Quantidade disponível: ${widget.contract.healthPlan.maximumAnimals - totalAmount}.',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Divider()
                ],
              ));
        },
      ),
    );
  }

  Widget _buildInstallmentlList(int contractId) {
    return FutureBuilder(
      future: HealthPlanContractInstallmentRemote().getByContract(contractId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Container(
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).primaryColorLight,
                  ),
                ));
          case ConnectionState.done:
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 221, 221, 221),
                                spreadRadius: 2,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ]),
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            Installment installment = snapshot.data![index];
                            if (index == snapshot.data!.length - 1) {
                              DateTime today = DateTime.now();
                              canTrigger = installment.statusId != 1 &&
                                  !installment.dueDate.isBefore(today);
                            }
                            String status = "";
                            if (installment.statusId == 1) {
                              status = "Pago";
                            } else if (installment.statusId == 2) {
                              status = "Pendente";
                            } else {
                              status = "Cancelado";
                            }
                            return InstallmentItem(
                                installmentNumber:
                                    installment.installmentNumber,
                                status: status,
                                value: installment.value,
                                dueDate: installment.dueDate,
                                color: Theme.of(context).primaryColor,
                                onCLick: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return ConfirmDialog(
                                          content:
                                              "Tem certeza que deseja pagar essa parcela?",
                                          noFunction: () {
                                            Navigator.pop(context);
                                          },
                                          yesFunction: () {
                                            Navigator.pop(context);
                                            _pay(installment.installmentId);
                                          },
                                        );
                                      });
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (!canTrigger) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Atenção'),
                                      content: const Text(
                                          'Primeiro pague as parcelas que estão pendentes/vencidas.'),
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
                                return;
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ActivationPage(
                                          widget.contract, widget.user)));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              'Acionar',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ConfirmDialog(
                                      content:
                                          "Tem certeza que deseja cancelar sua assinatura?",
                                      noFunction: () {
                                        Navigator.pop(context);
                                      },
                                      yesFunction: () {
                                        Navigator.pop(context);
                                        _cancel();
                                      },
                                    );
                                  });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar parcelas!'));
            } else {
              return Container(
                  padding: const EdgeInsets.all(10),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        'Nenhuma parcela encontrada!',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ))
                    ],
                  ));
            }
        }
      },
    );
  }
}
