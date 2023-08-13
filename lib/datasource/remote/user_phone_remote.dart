import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/user_phone.dart';

class UserPhoneRemote {
  final url = Util.concatenateEndpoint("user_phone/");

  Future<UserPhone> getByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$id');
    UserPhone userPhone = UserPhone.fromMap(data['dados'][0] ?? {});
    return userPhone;
  }

  Future<bool> editPhone(UserPhone usrPh) async {
    Object prms = {"id": usrPh.userPhoneId, "user_id": usrPh.userId, "ddd": usrPh.ddd, "number": usrPh.number};
    var data = await GeneralHttpClient().post('${url}update', jsonEncode(prms));
    return data['success'];
  }
}
