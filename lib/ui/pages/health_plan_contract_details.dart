import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/service.dart';
import 'package:flutter/material.dart';

class HealthPlanContractDetails extends StatefulWidget {
  final HealthPlanContract contract;
  const HealthPlanContractDetails(this.contract, {super.key});

  @override
  State<HealthPlanContractDetails> createState() =>
      _HealthPlanContractDetailsState();
}

class _HealthPlanContractDetailsState extends State<HealthPlanContractDetails> {
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
    colors = widget.contract.healthPlan.planColors.map((colorString) {
      return Color(int.parse(colorString, radix: 16));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.90,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors[0], colors[1]],
          )),
          child: Center(
            child: Column(children: [
              Text(
                widget.contract.healthPlan.description,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                widget.contract.healthPlan.detailedDescription,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Entre ${widget.contract.healthPlan.minimalAnimals}-${widget.contract.healthPlan.maximumAnimals} animais.',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Você está pagando R\$${widget.contract.value.toStringAsFixed(2)} por ${widget.contract.healthPlanContractType.healthPlanContractTypeId == 1 ? 'mês' : 'ano'}.',
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Serviços:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colors[0], colors[1]],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors[1],
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]),
                  child: AutoAnimatedList<Service>(
                    items: widget.contract.healthPlan.services,
                    itemBuilder: (context, record, index, animation) {
                      return SizeFadeTransition(
                        animation: animation,
                        child: ListTile(
                          iconColor: Colors.white,
                          leading: const Icon(Icons.medical_services_outlined),
                          title: Text(
                            record.description,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                child: Text(
                  'Acionar',
                  style: TextStyle(
                      color: colors[1],
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
          ),
        )
      ]),
    );
  }
}
