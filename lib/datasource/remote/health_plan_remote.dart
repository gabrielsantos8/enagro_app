import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/health_plan.dart';

class HealthPlanRemote {
  final url = Util.concatenateEndpoint("health_plan/");

  Future<List<HealthPlan>> getBestsPlansByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getBestsPlansByUser/$id');
    List<HealthPlan> healthPlans = HealthPlan.fromArray(data['dados']);
    return healthPlans;
  }

  Future<List<HealthPlan>> getAllPlansByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getBestsPlansByUser/$id');
    List<HealthPlan> healthPlans = HealthPlan.fromArray(data['dados']);
    return healthPlans;
  }
}