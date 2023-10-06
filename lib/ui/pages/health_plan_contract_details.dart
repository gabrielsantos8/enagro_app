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
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  
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
                      color: Theme.of(context).primaryColorDark,
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
