import 'dart:convert';

import 'package:enagro_app/helpers/Util.dart';
import 'package:enagro_app/infra/general_http_client.dart';

class ActivationRemote {
  final url = Util.concatenateEndpoint("activation/");

  Future<bool> createActivation(Object prms) async {
    var data = await GeneralHttpClient().post('${url}createActivation', jsonEncode(prms));
    return data['success'];
  }
}
