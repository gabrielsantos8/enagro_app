import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/animal.dart';

class HealthPlanContractAnimalRemote {
  final url = Util.concatenateEndpoint("health_plan_contract_animal/");

  Future<List<Animal>> getByContract(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByContract/$id');
    List<Animal> animals = Animal.getAnimals(data['dados']);
    return animals;
  }

  Future<bool> deleteContractAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

  Future<List<Animal>> getAnimalsToAddByUser(int userId, int contractId) async {
    var data = await GeneralHttpClient().getJson('${url}getAnimalsToAddByUser/$userId/$contractId');
    List<Animal> animals = Animal.getAnimals(data['dados']);
    return animals;
  }
}