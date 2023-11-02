import 'dart:convert';

import 'package:enagro_app/helpers/Util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/appointment.dart';

class AppointmentRemote {
  final url = Util.concatenateEndpoint("appointment/");

  Future<dynamic> createAppointment(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data;
  }

  Future<Appointment> getByActivation(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByActivation/${id}');
    Appointment appnt = Appointment.fromMap(data['dados'][0]);
    return appnt;
  }
}