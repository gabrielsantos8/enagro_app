import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:enagro_app/datasource/remote/health_plan_contract_animal_remote.dart';
import 'package:enagro_app/datasource/remote/service_remote.dart';
import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/service.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectAnimalServices extends StatefulWidget {
  final int contractId;
  final Function(String, String, String) onSelectionChanged;
  const MultiSelectAnimalServices(
      {required this.contractId, required this.onSelectionChanged, super.key});

  @override
  MultiSelectAnimalServicesState createState() =>
      MultiSelectAnimalServicesState();
}

class MultiSelectAnimalServicesState extends State<MultiSelectAnimalServices> {
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late SingleValueDropDownController serviceController;
  String selectedAnimals = "";
  String selectedServices = "";
  String selectedServicesAndValue = "";
  List<Animal> allAnimals = [];
  List<Service> allServices = [];

  @override
  void initState() {
    serviceController = SingleValueDropDownController();
    loadAnimals();
    super.initState();
  }

  @override
  void dispose() {
    serviceController.dispose();
    super.dispose();
  }

  Future<void> loadAnimals() async {
    final animalRemote = HealthPlanContractAnimalRemote();
    List<Animal> animalList =
        await animalRemote.getByContract(widget.contractId);
    setState(() {
      allAnimals = animalList;
    });
  }

  Future<void> loadServices(String ids) async {
    final serviceRemote = ServiceRemote();
    List<Service> serviceList = await serviceRemote.getByAnimalSubtypes(ids);
    setState(() {
      allServices = serviceList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: ListView(children: [
            MultiSelectDialogField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo obrigatório!";
                  }
                  return null;
                },
                items:
                    allAnimals.map((e) => MultiSelectItem(e, e.name)).toList(),
                listType: MultiSelectListType.CHIP,
                title: const Text('Seus animais disponíveis'),
                cancelText: Text(
                  'Fechar',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                buttonText: const Text('Animais...'),
                onConfirm: (values) {
                  List<String> str = [];
                  List<String> strAnimals = [];
                  for (var anm in values) {
                    str.add(anm.animalSubType.animalSubTypeId.toString());
                    strAnimals.add(anm.animalId.toString());
                  }
                  String ids = str.join(',');
                  String idsAnimals = strAnimals.join(',');
                  setState(() {
                    selectedAnimals = idsAnimals;
                    widget.onSelectionChanged(
                        selectedAnimals, selectedServices, selectedServicesAndValue);
                  });
                  loadServices(ids);
                }),
            const SizedBox(height: 20.0),
            MultiSelectDialogField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo obrigatório!";
                }
                return null;
              },
              items: allServices
                  .map((e) => MultiSelectItem(e, e.description))
                  .toList(),
              listType: MultiSelectListType.CHIP,
              title: const Text('Seus serviços disponíveis'),
              cancelText: Text(
                'Fechar',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
              buttonText: const Text('Serviços...'),
              onConfirm: (values) {
                List<String> str = [];
                List<String> strServices = [];
                for (var svc in values) {
                  str.add(svc.serviceId.toString());
                  strServices.add('${svc.serviceId};${svc.value}');
                }
                String ids = str.join(',');
                String idsServiceValue = strServices.join(',');
                setState(() {
                  selectedServices = ids;
                  selectedServicesAndValue = idsServiceValue;
                  widget.onSelectionChanged(selectedAnimals, selectedServices, selectedServicesAndValue);
                });
              },
            ),
          ]),
        ),
      ],
    );
  }

  List<DropDownValueModel> buildDropdownItemsService(List<Service> services) {
    return services.map((service) {
      return DropDownValueModel(
        name: service.description,
        value: '${service.serviceId},${service.value}',
      );
    }).toList();
  }
}
