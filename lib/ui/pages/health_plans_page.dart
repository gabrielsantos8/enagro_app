import 'package:enagro_app/datasource/remote/health_plan_contract_remote.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/health_plan_contract_details.dart';
import 'package:flutter/material.dart';

class HealthPlansPage extends StatefulWidget {
  final User? user;

  const HealthPlansPage(this.user, {Key? key}) : super(key: key);

  @override
  State<HealthPlansPage> createState() => _HealthPlansPageState();
}

class _HealthPlansPageState extends State<HealthPlansPage> {
  Future<HealthPlanContract>? _futureActiveContract;

  @override
  void initState() {
    super.initState();
    _futureActiveContract =
        HealthPlanContractRemote().getActiveContractByUser(widget.user!.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          FutureBuilder<HealthPlanContract>(
            future: _futureActiveContract,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.healthPlanContractId > 0) {
                final activeContract = snapshot.data!;
                return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 252, 252),
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).primaryColor, width: 3)),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .primaryColorLight
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activeContract.healthPlan.description,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${activeContract.value.toStringAsFixed(2)} / ${activeContract.healthPlanContractType.healthPlanContractTypeId == 1 ? 'mês' : 'ano'}.',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HealthPlanContractDetails(activeContract)));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text(
                            'Ver meu plano',
                            style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ));
              } else if (snapshot.hasData &&
                  snapshot.data!.healthPlanContractId <= 0) {
                return Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 252, 252),
                      border: const Border(
                          bottom: BorderSide(color: Colors.yellow, width: 3)),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 255, 243, 132)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: const Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nenhum plano contratado.',
                              style: TextStyle(
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ));
              } else if (snapshot.hasError) {
                return const Center(
                  child:
                      Text('Erro ao carregar informações do plano contratado.'),
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColorLight,
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
