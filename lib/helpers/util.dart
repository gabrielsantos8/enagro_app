// ignore_for_file: file_names

class Util {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static String concatenateEndpoint(String endpoint) {
    return '$baseUrl/$endpoint';
  }
}
