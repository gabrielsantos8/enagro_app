import 'package:enagro_app/datasource/remote/health_plan_contract_remote.dart';
import 'package:enagro_app/datasource/remote/health_plan_remote.dart';
import 'package:enagro_app/models/health_plan.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/health_plan_contract_details.dart';
import 'package:enagro_app/ui/widgets/health_plan_card.dart';
import 'package:flip_carousel/flip_carousel.dart';
import 'package:flutter/material.dart';

class HealthPlansPage extends StatefulWidget {
  final User? user;

  const HealthPlansPage(this.user, {Key? key}) : super(key: key);

  @override
  State<HealthPlansPage> createState() => _HealthPlansPageState();
}

class _HealthPlansPageState extends State<HealthPlansPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Future<HealthPlanContract>? _futureActiveContract;
  Future<List<HealthPlan>>? _futureBestsPlansByUser;
  Future<List<HealthPlan>>? _futureAllPlansByUser;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    _futureActiveContract =
        HealthPlanContractRemote().getActiveContractByUser(widget.user!.userId);
    _futureBestsPlansByUser =
        HealthPlanRemote().getBestsPlansByUser(widget.user!.userId);
    _futureAllPlansByUser =
        HealthPlanRemote().getAllPlansByUser(widget.user!.userId);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {});
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HealthPlanContractDetails(
                                            activeContract)));
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
                              style: TextStyle(fontSize: 18),
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
          const SizedBox(
            height: 14,
          ),
          TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Para você'),
                Tab(text: 'Todos'),
              ],
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor),
          Container(
            padding: const EdgeInsets.all(16),
            height: MediaQuery.of(context).size.height * 0.80,
            child: TabBarView(controller: _tabController, children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.90,
                child: _buildBestsPlansByUserList(widget.user!.userId),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.90,
                child: _buildAllPlansByUserList(widget.user!.userId),
              )
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildBestsPlansByUserList(int userId) {
    return FutureBuilder(
      future: _futureBestsPlansByUser,
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
              List<Widget> planCards = snapshot.data!.map<Widget>((planData) {
                List<Color> colors = planData.planColors.map((colorString) {
                  return Color(int.parse(colorString, radix: 16));
                }).toList();

                return HealthPlanCard(
                  title: planData.description,
                  description: planData.detailedDescription,
                  minimalAnimals: planData.minimalAnimals,
                  maximumAnimals: planData.maximumAnimals,
                  value: planData.value,
                  services: planData.services,
                  colors: colors,
                  onPressed: () {
                    print('Detalhes do plano: ${planData.description}');
                  },
                );
              }).toList();
              return Center(
                  child: FlipCarousel(
                      items: planCards,
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: MediaQuery.of(context).size.width * 0.99,
                      isAssetImage: false,
                      fit: BoxFit.cover,
                      perspectiveFactor: 0.002,
                      layersGap: 30,
                      transitionDuration: const Duration(milliseconds: 400)));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar plano!'));
            }
            return const Center(
                child: Text(
              'Não encontramos nenhum plano para você! Por favor, cadastre seus animais para oferecermos os melhores planos',
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
        }
      },
    );
  }

  Widget _buildAllPlansByUserList(int userId) {
    return FutureBuilder(
      future: _futureAllPlansByUser,
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
              List<Widget> planCards = snapshot.data!.map<Widget>((planData) {
                List<Color> colors = planData.planColors.map((colorString) {
                  return Color(int.parse(colorString, radix: 16));
                }).toList();

                return HealthPlanCard(
                  title: planData.description,
                  description: planData.detailedDescription,
                  minimalAnimals: planData.minimalAnimals,
                  maximumAnimals: planData.maximumAnimals,
                  value: planData.value,
                  services: planData.services,
                  colors: colors,
                  onPressed: () {
                    print('Detalhes do plano: ${planData.description}');
                  },
                );
              }).toList();
              return Center(
                  child: FlipCarousel(
                      items: planCards,
                      height: MediaQuery.of(context).size.height * 0.70,
                      width: MediaQuery.of(context).size.width * 0.99,
                      isAssetImage: false,
                      fit: BoxFit.cover,
                      perspectiveFactor: 0.002,
                      layersGap: 30,
                      transitionDuration: const Duration(milliseconds: 400)));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Erro ao carregar plano!'));
            }
            return const Center(
                child: Text(
              'Não encontramos nenhum plano! Por favor, tente novamente mais tarde',
              style: TextStyle(fontWeight: FontWeight.bold),
            ));
        }
      },
    );
  }
}
