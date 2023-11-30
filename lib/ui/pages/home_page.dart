import 'package:enagro_app/datasource/remote/health_plan_contract_remote.dart';
import 'package:enagro_app/datasource/remote/user_remote.dart';
import 'package:enagro_app/models/health_plan_contract.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/about_page.dart';
import 'package:enagro_app/ui/pages/animal_page.dart';
import 'package:enagro_app/ui/pages/health_plan_contract_details.dart';
import 'package:enagro_app/ui/pages/health_plans_page.dart';
import 'package:enagro_app/ui/pages/partners_page.dart';
import 'package:enagro_app/ui/pages/user_activation_page.dart';
import 'package:enagro_app/ui/pages/user_page.dart';
import 'package:enagro_app/ui/widgets/default_drawer_item.dart';
import 'package:enagro_app/ui/widgets/default_home_item.dart';
import 'package:enagro_app/ui/widgets/default_outline_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage(this.user, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<String> userProfileImageUrl;
  late Future<HealthPlanContract> hpContract;

  @override
  void initState() {
    super.initState();
    userProfileImageUrl = _loadUserProfileImage();
    hpContract = _loadUserHealthPlanContract();
  }

  void refreshData() {
    setState(() {
      userProfileImageUrl = _loadUserProfileImage();
    });
  }

  Future<String> _loadUserProfileImage() async {
    UserRemote userRemote = UserRemote();
    return userRemote.getImage(widget.user!.userId);
  }

  Future<HealthPlanContract> _loadUserHealthPlanContract() async {
    HealthPlanContractRemote contractRemote = HealthPlanContractRemote();
    return contractRemote.getActiveContractByUser(widget.user!.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColorDark),
            leading: Builder(builder: ((context) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Theme.of(context).primaryColorDark,
                  size: 44,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            }))),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.zero,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 150, 50),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: userProfileImageUrl,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).primaryColor,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            );
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
                      const SizedBox(height: 10),
                      Text(
                        widget.user!.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      DefaultOutlineButton(
                        'Ver perfil',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPage(widget.user,
                                    onUserEdited: refreshData)),
                          );
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 150, 50)),
                      ),
                      DefaultOutlineButton(
                        'Meus animais',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AnimalPage(widget.user)),
                          );
                        },
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 150, 50)),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 7),
              DefaultDrawerItem(
                  Icons.local_hospital_outlined, 'Plano de saúde animal', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HealthPlansPage(widget.user)));
              }),
              DefaultDrawerItem(
                  Icons.warning_amber_outlined, 'Meus acionamentos', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UserActivationPage(widget.user)));
              }),
              DefaultDrawerItem(Icons.business, 'Parceiros', () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PartnersPage(widget.user)));
              }),
              const Spacer(),
              DefaultDrawerItem(Icons.info_outline, 'Sobre a Enagro', () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutPage())),
                  div: false),
            ],
          ),
        ),
        body: FutureBuilder<HealthPlanContract>(
          future: hpContract,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).primaryColorLight,
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Erro ao carregar plano');
            } else {
              if (snapshot.hasData && snapshot.data!.healthPlanContractId > 0) {
                List<Color> colors =
                    snapshot.data!.healthPlan.planColors.map((colorString) {
                  return Color(int.parse(colorString, radix: 16));
                }).toList();

                return ListView(
                  children: [
                    Container(
                      height: 65,
                      decoration:
                          BoxDecoration(color: Theme.of(context).primaryColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25, bottom: 25),
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/logo_enagro_white.png',
                                  width: 35,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Olá, ${widget.user?.name.split(' ')[0]}!',
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Container(
                                  height: 40,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: colors,
                                      )),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => HealthPlanContractDetails(snapshot.data!, widget.user)));
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      splashFactory: NoSplash.splashFactory,
                                    ),
                                    child: Center(
                                        child: Text(
                                      snapshot.data!.healthPlan.description,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    DefaultHomeItem(
                        iconData: Icons.local_hospital_outlined,
                        title: 'Plano de Saúde Animal',
                        description: snapshot.data!.healthPlan.description,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HealthPlansPage(widget.user)));
                        })
                  ],
                );
              }

              return ListView(
                children: [
                  Container(
                    height: 65,
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 25),
                          child: Row(
                            children: [
                              Image.asset(
                                'images/logo_enagro_white.png',
                                width: 35,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Olá, ${widget.user?.name.split(' ')[0]}!',
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                height: 40,
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [Colors.green, Colors.green],
                                    )),
                                child: const Text(
                                  'Nenhum plano!',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  DefaultHomeItem(
                      iconData: Icons.local_hospital_outlined,
                      title: 'Plano de Saúde Animal',
                      description: 'Nenhum plano de saúde animal contratado.',
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HealthPlansPage(widget.user)));
                      })
                ],
              );
            }
          },
        ));
  }
}
