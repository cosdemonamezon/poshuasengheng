import 'package:poshuasengheng/constants/constants.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:poshuasengheng/models/auth.dart';

class LoginApi {
  const LoginApi();
  
  static Future<Auth> login(String username, String password,) async {
    final url = Uri.https(publicUrl, 'api/auth/login_admin');
    final response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      final data = convert.jsonDecode(response.body);
      return Auth.fromJson(data['data']);
    } else {
      final data = convert.jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }
}