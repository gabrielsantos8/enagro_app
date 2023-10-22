import 'dart:convert';

import 'package:enagro_app/helpers/Util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/activation.dart';

class ActivationRemote {
  final url = Util.concatenateEndpoint("activation/");

  Future<bool> createActivation(Object prms) async {
    var data = await GeneralHttpClient().post('${url}createActivation', jsonEncode(prms));
    return data['success'];
  }

  Future<List<Activation>> getByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$id');
    List<Activation> activations = Activation.fromArray(data['dados']);
    return activations;
  }
}
