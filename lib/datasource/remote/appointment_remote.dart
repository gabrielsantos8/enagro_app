import 'dart:convert';

import 'package:enagro_app/helpers/Util.dart';
import 'package:enagro_app/infra/general_http_client.dart';

class AppointmentRemote {
  final url = Util.concatenateEndpoint("appointment/");

  Future<dynamic> createAppointment(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data;
  }
}