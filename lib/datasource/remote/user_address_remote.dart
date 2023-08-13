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


}