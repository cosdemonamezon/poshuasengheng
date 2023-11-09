
import 'package:flutter/material.dart';
import 'package:poshuasengheng/models/auth.dart';
import 'package:poshuasengheng/models/user.dart';
import 'package:poshuasengheng/screen/login/services/loginApi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends ChangeNotifier {
  LoginController({this.api = const LoginApi()});
  
  LoginApi api;
  User? user;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Auth> signIn({
    required String username,
    required String password,
  }) async {
    final data = await LoginApi.login(username, password);
    final SharedPreferences prefs = await _prefs;

    final _user = data;
    user = data.user;
    await prefs.setString('token', data.token);
    //await prefs.setString('permission', data.data!.permission_id!.toString());
    notifyListeners();
    return _user;
  }

  Future<void> clearToken() async {
    SharedPreferences prefs = await _prefs;
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    user = null;   

    notifyListeners();
  }
}