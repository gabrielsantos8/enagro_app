import 'dart:convert';

import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/user.dart';

class UserRemote {
  final url = "http://localhost:8000/api/user/";

  Future<User> login(Object params) async {
    var prms = jsonEncode(params);
    var dados = await GeneralHttpClient().post('${url}login', prms);
    User user = User.fromArray(dados['dados']);
    return user;
  }
}