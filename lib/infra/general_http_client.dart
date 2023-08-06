import 'dart:convert';
import 'package:http/http.dart' as http;

class GeneralHttpClient {
  Future<dynamic> getJson(String url) async {
    var response = await http.get(Uri.parse(url));
    return json.decode(response.body);
  }

  Future<dynamic> post(String url, Object body) async {
    var response = await http.post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: body);
    return json.decode(response.body);
  }
}
