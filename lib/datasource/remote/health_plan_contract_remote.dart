import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/health_plan_contract.dart';

class HealthPlanContractRemote {
  final url = Util.concatenateEndpoint("health_plan_contract/");
  
  Future<List<HealthPlanContract>> getByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$id');
    List<HealthPlanContract> healthPlanContracts = HealthPlanContract.fromArray(data['dados']);
    return healthPlanContracts;
  }

  
  Future<HealthPlanContract> getActiveContractByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getActiveContractByUser/$id');
    HealthPlanContract healthPlanContract = HealthPlanContract.fromMap(data['dados']);
    return healthPlanContract;
  }
}