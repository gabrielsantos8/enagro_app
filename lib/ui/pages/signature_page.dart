import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:enagro_app/datasource/remote/health_plan_contract_remote.dart';
import 'package:enagro_app/datasource/remote/health_plan_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/animal_subtype.dart';
import 'package:enagro_app/models/animal_type.dart';
import 'package:enagro_app/models/city.dart';
import 'package:enagro_app/models/health_plan.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/ui/pages/home_page.dart';
import 'package:enagro_app/ui/widgets/confirm__dialog.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class SignaturePage extends StatefulWidget {
  final HealthPlan plan;
  final User? user;
  const SignaturePage(this.plan, this.user, {super.key});

  @override
  State<SignaturePage> createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  GroupController typeController = GroupController(initSelectedItem: [1]);
  late int type = 1;
  late double value = widget.plan.value;
  late int animalsCount = 0;
  late String animalsId = '';
  late List<Animal> animals = [
    Animal(
        amount: 0,
        animalId: 0,
        animalSubType: AnimalSubType(
            animalSubTypeId: 0,
            description: '',
            animalType: AnimalType(animalTypeId: 0, description: '')),
        animalType: AnimalType(animalTypeId: 0, description: ''),
        birthDate: DateTime(1),
        description: '',
        imgUrl: '',
        name: '',
        userAddress: UserAddress(
            userAddressId: 0,
            complement: '',
            city: City(cityId: 0, description: '', uf: '', ibge: 0),
            userId: 0),
        weight: 0,
        healthPlanContractAnimalId: 0)
  ];

  @override
  void initState() {
    super.initState();
    fetchAnimals();
  }

  void _signPlan() async {
    Object map = {
      "health_plan_id": widget.plan.healthPlanId,
      "user_id": widget.user!.userId,
      "health_plan_contract_type_id": type,
      "value": value,
      "animals": animalsId
    };

    bool isSuccess = await HealthPlanContractRemote().contractSign(map);

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Plano assinado com sucesso!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(widget.user)),
                      (Route<dynamic> route) => false);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao assinar o plano.'),
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

  Future<void> fetchAnimals() async {
    List<Animal> fetchedAnimals = await HealthPlanRemote()
        .getAnimalsToAddByUser(widget.user!.userId, widget.plan.healthPlanId);
    setState(() {
      animals = fetchedAnimals;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(children: [
          SizedBox(
              child: Container(
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height * 0.90,
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Realizando assinatura',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.8,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 245, 244, 244),
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
                              Text(
                                widget.plan.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SimpleGroupedCheckbox<int>(
                                controller: typeController,
                                onItemSelected: (values) {
                                  setState(() {
                                    type = values;
                                    value = values == 1 ? value : value * 12;
                                  });
                                },
                                itemsTitle: const ["Mensal", "Anual"],
                                values: const [1, 2],
                                groupStyle: GroupStyle(
                                    activeColor: Theme.of(context).primaryColor,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13)),
                              ),
                              const Text(
                                'Você pagará',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'R\$ ${type == 1 ? widget.plan.value.toStringAsFixed(2) : (widget.plan.value * 12).toStringAsFixed(2)}/${type == 1 ? 'mês' : 'ano'}.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Theme.of(context).primaryColor),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Animais ($animalsCount/${widget.plan.maximumAnimals.toString()})',
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: MultiSelectDialogField(
                                  items: animals
                                      .map((e) => MultiSelectItem(e, e.name))
                                      .toList(),
                                  listType: MultiSelectListType.CHIP,
                                  title: const Text('Seus animais disponíveis'),
                                  cancelText: Text(
                                    'Fechar',
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  buttonText: const Text('Selecione...'),
                                  onConfirm: (values) {
                                    num maxAnimals = widget.plan.maximumAnimals;
                                    int totalAnimalsAmount = values
                                        .map((animal) => animal.amount)
                                        .reduce((sum, amount) => sum + amount);
                                    if (!(totalAnimalsAmount <= maxAnimals)) {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Atenção'),
                                            content: Text(
                                                'Você está tentando adicionar uma quantia acima do máximo de animais para esse plano! (Máximo: $maxAnimals, quantia enviada: $totalAnimalsAmount)'),
                                            actions: [
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Ok',
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      return;
                                    }
                                    List<String> str = [];
                                    for (var anm in values) {
                                      str.add(anm.animalId.toString());
                                    }
                                    setState(() {
                                      animalsId = str.join(',');
                                      animalsCount = totalAnimalsAmount;
                                    });
                                  },
                                ),
                              ),
                              const Spacer(),
                              DefaultOutlineButton(
                                'Realizar assinatura',
                                () {
                                  if (animalsCount == 0) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return ConfirmDialog(
                                            content:
                                                "Você tem certeza que deseja vincular nenhum animal a assinatura? Você pode fazer isso mais tarde.",
                                            noFunction: () {
                                              Navigator.pop(context);
                                            },
                                            yesFunction: () {
                                              Navigator.pop(context);
                                              _signPlan();
                                            },
                                          );
                                        });
                                        return;
                                  }
                                  _signPlan();
                                  return;
                                },
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )))
        ]));
  }
}
