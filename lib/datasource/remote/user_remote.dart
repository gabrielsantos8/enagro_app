import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:enagro_app/infra/general_http_client.dart';
import 'package:enagro_app/models/user.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UserRemote {
  final url = "http://localhost:8000/api/user/";
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
