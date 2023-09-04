import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

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

  Future<bool> updateAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}update', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> deleteAnimal(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> removeImage(int id) async {
    var data = await GeneralHttpClient().getJson('${url}removeImage/$id');
    return data['success'];
  }

  Future<bool> sendImage(File file, int userId) async {

    Uri urlP = Uri.parse('${url}sendImage');

    var request = http.MultipartRequest('POST', urlP);
    request.fields['animal_id'] = userId.toString(); 
    request.files.add(
      await http.MultipartFile.fromPath('foto_animal', file.path),
    );
    final response = await request.send();
    return response.statusCode == 200;
  }

  Future<String> getImage(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getImage/$id');
    if (data['success']) {
      return data['img_url'].toString().replaceAll('localhost', '10.0.2.2');
    }
    return 'https://static.thenounproject.com/png/1554486-200.png';
  }

}