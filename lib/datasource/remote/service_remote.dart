import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/service.dart';

class ServiceRemote {
  final url = Util.concatenateEndpoint("service/");

  Future<List<Service>> getByAnimalSubtypes(String ids) async {
    var data = await GeneralHttpClient().getJson('${url}getByAnimalSubtypes/$ids');
    List<Service> services = Service.getServices(data['dados']);
    return services;
  }

}