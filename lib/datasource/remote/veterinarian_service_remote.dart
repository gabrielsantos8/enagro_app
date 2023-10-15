import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/service.dart';

class VeterinarianServiceRemote {
  final url = Util.concatenateEndpoint("veterinarian_service/");
  
  Future<List<Service>> getByVeterinarian(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByVeterinarian/$id');
    List<Service> serviceCities = Service.getServices(data['dados']);
    return serviceCities;
  }

  Future<List<Service>> getNotByVeterinarian(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getNotByVeterinarian/$id');
    List<Service> serviceCities = Service.getServices(data['dados']);
    return serviceCities;
  }

  Future<bool> saveService(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> deleteService(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

}