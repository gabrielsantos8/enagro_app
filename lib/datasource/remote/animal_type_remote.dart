import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';

class AnimalTypeRemote {
  final url = Util.concatenateEndpoint("animal_type/");

  Future<List> getAnimalTypes() async {
    var data = await GeneralHttpClient().getJson(url);
    return data['dados'];
  }
  

}