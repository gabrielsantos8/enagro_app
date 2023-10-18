import 'package:checkbox_grouped/checkbox_grouped.dart';
import 'package:date_field/date_field.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ActivationPage extends StatefulWidget {
  final HealthPlanContract contract;
  const ActivationPage(this.contract, {super.key});

  @override
  State<ActivationPage> createState() => _ActivationPageState();
}

class _ActivationPageState extends State<ActivationPage> {
  GroupController typeController = GroupController(initSelectedItem: [1]);
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
                          'Realizando acionamento',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
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
                                widget.contract.healthPlan.description,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              SimpleGroupedCheckbox<int>(
                                controller: typeController,
                                onItemSelected: (values) {},
                                itemsTitle: const ["Agendamento", "Urgente"],
                                values: const [1, 2],
                                groupStyle: GroupStyle(
                                    activeColor: Theme.of(context).primaryColor,
                                    itemTitleStyle:
                                        const TextStyle(fontSize: 13)),
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 20,
                              ),

                              DateTimeFormField(
                                decoration: const InputDecoration(
                                  hintStyle:
                                      TextStyle(color: Colors.black45),
                                  errorStyle:
                                      TextStyle(color: Colors.redAccent),
                                  border: OutlineInputBorder(),
                                  suffixIcon: Icon(Icons.event_note),
                                  labelText: 'Data desejada para atendimento',
                                ),
                                dateFormat: DateFormat('dd/MM/yyyy'),
                                mode: DateTimeFieldPickerMode.date,
                                onDateSelected: (DateTime value) {
                                  
                                },
                                use24hFormat: true,
                                firstDate: DateTime.now().subtract(const Duration(days: 1)),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Campo Obrigatório!';
                                  }
                                  return null;
                                },
                              ),
                              const Spacer(),
                              DefaultOutlineButton(
                                'Realizar acionamento',
                                () {},
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
