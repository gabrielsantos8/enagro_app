import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/animal.dart';

class AnimalRemote {
  final url = Util.concatenateEndpoint("animal/");
  
  Future<List<Animal>> getByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$id');
    List<Animal> animals = Animal.getAnimals(data['dados']);
    return animals;
  }

  Future<bool> editAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}update', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> saveAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> deleteAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

}