import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';

class AnimalSubTypeRemote {
  final url = Util.concatenateEndpoint("animal_subtype/");

  Future<List> getAnimalSubtypes() async {
    var data = await GeneralHttpClient().getJson(url);
    return data['dados'];
  }

  Future<List> getAnimalSubtypesByAnimalType(int id) async {
    var data = await GeneralHttpClient()
        .getJson('${url}getByAnimalType/$id');
    return data['dados'];
  }
}
