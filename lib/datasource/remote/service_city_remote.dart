import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/service_city.dart';

class ServiceCityRemote {
  final url = Util.concatenateEndpoint("service_city/");
  
  Future<List<ServiceCity>> getByVeterinarian(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByVeterinarian/$id');
    List<ServiceCity> serviceCities = ServiceCity.getServiceCities(data['dados']);
    return serviceCities;
  }

  Future<List<ServiceCity>> getByUf(int id, String uf) async {
    var data = await GeneralHttpClient().getJson('${url}getByUf/$id/$uf');
    List<ServiceCity> serviceCities = ServiceCity.getServiceCities(data['dados']);
    return serviceCities;
  }

  Future<bool> editServiceCity(Object prms) async {
    var data = await GeneralHttpClient().post('${url}update', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> saveServiceCity(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> deleteServiceCity(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

}