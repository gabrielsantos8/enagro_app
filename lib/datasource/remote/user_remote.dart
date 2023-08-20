import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:enagro_app/helpers/Util.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';


class UserRemote {
  final url = Util.concatenateEndpoint("user/");
  static const String _tokenKey = "userToken";

  Future<User> login(Object params) async {
    var prms = jsonEncode(params);
    var data = await GeneralHttpClient().post('${url}login', prms);
    if (data['success']) {
      saveToken(data['token']);
    }
    User user = User.fromMap(data['dados']);
    return user;
  }

  Future<User> register(Object params) async {
    var prms = jsonEncode(params);
    var data = await GeneralHttpClient().post('${url}store', prms);
    if (data['success']) {
      saveToken(data['token']);
    }
    User user = User.fromMap(data['dados']);
    return user;
  }

  Future<String> getImage(int id) async {
    var data = await GeneralHttpClient().getJson('${url}getImage/$id');
    if (data['success']) {
      return data['image_url'].toString().replaceAll('localhost', '10.0.2.2');
    }
    return 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png';
  }

  
  Future<bool> removeImage(int id) async {
    var data = await GeneralHttpClient().getJson('${url}removeImage/$id');
    return data['success'];
  }

  Future<bool> sendImage(File file, int userId) async {

    Uri urlP = Uri.parse('${url}sendImage');

    var request = http.MultipartRequest('POST', urlP);
    request.fields['user_id'] = userId.toString(); 
    request.files.add(
      await http.MultipartFile.fromPath('foto_perfil', file.path),
    );
    final response = await request.send();
    return response.statusCode == 200;
  }

  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> removeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  static Future<void> signOut() async {
    await removeToken();
  }

  static Future<bool> isAuthenticated() async {
    String? token = await getToken();
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>> getTokenInfos() async {
    String? token = await getToken();
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token!);
    return decodedToken;
  }
}
