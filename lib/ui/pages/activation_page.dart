import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:date_field/date_field.dart';
import 'package:enagro_app/datasource/remote/activation_remote.dart';
import 'package:enagro_app/datasource/remote/veterinarian_remote.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/widgets/default_button.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:enagro_app/ui/widgets/multi_select_animal_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:selectable_list/selectable_list.dart';
import 'package:stepper_page_view/stepper_page_view.dart';

class ActivationPage extends StatefulWidget {
  final HealthPlanContract contract;
  const ActivationPage(this.contract, {super.key});

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  List<Veterinarian> veterinarians = [];
  Veterinarian? selVeterinarian;
  GroupController typeController = GroupController(initSelectedItem: [1]);
  PageController pageController = PageController(initialPage: 0);
  String selAnimals = '';
  String selServices = '';
  String selServicesAndValues = '';
  bool _isSaving = false;
  DateTime? scheduledDate;

  Future<void> _loadVeterinarians() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    List<Veterinarian> vets = await VeterinarianRemote()
        .getByServicesAndCities(selServices, selAnimals);
    setState(() {
      veterinarians = vets;
    });
  }

  Future<void> _activate() async {
    if (!formKey.currentState!.validate()  || selVeterinarian == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    Object prms = {
      "contract_id": widget.contract.healthPlanContractId,
      "veterinarian_id": selVeterinarian!.userVeterinarianId,
      "activation_type_id": typeController.selectedItem,
      "scheduled_date": scheduledDate.toString(),
      "animals": selAnimals,
      "services": selServicesAndValues
    };

    bool isSuccess = await ActivationRemote().createActivation(prms);

    setState(() {
      _isSaving = false;
    });

    if (isSuccess) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erro'),
            content: const Text('Houve um erro ao salvar o animal.'),
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Form(
          key: formKey,
          child: StepperPageView(
            pageController: pageController,
            onPageChanged: (value) async {
              if (!formKey.currentState!.validate()) {
                pageController.jumpToPage(0);
              }
              await _loadVeterinarians();
            },
            pageSteps: [
              PageStep(
                  title: const Text('Passo 1'),
                  content: ListView(children: [
                    SizedBox(
                        child: Container(
                            padding: const EdgeInsets.all(16),
                            height: MediaQuery.of(context).size.height * 0.90,
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Realizando acionamento',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                          255, 245, 244, 244),
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
                                          widget
                                              .contract.healthPlan.description,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        SimpleGroupedCheckbox<int>(
                                          controller: typeController,
                                          onItemSelected: (values) {},
                                          itemsTitle: const [
                                            "Agendamento",
                                            "Urgente"
                                          ],
                                          values: const [1, 2],
                                          groupStyle: GroupStyle(
                                              activeColor: Theme.of(context)
                                                  .primaryColor,
                                              itemTitleStyle: const TextStyle(
                                                  fontSize: 13)),
                                        ),
                                        const Divider(),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        DateTimeFormField(
                                          decoration: const InputDecoration(
                                            hintStyle: TextStyle(
                                                color: Colors.black45),
                                            errorStyle: TextStyle(
                                                color: Colors.redAccent),
                                            border: OutlineInputBorder(),
                                            suffixIcon: Icon(Icons.event_note),
                                            labelText:
                                                'Data desejada para atendimento',
                                          ),
                                          dateFormat: DateFormat('dd/MM/yyyy'),
                                          mode: DateTimeFieldPickerMode.date,
                                          onDateSelected: (DateTime value) {
                                            setState(() {
                                              scheduledDate = value;
                                            });
                                          },
                                          use24hFormat: true,
                                          firstDate: DateTime.now().subtract(
                                              const Duration(days: 1)),
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Campo Obrigatório!';
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        MultiSelectAnimalServices(
                                            onSelectionChanged: (animalsId,
                                                servicesId, servicesAndValues) {
                                              setState(() {
                                                selAnimals = animalsId;
                                                selServices = servicesId;
                                                selServicesAndValues =
                                                    servicesAndValues;
                                              });
                                            },
                                            contractId: widget
                                                .contract.healthPlanContractId),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        DefaultOutlineButton(
                                          'Selecionar veterinário',
                                          () async {
                                            await _loadVeterinarians();
                                            pageController.nextPage(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.linear);
                                          },
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )))
                  ])),
              if (veterinarians.isNotEmpty)
                PageStep(
                    title: const Text('Passo 2'),
                    content: ListView(children: [
                      SizedBox(
                          child: Container(
                              padding: const EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.height * 0.90,
                              child: Center(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const Text(
                                      'Realizando acionamento',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                        padding: const EdgeInsets.all(10),
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.7,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 245, 244, 244),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 3,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            SelectableList<Veterinarian,
                                                Veterinarian?>(
                                              items: veterinarians,
                                              itemBuilder: (context, vet,
                                                      selected, onTap) =>
                                                  ListTile(
                                                      selectedColor:
                                                          Theme.of(context)
                                                              .primaryColor,
                                                      leading: SizedBox(
                                                        width: 90,
                                                        child: Image.network(
                                                          vet.imgUrl,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                      title: Text(vet.nome),
                                                      subtitle: Text(
                                                          vet.pfUf.toString()),
                                                      selected: selected,
                                                      onTap: onTap),
                                              valueSelector: (vet) => vet,
                                              selectedValue: selVeterinarian,
                                              onItemSelected: (vet) => setState(
                                                  () => selVeterinarian = vet),
                                              onItemDeselected: (vet) =>
                                                  setState(() =>
                                                      selVeterinarian = null),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            DefaultOutlineButton(
                                              (_isSaving
                                                  ? 'Acionando'
                                                  : 'Realizar Acionamento'),
                                              _activate,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor),
                                            ),
                                            const SizedBox(height: 10),
                                            if (!_isSaving)
                                              DefaultButton(
                                                'Voltar',
                                                () {
                                                  pageController.animateTo(0,
                                                      curve: Curves.linear,
                                                      duration: const Duration(
                                                          milliseconds: 300));
                                                },
                                              )
                                          ],
                                        )),
                                  ],
                                ),
                              )))
                    ])),
              if (veterinarians.isEmpty)
                PageStep(
                    title: const Text('Passo 2'),
                    content: Column(
                      children: [
                        const Spacer(),
                        Icon(
                          Icons.no_accounts_outlined,
                          size: 70,
                          color: Theme.of(context).primaryColor,
                        ),
                        const Center(
                            child: Text(
                          'Nenhum veterinário disponível!',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                        const SizedBox(height: 10),
                        DefaultButton(
                          'Voltar',
                          () {
                            pageController.animateTo(0,
                                curve: Curves.linear,
                                duration: const Duration(milliseconds: 300));
                          },
                        ),
                        const Spacer()
                      ],
                    )),
            ],
          ),
        ));
  }
}
