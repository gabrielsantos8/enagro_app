import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/installment.dart';

class HealthPlanContractInstallmentRemote {
  final url = Util.concatenateEndpoint("health_plan_contract_installment/");

  Future<List<Installment>> getByContract(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByContract/$id');
    List<Installment> animals = Installment.getInstallment(data['dados']);
    return animals;
  }
}