import 'dart:convert';

import 'package:enagro_app/models/veterinarian.dart';
import 'package:enagro_app/helpers/Util.dart';
import 'package:enagro_app/infra/general_http_client.dart';


class VeterinarianRemote {
  final url = Util.concatenateEndpoint("veterinarian/");

  Future<Veterinarian> getByUser(int userId) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$userId');
    Veterinarian vet = Veterinarian.fromMap(data['dados'].length > 0 ? data['dados'][0] : {});
    return vet;
  }

   Future<bool> saveVeterinarian(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data['success'];
  }
}