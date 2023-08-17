import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';

class CityRemote {
  
  final url = Util.concatenateEndpoint("city/");

  Future<List> getUfs() async {
    var data = await GeneralHttpClient().getJson('${url}getUfs');
    return data['dados'];
  }

  Future<List> getCities(String uf) async {
    var data = await GeneralHttpClient().getJson('${url}getCities/$uf');
    return data['dados'];
  }
}