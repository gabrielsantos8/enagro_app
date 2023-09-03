import 'package:enagro_app/datasource/remote/veterinarian_remote.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/ui/pages/veterinarian_create_page.dart';
import 'package:enagro_app/ui/pages/veterinarian_page.dart';
import 'package:enagro_app/ui/widgets/default_button.dart';
import 'package:flutter/material.dart';

class VeterinaryExplanation extends StatefulWidget {
  final User? user;
  const VeterinaryExplanation(this.user, {super.key});

  @override
  State<VeterinaryExplanation> createState() => _VeterinaryExplanationState();
}

class _VeterinaryExplanationState extends State<VeterinaryExplanation> {
  late bool isVet = false;

  @override
  void initState() {
    super.initState();
    _isVeterinarian();
  }

  void _isVeterinarian() async {
    VeterinarianRemote vetRemote = VeterinarianRemote();
    Veterinarian vet = await vetRemote.getByUser(widget.user!.userId);
    if (vet.userVeterinarianId > 0) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VeterinarianPage(widget.user, vet)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Eu, ',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'veterinário.',
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                      'A função "Eu, veterinário" é uma característica essencial da Enagro, projetada para conectar os profissionais veterinários qualificados aos proprietários de animais que necessitam de atendimento médico. Se você é um veterinário registrado e possui um CRMV válido, você pode se inscrever na Enagro para participar dos planos de saúde animal oferecidos.',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      'Ao se cadastrar na Enagro, você se torna elegível para se candidatar a diferentes planos de saúde animal. Quando um plano é acionado e um animal necessita de atendimento médico, você receberá notificações instantâneas para realizar o atendimento. Essa abordagem eficaz e ágil garante que os animais recebam a assistência de que precisam no momento certo.',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                      'Além de proporcionar um serviço crucial aos animais, a função "Eu, veterinário" também oferece benefícios aos profissionais. Ao participar dos planos de saúde animal, você terá a oportunidade de expandir sua base de clientes e aumentar sua visibilidade na comunidade. Além disso, o aplicativo Enagro simplifica o processo de recebimento de pagamentos pelo atendimento prestado, tornando todo o procedimento mais conveniente.',
                      style: TextStyle(fontSize: 16)),
                  SizedBox(
                    height: 25,
                  ),
                ],
              ),
              DefaultButton(
                  'Vamos lá!',
                  () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                VeterinarianCreatePage(widget.user)),
                      )),
            ],
          ),
        ),
      ),
    );
  }
}
