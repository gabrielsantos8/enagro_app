import 'dart:convert';

import 'package:enagro_app/helpers/util.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/user_address.dart';

class UserAddressRemote {
  final url = Util.concatenateEndpoint("user_address/");
  
  Future<List<UserAddress>> getByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getByUser/$id');
    List<UserAddress> userAddresses = UserAddress.getAddresses(data['dados']);
    return userAddresses;
  }

  Future<bool> editAddress(Object prms) async {
    var data = await GeneralHttpClient().post('${url}update', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> saveAddress(Object prms) async {
    var data = await GeneralHttpClient().post('${url}store', jsonEncode(prms));
    return data['success'];
  }

  Future<bool> deleteAddress(Object prms) async {
    var data = await GeneralHttpClient().post('${url}destroy', jsonEncode(prms));
    return data['success'];
  }

  Future<List> comboGetByUser(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getComboByUser/$id');
    return data['dados'];
  }

}