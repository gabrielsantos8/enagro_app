import 'package:auto_animated_list/auto_animated_list.dart';
import 'package:enagro_app/models/health_plan.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user.dart';
import 'package:enagro_app/ui/pages/signature_page.dart';
import 'package:flutter/material.dart';

class HealthPlanDetails extends StatefulWidget {
  final HealthPlan plan;
  final User? user;
  const HealthPlanDetails(this.plan, this.user, {super.key});

  @override
  State<HealthPlanDetails> createState() => _HealthPlanDetailsState();
}

class _HealthPlanDetailsState extends State<HealthPlanDetails> {
  late List<Color> colors;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(children: [
        SizedBox(
          child: Container(
            child: _buildDetailsPlan(),
          ),
        )
      ]),
    );
  }

  Widget _buildDetailsPlan() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.90,
      child: Center(
        child: Column(children: [
          Text(
            widget.plan.description,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            widget.plan.detailedDescription,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Entre ${widget.plan.minimalAnimals}-${widget.plan.maximumAnimals} animais.',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            'Você paga R\$${widget.plan.value.toStringAsFixed(2)} por mês (R\$${(widget.plan.value * 12).toStringAsFixed(2)} por ano).',
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Serviços:',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
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
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 221, 221, 221),
                      spreadRadius: 2,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ]),
              child: AutoAnimatedList<Service>(
                items: widget.plan.services,
                itemBuilder: (context, record, index, animation) {
                  return SizeFadeTransition(
                    animation: animation,
                    child: ListTile(
                      iconColor: const Color.fromARGB(255, 0, 0, 0),
                      leading: const Icon(Icons.medical_services_outlined),
                      title: Text(
                        record.description,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignaturePage(widget.plan, widget.user)));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            child: Text(
              'Assinar',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
    );
  }
}
